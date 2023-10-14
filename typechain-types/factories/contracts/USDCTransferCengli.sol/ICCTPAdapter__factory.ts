/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Interface, type ContractRunner } from "ethers";
import type {
  ICCTPAdapter,
  ICCTPAdapterInterface,
} from "../../../contracts/USDCTransferCengli.sol/ICCTPAdapter";

const _abi = [
  {
    inputs: [],
    name: "gasAmount",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint32",
        name: "_destinationDomain",
        type: "uint32",
      },
      {
        internalType: "bytes32",
        name: "_recipientAddress",
        type: "bytes32",
      },
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
    ],
    name: "transferRemote",
    outputs: [
      {
        internalType: "bytes32",
        name: "messageId",
        type: "bytes32",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
] as const;

export class ICCTPAdapter__factory {
  static readonly abi = _abi;
  static createInterface(): ICCTPAdapterInterface {
    return new Interface(_abi) as ICCTPAdapterInterface;
  }
  static connect(
    address: string,
    runner?: ContractRunner | null
  ): ICCTPAdapter {
    return new Contract(address, _abi, runner) as unknown as ICCTPAdapter;
  }
}
