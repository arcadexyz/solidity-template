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
}
