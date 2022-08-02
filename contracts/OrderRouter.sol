// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import "./IOrderRouter.sol";
//import "./IPunks.sol";

import "./marketplaces/TreasureMarketplace.sol";
import "./marketplaces/SeaportInterface.sol";
import "./OrderRouterLibrary.sol";

import {
    OR_ZeroAddress,
    OR_MarketplaceNotWhitelisted,
    OR_CallToMarketplaceFailed
} from "./OrderRouterErrors.sol";

import "hardhat/console.sol";

contract OrderRouter is
    IOrderRouter,
    Pausable,
    Ownable
{
    // ============================================ STATE ==============================================

    using SafeERC20 for IERC20;

    // ========================================== CONSTRUCTOR ===========================================

    constructor() {}

    // ======================================== Admin Functions =========================================

    /**
     * @notice Pauses the contract, preventing loan lifecyle operations.
     *         Should only be used in case of emergency. Can only be called
     *         by contract owner.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @notice Unpauses the contract, enabling loan lifecycle operations.
     *         Can be used after pausing due to emergency or during contract
     *         upgrade. Can only be called by contract owner.
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    // ======================================== Order Routing =========================================

    /**
     * @notice Authorization function to define whether a contract upgrade should be allowed.
     *
     * @param protocol                  Marketplace protcol the caller wants to interact with
     * @param targetAddress             Address to call containing the latest protocol implementation
     * @param data                      Data that holds the order/ listing info which will be used by the
     *                                  target protocol to fulfill an open marketplace order/ listing
     */
    function fulfillOrder(
        OrderRouterLibrary.Protocol protocol,
        address targetAddress,
        bytes calldata data
    ) external override returns (bool) {
        /// Checks
        // validate marketplace address
        if(targetAddress == address(0)) revert OR_ZeroAddress();
        // collect funds from caller to be able to make the call to the marketplace to fulfill order
        //
        // Use decoded bytes from above and fulfill order based on the protocol enum passed as param
        if(protocol == OrderRouterLibrary.Protocol.SeaportV2) {
            callSeaportV2(data, targetAddress);
        }
        else if(protocol == OrderRouterLibrary.Protocol.WyvernV3) {
            callWyvernV3(data, targetAddress);
        }
        else if(protocol == OrderRouterLibrary.Protocol.WyvernV23) {
            callWyvernV23(data, targetAddress);
        }
        else if(protocol == OrderRouterLibrary.Protocol.WyvernV22) {
            callTreasureV2(data, targetAddress);
        }
        else if(protocol == OrderRouterLibrary.Protocol.TreasureV2) {
            callTreasureV2(data, targetAddress);
        }
        else if(protocol == OrderRouterLibrary.Protocol.X2Y2) {
            callX2Y2(data, targetAddress);
        } else {
            revert OR_MarketplaceNotWhitelisted();
        }

        // If the router recieves item from the order fulfillment, this contract must send the tokens
        // or NFT to the original function caller
        //
        // return true if passes, then calling contract can proceed accordingly.
        return true;
    }

    // ================================= External Marketplace Calls ==================================

    /**
     * @notice Internal function for making the external call to the Seaport V2 protocol.
     *         Bytes validation to occur internally by the protocol being called.
     *
     * @param data                  Data containing order paramters
     */
    function callSeaportV2(bytes calldata data, address targetAddress) internal {
        // bytes4 _method = getSelector(
        //     "fulfillBasicOrder(string considerationToken,uint considerationIdentifier,uint considerationAmount,string offerer,string zone,string offerToken,uint offerIdentifier,uint offerAmount,uint basicOrderType,uint startTime,uint endTime,string zoneHash,string salt,string offererConduitKey,string fulfillerConduitKey,uint totalOriginalAdditionalRecipients,tuple(uint amount,string recipient)[] additionalRecipients,string signature)"
        // );
        // console.logBytes4(_method);
        console.logBytes(data);
        bytes4 _method = 0xfb0f3ee1; // from etherscan https://etherscan.io/address/0x00000000006c3852cbef3e08e8df289169ede581
        // abi.encodeWithSelector
        bytes memory data1 = abi.encodeWithSelector(_method, data);
        console.log("---------");
        console.logBytes(data1);
        /// Marketplace Interaction
        (bool success, bytes memory returnData) = (address(targetAddress)).call{value: msg.value}(
            data1
        );

        console.log("SUCCESS: ", success);
        console.log("RETURN DATA:");
        console.logBytes(returnData);

        if(success) {
            return;
        } else {
            revert OR_CallToMarketplaceFailed(data1);
        }
    }

    /**
     * @notice Internal function for making the external call to the Wyvern V3 protocol.
     *         Bytes validation to occur internally by the protocol being called.
     *
     * @param data                  Data containing order paramters
     */
    function callWyvernV3(bytes calldata data, address targetAddress) internal {
        // Checks:
        // Unpack items
        //OrderItems[] memory orders = abi.decode(data, (XXX[]));
        // decode bytes
        // bytes validation
    }

    /**
     * @notice Internal function for making the external call to the Wyvern V2.3 protocol.
     *         Bytes validation to occur internally by the protocol being called.
     *
     * @param data                  Data containing order paramters
     */
    function callWyvernV23(bytes calldata data, address targetAddress) internal {
        // Checks:
        // Unpack items
        //OrderItems[] memory orders = abi.decode(data, (XXX[]));
        // decode bytes
        // bytes validation
    }

    /**
     * @notice Internal function for making the external call to the Treasure Marketplace contract.
     *         Bytes validation to occur internally by the protocol being called.
     *
     * @dev Using calldata in function params so data is immutable, decode should not be used
     *      due to depending on values in memory.
     *
     * @param data                  Data containing order paramters
     */
    function callTreasureV2(bytes calldata data, address targetAddress) internal {
        // // Unpack items
        // BuyItemParams memory orders = abi.decode(data, (BuyItemParams));
        // // go through all orders and make calls to the Treasure marketplace
        // for (uint256 i = 0; i < orders.length; i++) {
        //
        // // decode bytes
        // address _nftAddress = orders.nftAddress;
        // uint256 _tokenId = orders.tokenId;
        // address _owner = orders.owner;
        // uint64 _quantity = orders.quantity;
        // uint128 _maxPricePerItem = orders.maxPricePerItem;
        // address _paymentToken = orders.paymentToken;
        // bool _usingEth = orders.usingEth;

        // get method selector
        //bytes4 _method = getSelector("buyItems((address,uint256,address,uint64,uint128,address,bool)[])");
        // a07076b2 --> buyItems
        bytes4 _method = 0xa07076b2;

        // abi.encodeWithSelector
        bytes memory data = abi.encodeWithSelector(_method, data);

        /// Marketplace Interaction
        (bool success, bytes memory returnData) = address(targetAddress).call(data);

        console.log(success);
        console.logBytes(returnData);

        if(success) {
            return;
        } else {
            revert OR_CallToMarketplaceFailed(data);
        }
    }

    /**
     * @notice Internal function for making the external call to the X2Y2 protocol.
     *         Bytes validation to occur internally by the protocol being called.
     *
     * @param data                  Data containing order paramters
     */
    function callX2Y2(bytes calldata data, address targetAddress) internal {
        // Checks:
        // Unpack items
        //OrderItems[] memory orders = abi.decode(data, (XXX[]));
        // decode bytes
        // bytes validation
    }

    // ===================================== Funciton Helpers =======================================

    /**
     * @notice get function selector for a particular string
     *
     * @param _func                  sting containing parameter types, and no spaces
     *                               examples:
     *                                  "transfer(address,uint256)"
     *                                  --> 0xa9059cbb
     *                                  "transferFrom(address,address,uint256)"
     *                                  --> 0x23b872dd
     */
    function getSelector(string memory _func) public pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }

    /**
     * @notice returns data in bytes for a Treasure Marketplace buyItems function call
     */
    function getBytesTreasureBuy(address _nftAddress, uint256 _tokenId, address _owner, uint64 _quantity, uint128 _maxPricePerItem, address _paymentToken, bool _usingEth) public pure returns (bytes memory) {
        // get function selector
        bytes4 _method = getSelector("buyItems((address,uint256,address,uint64,uint128,address,bool)[])");
        // 0xa07076b2 --> buyItems

        BuyItemParams memory test;
        test.nftAddress = _nftAddress;
        test.tokenId = _tokenId;
        test.owner = _owner;
        test.quantity = _quantity;
        test.maxPricePerItem = _maxPricePerItem;
        test.paymentToken = _paymentToken;
        test.usingEth = _usingEth;

        bytes memory data = abi.encodeWithSelector(
            _method,
            [[test]]
        );

        return data;
    }

    /**
     * @notice returns data in bytes for a Treasure Marketplace buyItems function call
     */
    function getBytesSeaportFulfillBasicOrder(Order calldata order, bytes32 fulfillerConduitKey) public pure returns (bytes memory) {
        // get function selector
        bytes4 _method = getSelector("fulfillOrder(Order calldata order, bytes32 fulfillerConduitKey)");

        bytes memory data = abi.encodeWithSelector(
            _method,
            order,
            fulfillerConduitKey
        );

        return data;
    }

    // /**
    //  * @notice Withdraw entire balance of a given ERC20 token from the contract.
    //  *
    //  * @param token                 The ERC20 token to withdraw.
    //  * @param to                    The recipient of the withdrawn funds.
    //  */
    // function withdrawERC20(address token, address to) internal {
    //     uint256 balance = IERC20(token).balanceOf(address(this));
    //     IERC20(token).safeTransfer(to, balance);
    //     emit WithdrawERC20(msg.sender, token, to, balance);
    // }
    //
    // /**
    //  * @notice Withdraw entire balance of a given ERC20 token from this contract.
    //  *
    //  * @param token                 The token to withdraw.
    //  * @param tokenId               The ID of the NFT to withdraw.
    //  * @param to                    The recipient of the withdrawn token.
    //  *
    //  */
    // function withdrawERC721(
    //     address token,
    //     uint256 tokenId,
    //     address to
    // ) internal {
    //     IERC721(token).safeTransferFrom(address(this), to, tokenId);
    //     emit WithdrawERC721(msg.sender, token, to, tokenId);
    // }
    //
    // /**
    //  * @notice Withdraw entire balance of a given ERC1155 token from this contract.
    //  *
    //  * @param token                 The ERC1155 token to withdraw.
    //  * @param tokenId               The ID of the token to withdraw.
    //  * @param to                    The recipient of the withdrawn funds.
    //  */
    // function withdrawERC1155(
    //     address token,
    //     uint256 tokenId,
    //     address to
    // ) internal {
    //     uint256 balance = IERC1155(token).balanceOf(address(this), tokenId);
    //     IERC1155(token).safeTransferFrom(address(this), to, tokenId, balance, "");
    //     emit WithdrawERC1155(msg.sender, token, to, tokenId, balance);
    // }
    //
    // /**
    //  * @notice Withdraw entire balance of ETH from this contract.
    //  *         The vault must be in a "withdrawEnabled" state (non-transferrable),
    //  *         and the caller must be the owner.
    //  *
    //  * @param to                    The recipient of the withdrawn funds.
    //  */
    // function withdrawETH(address to) internal {
    //     // perform transfer
    //     uint256 balance = address(this).balance;
    //     payable(to).sendValue(balance);
    //     emit WithdrawETH(msg.sender, to, balance);
    // }
    //
    // /**
    //  * @notice Withdraw cryptoPunk from the vault.
    //  *         The vault must be in a "withdrawEnabled" state (non-transferrable),
    //  *         and the caller must be the owner.
    //  *
    //  * @param punks                 The CryptoPunk contract address.
    //  * @param punkIndex             The index of the CryptoPunk to withdraw (i.e. token ID).
    //  * @param to                    The recipient of the withdrawn punk.
    //  */
    // function withdrawPunk(
    //     address punks,
    //     uint256 punkIndex,
    //     address to
    // ) internal {
    //     IPunks(punks).transferPunk(to, punkIndex);
    //     emit WithdrawPunk(msg.sender, punks, to, punkIndex);
    // }

}
