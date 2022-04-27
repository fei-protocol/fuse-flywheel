// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.10;

contract MockFusePriceOracle {
    bool public constant isPriceOracle = true;
    mapping(address => uint256) public getUnderlyingPrice;

    function mockSetPrice(address cToken, uint256 value) external {
        getUnderlyingPrice[cToken] = value;
    }
}
