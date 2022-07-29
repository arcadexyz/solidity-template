import { ethers } from "hardhat";
import type { BuyItem } from "./types";

export const encodeBytesDataTreasureV2 = (items: BuyItem[]): string => {
    const types = ["tuple(address nftAddress,uint256 tokenId,address owner,uint64 quantity,uint128 maxPricePerItem,address paymentToken,bool usingEth)[]"];
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
