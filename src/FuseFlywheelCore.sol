// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import "flywheel/FlywheelCore.sol";

contract FuseFlywheelCore is FlywheelCore {
    bool public constant isRewardsDistributor = true;

    bool public constant isFlywheel = true;

    constructor(
        ERC20 _rewardToken,
        IFlywheelRewards _flywheelRewards,
        IFlywheelBooster _flywheelBooster,
        address _owner,
        Authority _authority
    )
        FlywheelCore(
            _rewardToken,
            _flywheelRewards,
            _flywheelBooster,
            _owner,
            _authority
        )
    {}

    function flywheelPreSupplierAction(ERC20 market, address supplier)
        external
    {
        accrue(market, supplier);
    }

    function flywheelPreBorrowerAction(ERC20 market, address borrower)
        external
    {}

    function flywheelPreTransferAction(
        ERC20 market,
        address src,
        address dst
    ) external {
        accrue(market, src, dst);
    }

    function compAccrued(address user) external view returns (uint256) {
        return rewardsAccrued[user];
    }

    function addMarketForRewards(ERC20 strategy) external requiresAuth {
        _addStrategyForRewards(strategy);
    }

    function marketState(ERC20 strategy)
        external
        view
        returns (RewardsState memory)
    {
        return strategyState[strategy];
    }
}
