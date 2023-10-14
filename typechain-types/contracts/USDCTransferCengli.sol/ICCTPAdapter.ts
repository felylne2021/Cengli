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
  ContractRunner,
  ContractMethod,
  Listener,
} from "ethers";
import type {
  TypedContractEvent,
  TypedDeferredTopicFilter,
  TypedEventLog,
  TypedListener,
  TypedContractMethod,
} from "../../common";

export interface ICCTPAdapterInterface extends Interface {
  getFunction(
    nameOrSignature: "gasAmount" | "transferRemote"
  ): FunctionFragment;

  encodeFunctionData(functionFragment: "gasAmount", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "transferRemote",
    values: [BigNumberish, BytesLike, BigNumberish]
  ): string;

  decodeFunctionResult(functionFragment: "gasAmount", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "transferRemote",
    data: BytesLike
  ): Result;
}

export interface ICCTPAdapter extends BaseContract {
  connect(runner?: ContractRunner | null): ICCTPAdapter;
  waitForDeployment(): Promise<this>;

  interface: ICCTPAdapterInterface;

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

  gasAmount: TypedContractMethod<[], [bigint], "view">;

  transferRemote: TypedContractMethod<
    [
      _destinationDomain: BigNumberish,
      _recipientAddress: BytesLike,
      _amount: BigNumberish
    ],
    [string],
    "payable"
  >;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "gasAmount"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "transferRemote"
  ): TypedContractMethod<
    [
      _destinationDomain: BigNumberish,
      _recipientAddress: BytesLike,
      _amount: BigNumberish
    ],
    [string],
    "payable"
  >;

  filters: {};
}
