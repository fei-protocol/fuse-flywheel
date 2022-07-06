// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import {DSTestPlus} from "solmate/test/utils/DSTestPlus.sol";
import {Test} from "forge-std/Test.sol";

contract BaseDSTest is DSTestPlus, Test {
    function fail(string memory err) internal override(DSTestPlus, Test) {
        emit log_named_string("Error", err);
        fail();
    }

    function assertFalse(bool data) internal override(DSTestPlus, Test) {
        assertTrue(!data);
    }

    function bound(
        uint256 x,
        uint256 min,
        uint256 max
    ) internal override(DSTestPlus, Test) returns (uint256 result) {
        return Test.bound(x, min, max);
    }
}