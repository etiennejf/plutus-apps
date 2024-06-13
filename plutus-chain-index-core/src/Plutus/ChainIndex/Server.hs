{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MonoLocalBinds   #-}
{-# LANGUAGE RankNTypes       #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators    #-}
module Plutus.ChainIndex.Server(
    serveChainIndexQueryServer,
    serveChainIndex) where

import Control.Monad ((>=>))
import Control.Monad.Except qualified as E
import Control.Monad.Freer (Eff, Member, type (~>))
import Control.Monad.Freer.Error (Error, runError, throwError)
import Control.Monad.Freer.Extras.Modify (raiseEnd)
import Control.Monad.IO.Class (MonadIO (liftIO))
import Data.Monoid (Endo (Endo, appEndo))
import Data.ByteString.Lazy qualified as BSL
import Data.Default (Default (def))
import Data.Maybe (fromMaybe)
import Data.Proxy (Proxy (..))
import Data.Text qualified as Text
import Data.Text.Encoding qualified as Text
import Network.Wai.Handler.Warp qualified as Warp
import Network.Wai.Middleware.Gzip qualified as Gzip
import Plutus.ChainIndex (RunRequirements, runChainIndexEffects)
import Plutus.ChainIndex.Api (API, FromHashAPI, FullAPI, QueryAtAddressRequest (QueryAtAddressRequest),
                              TxoAtAddressRequest (TxoAtAddressRequest), UtxoAtAddressRequest (UtxoAtAddressRequest),
                              UtxoWithCurrencyRequest (UtxoWithCurrencyRequest), swagger)
import Plutus.ChainIndex.Effects (ChainIndexControlEffect, ChainIndexQueryEffect)
import Plutus.ChainIndex.Effects qualified as E
import Servant.API ((:<|>) (..))
import Servant.API.ContentTypes (NoContent (..))
import Servant.Server (Handler, ServerError, ServerT, err404, err500, errBody, hoistServer, serve)

serveChainIndexQueryServer ::
    Int -- ^ Port
    -> RunRequirements
    -> IO ()
serveChainIndexQueryServer port runReq = do
    let server = hoistServer (Proxy @API) (runChainIndexQuery runReq) serveChainIndex
    Warp.run port $ middleware (serve (Proxy @FullAPI) (server :<|> swagger))

  where gzipMiddleware = Gzip.gzip def { Gzip.gzipSizeThreshold = 1024 }
        middleware = appEndo $ foldMap Endo [gzipMiddleware]

runChainIndexQuery ::
    RunRequirements
    -> Eff '[Error ServerError, ChainIndexQueryEffect, ChainIndexControlEffect] ~> Handler
runChainIndexQuery runReq action = do
    result <- liftIO $ runChainIndexEffects runReq $ runError $ raiseEnd action
    case result of
        Right (Right a) -> pure a
        Right (Left e) -> E.throwError e
        Left e' ->
            let err = err500 { errBody = BSL.fromStrict $ Text.encodeUtf8 $ Text.pack $ show e' } in
            E.throwError err

serveChainIndex ::
    forall effs.
    ( Member (Error ServerError) effs
    , Member ChainIndexQueryEffect effs
    , Member ChainIndexControlEffect effs
    )
    => ServerT API (Eff effs)
serveChainIndex =
    pure NoContent
    :<|> serveFromHashApi
    :<|> (E.txOutFromRef >=> handleMaybe)
    :<|> (E.unspentTxOutFromRef >=> handleMaybe)
    :<|> (E.txFromTxId >=> handleMaybe)
    :<|> E.utxoSetMembership
    :<|> (\(UtxoAtAddressRequest pq c) -> E.utxoSetAtAddress (fromMaybe def pq) c)
    :<|> (\(QueryAtAddressRequest pq c) -> E.unspentTxOutSetAtAddress (fromMaybe def pq) c)
    :<|> (\(QueryAtAddressRequest pq c) -> E.datumsAtAddress (fromMaybe def pq) c)
    :<|> (\(UtxoWithCurrencyRequest pq c) -> E.utxoSetWithCurrency (fromMaybe def pq) c)
    :<|> E.txsFromTxIds
    :<|> (\(TxoAtAddressRequest pq c) -> E.txoSetAtAddress (fromMaybe def pq) c)
    :<|> E.getTip
    :<|> E.collectGarbage *> pure NoContent
    :<|> E.getDiagnostics

serveFromHashApi ::
    forall effs.
    ( Member (Error ServerError) effs
    , Member ChainIndexQueryEffect effs
    )
    => ServerT FromHashAPI (Eff effs)
serveFromHashApi =
    (E.datumFromHash >=> handleMaybe)
    :<|> (E.validatorFromHash >=> handleMaybe)
    :<|> (E.mintingPolicyFromHash >=> handleMaybe)
    :<|> (E.stakeValidatorFromHash >=> handleMaybe)
    :<|> (E.redeemerFromHash >=> handleMaybe)

-- | Return the value of throw a 404 error
handleMaybe :: forall effs. Member (Error ServerError) effs => Maybe ~> Eff effs
handleMaybe = maybe (throwError err404) pure
