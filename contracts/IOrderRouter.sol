// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "./OrderRouterLibrary.sol";

interface IOrderRouter {

    // ============== Events ==============

    event WithdrawERC20(
        address indexed operator,
        address indexed token,
        address recipient,
        uint256 amount
    );
    event WithdrawERC721(
        address indexed operator,
        address indexed token,
        address recipient,
        uint256 tokenI
    );
    event WithdrawPunk(
        address indexed operator,
        address indexed token,
        address recipient,
        uint256 tokenId
    );
    event WithdrawERC1155(
        address indexed operator,
        address indexed token,
        address recipient,
        uint256 tokenId,
        uint256 amount
    );
    event WithdrawETH(
        address indexed operator,
        address indexed recipient,
        uint256 amount
    );

    // ======================================== Order Routing =========================================

    function fulfillOrder(OrderRouterLibrary.Protocol protocol, address targetAddress, bytes calldata data) external returns (bool);
}
