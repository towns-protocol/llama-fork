// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IRegistryDiamond} from "src/interfaces/IRegistryDiamond.sol";
import {LlamaAccount} from "src/accounts/LlamaAccount.sol";
import {LlamaBaseScript} from "src/llama-scripts/LlamaBaseScript.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

/// @title Distribute Rewards V2 Script
contract DistributeRewardsV2ScriptBase is LlamaBaseScript {
  /// @notice The `RegistryDiamond` contract address.
  IRegistryDiamond public constant REGISTRY_DIAMOND = IRegistryDiamond(0x7c0422b31401C936172C897802CF0373B35B7698);

  /// @notice The Treasury Llama account address.
  LlamaAccount public constant TOWNS_TREASURY = LlamaAccount(payable(0x8ee48C016b932A69779A25133b53F0fFf66C85C0));

  /// @notice The TOWNS ERC20 token address.
  IERC20 public constant TOWNS_TOKEN = IERC20(0x00000000A22C618fd6b4D7E9A335C4B96B189a38);

  function distributeRewards() external onlyDelegateCall {
    uint256 rewardAmount = REGISTRY_DIAMOND.getPeriodRewardAmount();

    TOWNS_TREASURY.transferERC20(
      LlamaAccount.ERC20Data({token: TOWNS_TOKEN, recipient: address(REGISTRY_DIAMOND), amount: rewardAmount})
    );

    REGISTRY_DIAMOND.notifyRewardAmount(rewardAmount);
  }
}

/// @title Distribute Rewards V2 Script
contract DistributeRewardsV2ScriptBaseSepolia is LlamaBaseScript {
  /// @notice The `RegistryDiamond` contract address.
  IRegistryDiamond public constant REGISTRY_DIAMOND = IRegistryDiamond(0x08cC41b782F27d62995056a4EF2fCBAe0d3c266F);

  /// @notice The Treasury Llama account address.
  LlamaAccount public constant TOWNS_TREASURY = LlamaAccount(payable(0x8ee48C016b932A69779A25133b53F0fFf66C85C0));

  /// @notice The TOWNS ERC20 token address.
  IERC20 public constant TOWNS_TOKEN = IERC20(0x00000000A22C618fd6b4D7E9A335C4B96B189a38);

  function distributeRewards() external onlyDelegateCall {
    uint256 rewardAmount = REGISTRY_DIAMOND.getPeriodRewardAmount();

    TOWNS_TREASURY.transferERC20(
      LlamaAccount.ERC20Data({token: TOWNS_TOKEN, recipient: address(REGISTRY_DIAMOND), amount: rewardAmount})
    );

    REGISTRY_DIAMOND.notifyRewardAmount(rewardAmount);
  }
}
