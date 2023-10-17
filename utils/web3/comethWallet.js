import { ComethWallet, ConnectAdaptor, SupportedNetworks, ComethProvider } from "@cometh/connect-sdk";

const COMETH_API_KEY = process.env.COMETH_API_KEY ?? "";

export const walletAdaptor = new ConnectAdaptor({
    chainId: SupportedNetworks.FUJI,
    apiKey: COMETH_API_KEY,
});

export const instance = new ComethWallet({
    authAdapter: walletAdaptor,
    apiKey: COMETH_API_KEY,
});