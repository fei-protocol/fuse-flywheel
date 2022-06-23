// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

import {ERC20, ERC4626} from "solmate/mixins/ERC4626.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

import {RewardsClaimer} from "../../utils/RewardsClaimer.sol";

interface ILiquidityGauge {
    function deposit(uint256 value) external;

    function withdraw(uint256 value, bool claim_rewards) external;

    function claim_rewards() external;

    function balanceOf(address) external view returns (uint256);

    function staking_token() external view returns (address);

    function reward_tokens(uint256 i) external view returns (address token);

    function reward_count() external view returns (uint256 nTokens);
}

/// @title Curve Finance Yield Bearing Vault
/// @author joeysantoro
contract CurveERC4626 is ERC4626, RewardsClaimer {
    using SafeTransferLib for ERC20;

    /// @notice The Convex Rewards contract (for claiming rewards)
    ILiquidityGauge public immutable gauge;

    /**
     @notice Creates a new Vault that accepts a specific underlying token.
     @param _asset The ERC20 compliant token the Vault should accept.
     @param _name The name for the vault token.
     @param _symbol The symbol for the vault token.
     @param _gauge The Convex Rewards contract (for claiming rewards).
     @param _rewardsDestination the address to send CRV and CVX.
     @param _rewardTokens the rewards tokens to send out.
    */
    constructor(
        ERC20 _asset,
        string memory _name,
        string memory _symbol,
        ILiquidityGauge _gauge,
        address _rewardsDestination,
        ERC20[] memory _rewardTokens
    )
        ERC4626(_asset, _name, _symbol)
        RewardsClaimer(_rewardsDestination, _rewardTokens)
    {
        gauge = _gauge;

        _asset.approve(address(_gauge), type(uint256).max);
    }

    function updateRewardTokens() public {
        uint256 len = gauge.reward_count();
        require(len < 5, "exceed max rewards");
        delete rewardTokens;

        for (uint256 i = 0; i < len; i++) {
            rewardTokens.push(ERC20(gauge.reward_tokens(i)));
        }
    }

    function afterDeposit(uint256 amount, uint256) internal override {
        gauge.deposit(amount);
    }

    function beforeWithdraw(uint256 amount, uint256) internal override {
        gauge.withdraw(amount, false);
    }

    function beforeClaim() internal override {
        gauge.claim_rewards();
    }

    /// @notice Calculates the total amount of underlying tokens the Vault holds.
    /// @return The total amount of underlying tokens the Vault holds.
    function totalAssets() public view override returns (uint256) {
        return gauge.balanceOf(address(this));
    }
}
