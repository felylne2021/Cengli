/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumberish,
  BytesLike,
  FunctionFragment,
  Result,
  Interface,
  EventFragment,
  AddressLike,
  ContractRunner,
  ContractMethod,
  Listener,
} from "ethers";
import type {
  TypedContractEvent,
  TypedDeferredTopicFilter,
  TypedEventLog,
  TypedLogDescription,
  TypedListener,
  TypedContractMethod,
} from "../../common";

export interface IInterchainGasPaymasterInterface extends Interface {
  getFunction(
    nameOrSignature: "payForGas" | "quoteGasPayment"
  ): FunctionFragment;

  getEvent(nameOrSignatureOrTopic: "GasPayment"): EventFragment;

  encodeFunctionData(
    functionFragment: "payForGas",
    values: [BytesLike, BigNumberish, BigNumberish, AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "quoteGasPayment",
    values: [BigNumberish, BigNumberish]
  ): string;

  decodeFunctionResult(functionFragment: "payForGas", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "quoteGasPayment",
    data: BytesLike
  ): Result;
}

export namespace GasPaymentEvent {
  export type InputTuple = [
    messageId: BytesLike,
    gasAmount: BigNumberish,
    payment: BigNumberish
  ];
  export type OutputTuple = [
    messageId: string,
    gasAmount: bigint,
    payment: bigint
  ];
  export interface OutputObject {
    messageId: string;
    gasAmount: bigint;
    payment: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export interface IInterchainGasPaymaster extends BaseContract {
  connect(runner?: ContractRunner | null): IInterchainGasPaymaster;
  waitForDeployment(): Promise<this>;

  interface: IInterchainGasPaymasterInterface;

  queryFilter<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;
  queryFilter<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;

  on<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  on<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  once<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  once<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  listeners<TCEvent extends TypedContractEvent>(
    event: TCEvent
  ): Promise<Array<TypedListener<TCEvent>>>;
  listeners(eventName?: string): Promise<Array<Listener>>;
  removeAllListeners<TCEvent extends TypedContractEvent>(
    event?: TCEvent
  ): Promise<this>;

  payForGas: TypedContractMethod<
    [
      _messageId: BytesLike,
      _destinationDomain: BigNumberish,
      _gasAmount: BigNumberish,
      _refundAddress: AddressLike
    ],
    [void],
    "payable"
  >;

  quoteGasPayment: TypedContractMethod<
    [_destinationDomain: BigNumberish, _gasAmount: BigNumberish],
    [bigint],
    "view"
  >;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "payForGas"
  ): TypedContractMethod<
    [
      _messageId: BytesLike,
      _destinationDomain: BigNumberish,
      _gasAmount: BigNumberish,
      _refundAddress: AddressLike
    ],
    [void],
    "payable"
  >;
  getFunction(
    nameOrSignature: "quoteGasPayment"
  ): TypedContractMethod<
    [_destinationDomain: BigNumberish, _gasAmount: BigNumberish],
    [bigint],
    "view"
  >;

  getEvent(
    key: "GasPayment"
  ): TypedContractEvent<
    GasPaymentEvent.InputTuple,
    GasPaymentEvent.OutputTuple,
    GasPaymentEvent.OutputObject
  >;

  filters: {
    "GasPayment(bytes32,uint256,uint256)": TypedContractEvent<
      GasPaymentEvent.InputTuple,
      GasPaymentEvent.OutputTuple,
      GasPaymentEvent.OutputObject
    >;
    GasPayment: TypedContractEvent<
      GasPaymentEvent.InputTuple,
      GasPaymentEvent.OutputTuple,
      GasPaymentEvent.OutputObject
    >;
  };
}
