// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";

import {LlamaCore} from "src/LlamaCore.sol";
import {LlamaExecutor} from "src/LlamaExecutor.sol";
import {IOptimismMintableERC20} from "src/interfaces/IOptimismMintableERC20.sol";
import {IRegistryDiamond} from "src/interfaces/IRegistryDiamond.sol";
import {INodeOperator} from "src/interfaces/INodeOperator.sol";
import {IMainnetDelegation, IMainnetDelegationBase} from "src/interfaces/IMainnetDelegation.sol";
import {
  DistributeRewardsV2ScriptBase,
  DistributeRewardsV2ScriptBaseSepolia
} from "src/llama-scripts/DistributeRewardsV2Script.sol";
import {LlamaTestSetup} from "test/utils/LlamaTestSetup.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

// Base Sepolia test
contract DistributeRewardsV2BaseSepolia is LlamaTestSetup {
  // TOWNS_EXECUTOR, TOWNS_CORE addresses identical on base, base_sepolia
  address internal constant TOWNS_EXECUTOR = 0x63217D4c321CC02Ed306cB3843309184D347667B;
  address internal constant TOWNS_CORE = 0xA547373eB2b3c93AdeB27ec72133Fb7B92F70F7f;
  /// @dev The Treasury Llama account address.
  address internal constant TOWNS_TREASURY = 0x8ee48C016b932A69779A25133b53F0fFf66C85C0;
  /// @dev The TOWNS ERC20 token address.
  IOptimismMintableERC20 internal constant TOWNS_TOKEN =
    IOptimismMintableERC20(0x00000000A22C618fd6b4D7E9A335C4B96B189a38);
  /// @dev The Base Bridge.
  address internal constant BRIDGE_BASE = 0x4200000000000000000000000000000000000010;

  /// Base Registry Diamond
  address internal constant REGISTRY_DIAMOND = 0x08cC41b782F27d62995056a4EF2fCBAe0d3c266F;
  // Base Registry Facets
  IRegistryDiamond internal constant REWARDS_DISTRIBUTION = IRegistryDiamond(REGISTRY_DIAMOND);

  DistributeRewardsV2ScriptBaseSepolia internal rewardsScript;

  function setUp() public override {
    vm.createSelectFork("base_sepolia", 21_724_000);

    rewardsScript = new DistributeRewardsV2ScriptBaseSepolia();

    uint256 periodAmount = REWARDS_DISTRIBUTION.getPeriodRewardAmount();
    // mint a little more than period amount to TOWNS_TREASURY
    vm.prank(BRIDGE_BASE);
    TOWNS_TOKEN.mint(TOWNS_TREASURY, periodAmount);
  }

  function test_BaseSepolia_DistributeRewards() public {
    // Authorize script
    vm.prank(address(TOWNS_EXECUTOR));
    LlamaCore(TOWNS_CORE).setScriptAuthorization(address(rewardsScript), true);

    // Call distributeRewardsFromTreasury
    vm.prank(address(TOWNS_CORE));
    (bool success,) = LlamaExecutor(TOWNS_EXECUTOR).execute(
      address(rewardsScript), true, abi.encodeWithSignature("distributeRewards()")
    );
    assertTrue(success);
  }
}

// Base test
contract DistributeRewardsV2Base is LlamaTestSetup {
  address internal constant TOWNS_EXECUTOR = 0x63217D4c321CC02Ed306cB3843309184D347667B;
  address internal constant TOWNS_CORE = 0xA547373eB2b3c93AdeB27ec72133Fb7B92F70F7f;
  /// @dev The Treasury Llama account address.
  address internal constant TOWNS_TREASURY = 0x8ee48C016b932A69779A25133b53F0fFf66C85C0;
  /// @dev The TOWNS ERC20 token address.
  IOptimismMintableERC20 internal constant TOWNS_TOKEN =
    IOptimismMintableERC20(0x00000000A22C618fd6b4D7E9A335C4B96B189a38);
  /// @dev The Base Bridge.
  address internal constant BRIDGE_BASE = 0x4200000000000000000000000000000000000010;

  /// Base Registry Diamond
  address internal constant REGISTRY_DIAMOND = 0x7c0422b31401C936172C897802CF0373B35B7698;
  // Base Registry Facets
  IRegistryDiamond internal constant REWARDS_DISTRIBUTION = IRegistryDiamond(REGISTRY_DIAMOND);

  DistributeRewardsV2ScriptBase public rewardsScript;

  function setUp() public override {
    vm.createSelectFork("base", 26_213_400);

    rewardsScript = new DistributeRewardsV2ScriptBase();

    uint256 periodAmount = REWARDS_DISTRIBUTION.getPeriodRewardAmount();
    // mint a little more than period amount to TOWNS_TREASURY
    vm.prank(BRIDGE_BASE);
    TOWNS_TOKEN.mint(TOWNS_TREASURY, periodAmount);
  }

  function test_Base_DistributeRewards() public {
    // Authorize script
    vm.prank(address(TOWNS_EXECUTOR));
    LlamaCore(TOWNS_CORE).setScriptAuthorization(address(rewardsScript), true);

    // Call distributeRewardsFromTreasury
    vm.prank(address(TOWNS_CORE));
    (bool success,) = LlamaExecutor(TOWNS_EXECUTOR).execute(
      address(rewardsScript), true, abi.encodeWithSignature("distributeRewards()")
    );
    assertTrue(success);
  }
}
