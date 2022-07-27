// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

/**
 * @title LoanLibrary
 * @author Non-Fungible Technologies, Inc.
 *
 * Contains all data types used across Arcade Order Router contracts.
 */
library OrderRouterLibrary {

    // ====================== Enum ======================

    /// @dev Enum describing the specfic marketplace protocol to be called by the fulfillOrder function.
    enum Protocol {
        // Seaport v2
        SeaportV2,
        // Wyvern v3
        WyvernV3,
        // Wyvern v2.3
        WyvernV23,
        // Wyvern v2.2
        WyvernV22,
        // Treasure Marketplace v2
        TreasureV2,
        // X2Y2
        X2Y2
    }

    // ==================== Structs ======================

    /// @dev Treasure Marketplace v2 Listing
    struct ListingOrBid {
        /// @dev which token contract holds the offered token
        address nftAddress;
        /// @dev the identifier for the offered token
        uint256 tokenId;
        /// @dev number of tokens for sale or requested (1 if ERC-721 token is active for sale)
        ///      (for bids, quantity for ERC-721 can be greater than 1)
        uint64 quantity;
        /// @dev price per token sold, i.e. extended sale price equals this times quantity purchased.
        ///      For bids, price offered per item.
        uint128 pricePerItem;
        /// @dev timestamp after which the listing/bid is invalid
        uint64 expirationTime;
        /// @dev the payment token for this listing/bid.
        address paymentTokenAddress;
    }

    struct BuyItemParams {
        /// which token contract holds the offered token
        address nftAddress;
        /// the identifier for the token to be bought
        uint256 tokenId;
        /// current owner of the item(s) to be bought
        address owner;
        /// how many of this token identifier to be bought (or 1 for a ERC-721 token)
        uint64 quantity;
        /// the maximum price (in units of the paymentToken) for each token offered
        uint128 maxPricePerItem;
        /// the payment token to be used
        address paymentToken;
        /// indicates if the user is purchasing this item with eth.
        bool usingEth;
    }
}
