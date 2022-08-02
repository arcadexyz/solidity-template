// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "./OrderRouterLibrary.sol";
import "./marketplaces/lib/ConsiderationStructs.sol";

/**
 * @title OrderRouterErrors
 * @author Non-Fungible Technologies, Inc.
 *
 * This file contains custom errors for the Arcade Order Router contract.
 *
 * @notice All errors prefixed with OR_, to separate from other Non-Fungible Technologies contracts.
 */

// ============================================= Errors =============================================

/// @notice Zero address passed in where not allowed.
error OR_ZeroAddress();

/// @notice Marketplace specificed must be whitelisted to ensure the proper target address for the protocol.
error  OR_MarketplaceNotWhitelisted();

/// @notice Call to the specified marketplace has failed.
error OR_CallToMarketplaceFailed(BasicOrderParameters);
