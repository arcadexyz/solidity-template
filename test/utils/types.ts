import { BigNumberish } from "ethers";

export interface BuyItem {
    nftAddress: string;
    tokenId: BigNumberish;
    owner: string;
    quantity: BigNumberish;
    maxPricePerItem: BigNumberish;
    paymentToken: string;
    usingEth: boolean;
}
