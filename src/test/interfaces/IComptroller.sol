pragma solidity ^0.8.0;

interface Comptroller {
    function _addRewardsDistributor(address distributor)
        external
        returns (uint256);

    function _afterNonReentrant() external;

    function _become(address unitroller) external;

    function _becomeImplementation() external;

    function _beforeNonReentrant() external;

    function _borrowGuardianPaused() external view returns (bool);

    function _deployMarket(
        bool isCEther,
        bytes memory constructorData,
        uint256 collateralFactorMantissa
    ) external returns (uint256);

    function _mintGuardianPaused() external view returns (bool);

    function _setBorrowCapGuardian(address newBorrowCapGuardian) external;

    function _setBorrowPaused(address cToken, bool state)
        external
        returns (bool);

    function _setCloseFactor(uint256 newCloseFactorMantissa)
        external
        returns (uint256);

    function _setCollateralFactor(
        address cToken,
        uint256 newCollateralFactorMantissa
    ) external returns (uint256);

    function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa)
        external
        returns (uint256);

    function _setMarketBorrowCaps(
        address[] memory cTokens,
        uint256[] memory newBorrowCaps
    ) external;

    function _setMarketSupplyCaps(
        address[] memory cTokens,
        uint256[] memory newSupplyCaps
    ) external;

    function _setMintPaused(address cToken, bool state) external returns (bool);

    function _setPauseGuardian(address newPauseGuardian)
        external
        returns (uint256);

    function _setPriceOracle(address newOracle) external returns (uint256);

    function _setSeizePaused(bool state) external returns (bool);

    function _setTransferPaused(bool state) external returns (bool);

    function _setWhitelistEnforcement(bool enforce) external returns (uint256);

    function _setWhitelistStatuses(
        address[] memory suppliers,
        bool[] memory statuses
    ) external returns (uint256);

    function _toggleAutoImplementations(bool enabled)
        external
        returns (uint256);

    function _unsupportMarket(address cToken) external returns (uint256);

    function accountAssets(address, uint256) external view returns (address);

    function admin() external view returns (address);

    function adminHasRights() external view returns (bool);

    function allBorrowers(uint256) external view returns (address);

    function allMarkets(uint256) external view returns (address);

    function autoImplementation() external view returns (bool);

    function borrowAllowed(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external returns (uint256);

    function borrowCapGuardian() external view returns (address);

    function borrowCaps(address) external view returns (uint256);

    function borrowGuardianPaused(address) external view returns (bool);

    function borrowVerify(
        address cToken,
        address borrower,
        uint256 borrowAmount
    ) external;

    function borrowWithinLimits(address cToken, uint256 accountBorrowsNew)
        external
        returns (uint256);

    function cTokensByUnderlying(address) external view returns (address);

    function checkMembership(address account, address cToken)
        external
        view
        returns (bool);

    function closeFactorMantissa() external view returns (uint256);

    function comptrollerImplementation() external view returns (address);

    function enforceWhitelist() external view returns (bool);

    function enterMarkets(address[] memory cTokens)
        external
        returns (uint256[] memory);

    function exitMarket(address cTokenAddress) external returns (uint256);

    function fuseAdminHasRights() external view returns (bool);

    function getAccountLiquidity(address account)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    function getAllBorrowers() external view returns (address[] memory);

    function getAllMarkets() external view returns (address[] memory);

    function getAssetsIn(address account)
        external
        view
        returns (address[] memory);

    function getHypotheticalAccountLiquidity(
        address account,
        address cTokenModify,
        uint256 redeemTokens,
        uint256 borrowAmount
    )
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    function getRewardsDistributors() external view returns (address[] memory);

    function getWhitelist() external view returns (address[] memory);

    function isComptroller() external view returns (bool);

    function isDeprecated(address cToken) external view returns (bool);

    function liquidateBorrowAllowed(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function liquidateBorrowVerify(
        address cTokenBorrowed,
        address cTokenCollateral,
        address liquidator,
        address borrower,
        uint256 actualRepayAmount,
        uint256 seizeTokens
    ) external;

    function liquidateCalculateSeizeTokens(
        address cTokenBorrowed,
        address cTokenCollateral,
        uint256 actualRepayAmount
    ) external view returns (uint256, uint256);

    function liquidationIncentiveMantissa() external view returns (uint256);

    function markets(address)
        external
        view
        returns (bool isListed, uint256 collateralFactorMantissa);

    function mintAllowed(
        address cToken,
        address minter,
        uint256 mintAmount
    ) external returns (uint256);

    function mintGuardianPaused(address) external view returns (bool);

    function mintVerify(
        address cToken,
        address minter,
        uint256 actualMintAmount,
        uint256 mintTokens
    ) external;

    function mintWithinLimits(
        address cToken,
        uint256 exchangeRateMantissa,
        uint256 accountTokens,
        uint256 mintAmount
    ) external returns (uint256);

    function oracle() external view returns (address);

    function pauseGuardian() external view returns (address);

    function pendingAdmin() external view returns (address);

    function pendingComptrollerImplementation() external view returns (address);

    function redeemAllowed(
        address cToken,
        address redeemer,
        uint256 redeemTokens
    ) external returns (uint256);

    function redeemVerify(
        address cToken,
        address redeemer,
        uint256 redeemAmount,
        uint256 redeemTokens
    ) external;

    function repayBorrowAllowed(
        address cToken,
        address payer,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256);

    function repayBorrowVerify(
        address cToken,
        address payer,
        address borrower,
        uint256 actualRepayAmount,
        uint256 borrowerIndex
    ) external;

    function rewardsDistributors(uint256) external view returns (address);

    function seizeAllowed(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external returns (uint256);

    function seizeGuardianPaused() external view returns (bool);

    function seizeVerify(
        address cTokenCollateral,
        address cTokenBorrowed,
        address liquidator,
        address borrower,
        uint256 seizeTokens
    ) external;

    function suppliers(address) external view returns (bool);

    function supplyCaps(address) external view returns (uint256);

    function transferAllowed(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external returns (uint256);

    function transferGuardianPaused() external view returns (bool);

    function transferVerify(
        address cToken,
        address src,
        address dst,
        uint256 transferTokens
    ) external;

    function whitelist(address) external view returns (bool);

    function whitelistArray(uint256) external view returns (address);
}
