-- File auto generated by purescript-bridge! --
module Wallet.Emulator.LogMessages where

import Prelude

import Control.Lazy (defer)
import Data.Argonaut (encodeJson, jsonNull)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Aeson ((</$\>), (</*\>), (</\>))
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Aeson ((>$<), (>/\<))
import Data.Generic.Rep (class Generic)
import Data.Lens (Iso', Lens', Prism', iso, prism')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Record (prop)
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.Show.Generic (genericShow)
import Data.Tuple.Nested ((/\))
import Ledger.Constraints.OffChain (UnbalancedTx)
import Ledger.Tx (CardanoTx)
import Plutus.V1.Ledger.Address (Address)
import Plutus.V1.Ledger.Slot (Slot)
import Plutus.V1.Ledger.Value (Value)
import Type.Proxy (Proxy(Proxy))
import Wallet.Emulator.Error (WalletAPIError)
import Data.Argonaut.Decode.Aeson as D
import Data.Argonaut.Encode.Aeson as E
import Data.Map as Map

data RequestHandlerLogMsg
  = SlotNoticationTargetVsCurrent Slot Slot
  | StartWatchingContractAddresses
  | HandleTxFailed WalletAPIError
  | UtxoAtFailed Address

instance Show RequestHandlerLogMsg where
  show a = genericShow a

instance EncodeJson RequestHandlerLogMsg where
  encodeJson = defer \_ -> case _ of
    SlotNoticationTargetVsCurrent a b -> E.encodeTagged "SlotNoticationTargetVsCurrent" (a /\ b) (E.tuple (E.value >/\< E.value))
    StartWatchingContractAddresses -> encodeJson { tag: "StartWatchingContractAddresses", contents: jsonNull }
    HandleTxFailed a -> E.encodeTagged "HandleTxFailed" a E.value
    UtxoAtFailed a -> E.encodeTagged "UtxoAtFailed" a E.value

instance DecodeJson RequestHandlerLogMsg where
  decodeJson = defer \_ -> D.decode
    $ D.sumType "RequestHandlerLogMsg"
    $ Map.fromFoldable
        [ "SlotNoticationTargetVsCurrent" /\ D.content (D.tuple $ SlotNoticationTargetVsCurrent </$\> D.value </*\> D.value)
        , "StartWatchingContractAddresses" /\ pure StartWatchingContractAddresses
        , "HandleTxFailed" /\ D.content (HandleTxFailed <$> D.value)
        , "UtxoAtFailed" /\ D.content (UtxoAtFailed <$> D.value)
        ]

derive instance Generic RequestHandlerLogMsg _

--------------------------------------------------------------------------------

_SlotNoticationTargetVsCurrent :: Prism' RequestHandlerLogMsg { a :: Slot, b :: Slot }
_SlotNoticationTargetVsCurrent = prism' (\{ a, b } -> (SlotNoticationTargetVsCurrent a b)) case _ of
  (SlotNoticationTargetVsCurrent a b) -> Just { a, b }
  _ -> Nothing

_StartWatchingContractAddresses :: Prism' RequestHandlerLogMsg Unit
_StartWatchingContractAddresses = prism' (const StartWatchingContractAddresses) case _ of
  StartWatchingContractAddresses -> Just unit
  _ -> Nothing

_HandleTxFailed :: Prism' RequestHandlerLogMsg WalletAPIError
_HandleTxFailed = prism' HandleTxFailed case _ of
  (HandleTxFailed a) -> Just a
  _ -> Nothing

_UtxoAtFailed :: Prism' RequestHandlerLogMsg Address
_UtxoAtFailed = prism' UtxoAtFailed case _ of
  (UtxoAtFailed a) -> Just a
  _ -> Nothing

--------------------------------------------------------------------------------

data TxBalanceMsg
  = BalancingUnbalancedTx UnbalancedTx
  | NoOutputsAdded
  | AddingPublicKeyOutputFor Value
  | NoInputsAdded
  | AddingInputsFor Value
  | NoCollateralInputsAdded
  | AddingCollateralInputsFor Value
  | FinishedBalancing CardanoTx
  | SigningTx CardanoTx
  | SubmittingTx CardanoTx

instance Show TxBalanceMsg where
  show a = genericShow a

instance EncodeJson TxBalanceMsg where
  encodeJson = defer \_ -> case _ of
    BalancingUnbalancedTx a -> E.encodeTagged "BalancingUnbalancedTx" a E.value
    NoOutputsAdded -> encodeJson { tag: "NoOutputsAdded", contents: jsonNull }
    AddingPublicKeyOutputFor a -> E.encodeTagged "AddingPublicKeyOutputFor" a E.value
    NoInputsAdded -> encodeJson { tag: "NoInputsAdded", contents: jsonNull }
    AddingInputsFor a -> E.encodeTagged "AddingInputsFor" a E.value
    NoCollateralInputsAdded -> encodeJson { tag: "NoCollateralInputsAdded", contents: jsonNull }
    AddingCollateralInputsFor a -> E.encodeTagged "AddingCollateralInputsFor" a E.value
    FinishedBalancing a -> E.encodeTagged "FinishedBalancing" a E.value
    SigningTx a -> E.encodeTagged "SigningTx" a E.value
    SubmittingTx a -> E.encodeTagged "SubmittingTx" a E.value

instance DecodeJson TxBalanceMsg where
  decodeJson = defer \_ -> D.decode
    $ D.sumType "TxBalanceMsg"
    $ Map.fromFoldable
        [ "BalancingUnbalancedTx" /\ D.content (BalancingUnbalancedTx <$> D.value)
        , "NoOutputsAdded" /\ pure NoOutputsAdded
        , "AddingPublicKeyOutputFor" /\ D.content (AddingPublicKeyOutputFor <$> D.value)
        , "NoInputsAdded" /\ pure NoInputsAdded
        , "AddingInputsFor" /\ D.content (AddingInputsFor <$> D.value)
        , "NoCollateralInputsAdded" /\ pure NoCollateralInputsAdded
        , "AddingCollateralInputsFor" /\ D.content (AddingCollateralInputsFor <$> D.value)
        , "FinishedBalancing" /\ D.content (FinishedBalancing <$> D.value)
        , "SigningTx" /\ D.content (SigningTx <$> D.value)
        , "SubmittingTx" /\ D.content (SubmittingTx <$> D.value)
        ]

derive instance Generic TxBalanceMsg _

--------------------------------------------------------------------------------

_BalancingUnbalancedTx :: Prism' TxBalanceMsg UnbalancedTx
_BalancingUnbalancedTx = prism' BalancingUnbalancedTx case _ of
  (BalancingUnbalancedTx a) -> Just a
  _ -> Nothing

_NoOutputsAdded :: Prism' TxBalanceMsg Unit
_NoOutputsAdded = prism' (const NoOutputsAdded) case _ of
  NoOutputsAdded -> Just unit
  _ -> Nothing

_AddingPublicKeyOutputFor :: Prism' TxBalanceMsg Value
_AddingPublicKeyOutputFor = prism' AddingPublicKeyOutputFor case _ of
  (AddingPublicKeyOutputFor a) -> Just a
  _ -> Nothing

_NoInputsAdded :: Prism' TxBalanceMsg Unit
_NoInputsAdded = prism' (const NoInputsAdded) case _ of
  NoInputsAdded -> Just unit
  _ -> Nothing

_AddingInputsFor :: Prism' TxBalanceMsg Value
_AddingInputsFor = prism' AddingInputsFor case _ of
  (AddingInputsFor a) -> Just a
  _ -> Nothing

_NoCollateralInputsAdded :: Prism' TxBalanceMsg Unit
_NoCollateralInputsAdded = prism' (const NoCollateralInputsAdded) case _ of
  NoCollateralInputsAdded -> Just unit
  _ -> Nothing

_AddingCollateralInputsFor :: Prism' TxBalanceMsg Value
_AddingCollateralInputsFor = prism' AddingCollateralInputsFor case _ of
  (AddingCollateralInputsFor a) -> Just a
  _ -> Nothing

_FinishedBalancing :: Prism' TxBalanceMsg CardanoTx
_FinishedBalancing = prism' FinishedBalancing case _ of
  (FinishedBalancing a) -> Just a
  _ -> Nothing

_SigningTx :: Prism' TxBalanceMsg CardanoTx
_SigningTx = prism' SigningTx case _ of
  (SigningTx a) -> Just a
  _ -> Nothing

_SubmittingTx :: Prism' TxBalanceMsg CardanoTx
_SubmittingTx = prism' SubmittingTx case _ of
  (SubmittingTx a) -> Just a
  _ -> Nothing
