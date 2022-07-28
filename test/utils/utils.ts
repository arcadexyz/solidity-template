import { BuyItem } from "./types";
import { ethers } from "hardhat";


export const encodeBytesData = (items: BuyItem[]): string => {
    const types = ["(address,uint256,address,uint64,uint128,address,bool)[]"];
    const values = items.map(item => [
        item.nftAddress,
        item.tokenId,
        item.owner,
        item.quantity,
        item.maxPricePerItem,
        item.paymentToken,
        item.usingEth
    ]);

    return ethers.utils.defaultAbiCoder.encode(types, [values]);
};
