// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {CERC20} from "libcompound/interfaces/CERC20.sol";

abstract contract Unitroller {
    struct Market {
        bool isListed;
        uint256 collateralFactorMantissa;
        mapping(address => bool) accountMembership;
    }

    address public admin;
    address public borrowCapGuardian;
    address public pauseGuardian;

    address public oracle;
    address public pendingAdmin;
    uint256 public closeFactorMantissa;
    uint256 public liquidationIncentiveMantissa;
    mapping(address => Market) public markets;
    mapping(address => address) public cTokensByUnderlying;
    mapping(address => uint256) public supplyCaps;

    function _setPendingAdmin(address newPendingAdmin)
        public
        virtual
        returns (uint256);

    function _setBorrowCapGuardian(address newBorrowCapGuardian) public virtual;

    function _setMarketSupplyCaps(
        CERC20[] calldata cTokens,
        uint256[] calldata newSupplyCaps
    ) external virtual;

    function _setMarketBorrowCaps(
        CERC20[] calldata cTokens,
        uint256[] calldata newBorrowCaps
    ) external virtual;

    function _setPauseGuardian(address newPauseGuardian)
        public
        virtual
        returns (uint256);

    function _setMintPaused(CERC20 cToken, bool state)
        public
        virtual
        returns (bool);

    function _setBorrowPaused(CERC20 cToken, bool borrowPaused)
        public
        virtual
        returns (bool);

    function _setTransferPaused(bool state) public virtual returns (bool);

    function _setSeizePaused(bool state) public virtual returns (bool);

    function _setPriceOracle(address newOracle)
        external
        virtual
        returns (uint256);

    function _setCloseFactor(uint256 newCloseFactorMantissa)
        external
        virtual
        returns (uint256);

    function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa)
        external
        virtual
        returns (uint256);

    function _setCollateralFactor(
        CERC20 cToken,
        uint256 newCollateralFactorMantissa
    ) public virtual returns (uint256);

    function _acceptAdmin() external virtual returns (uint256);

    function _deployMarket(
        bool isCEther,
        bytes calldata constructionData,
        uint256 collateralFactorMantissa
    ) external virtual returns (uint256);

    function mintGuardianPaused(address cToken)
        external
        view
        virtual
        returns (bool);

    function borrowGuardianPaused(address cToken)
        external
        view
        virtual
        returns (bool);

    function comptrollerImplementation()
        external
        view
        virtual
        returns (address);

    function rewardsDistributors(uint256 index)
        external
        view
        virtual
        returns (address);

    function _addRewardsDistributor(address distributor)
        external
        virtual
        returns (uint256);

    function _setWhitelistEnforcement(bool enforce)
        external
        virtual
        returns (uint256);

    function _setWhitelistStatuses(
        address[] calldata suppliers,
        bool[] calldata statuses
    ) external virtual returns (uint256);

    function _unsupportMarket(CERC20 cToken) external virtual returns (uint256);

    function _toggleAutoImplementations(bool enabled)
        public
        virtual
        returns (uint256);
}
