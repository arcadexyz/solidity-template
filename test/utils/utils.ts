import { ethers } from "hardhat";
import type { BuyItem, BasicOrderParameters } from "../types/types";

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

export const encodeBasicOrderSeaportV2 = (item: BasicOrderParameters): string => {
    const types = ["tuple(address,uint256,uint256,address,address,address,uint256,uint256,uint8,uint256,uint256,bytes32,uint256,bytes32,bytes32,uint256,tuple(uint256,address)[],bytes)"];
    const additionalRecipientsArray = item.additionalRecipients.map(e => [e.amount, e.recipient]);
    const values = [
        item.considerationToken,
        item.considerationIdentifier,
        item.considerationAmount,
        item.offerer,
        item.zone,
        item.offerToken,
        item.offerIdentifier,
        item.offerAmount,
        item.basicOrderType,
        item.startTime,
        item.endTime,
        item.zoneHash,
        item.salt,
        item.offererConduitKey,
        item.fulfillerConduitKey,
        item.totalOriginalAdditionalRecipients,
        additionalRecipientsArray,
        item.signature
    ];
    //console.log(values)
    return ethers.utils.defaultAbiCoder.encode(types, [values]);
}
