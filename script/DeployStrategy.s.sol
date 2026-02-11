// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "lib/yieldnest-flex-strategy/script/DeployFlexStrategy.s.sol";
import {L1Contracts} from "@yieldnest-vault-script/Contracts.sol";
import {IContracts} from "@yieldnest-vault-script/Contracts.sol";
import {IActors} from "@yieldnest-vault-script/Actors.sol";
import {console} from "forge-std/console.sol";
import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {ProxyUtils} from "lib/yieldnest-flex-strategy/lib/yieldnest-vault/script/ProxyUtils.sol";
import {MainnetStrategyActors} from "@script/Actors.sol";

contract DeployStrategy is DeployFlexStrategy {
    address public YNETHX = 0x657d9ABA1DBb59e53f9F3eCAA878447dCfC96dCb;
    address public WSTETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;

    function _setup() public virtual override {
        MainnetStrategyActors _actors = new MainnetStrategyActors();
        if (block.chainid == 1) {
            minDelay = 1 days;
            actors = IActors(_actors);
            contracts = IContracts(new L1Contracts());
        }
        address[] memory _allocators = new address[](2);
        _allocators[0] = YNETHX;
        _allocators[1] = _actors.EOA_BOOTSTRAPPER();

        setDeploymentParameters(
            BaseScript.DeploymentParameters({
                name: "YieldNest wstETH Flex Strategy - ynETHx - LVG1",
                symbol_: "ynFlex-wstETH-ynETHx-LVG1",
                accountTokenName: "YieldNest Flex Strategy - ynETHx - LVG1 Accounting Token",
                accountTokenSymbol: "ynFlexwstETH-ynETHx-LVG1-Tok",
                decimals: 18, // 18 decimals for wstETH
                paused: true,
                targetApy: 0.05 ether, // max 5% rewards per year
                lowerBound: 0.0001 ether, // Ability to mark 0.01% of TVL as losses
                minRewardableAssets: 1e18, // min 1 wstETH
                accountingProcessor: _actors.PROCESSOR(),
                baseAsset: WSTETH,
                allocators: _allocators,
                safe: _actors.SAFE(),
                alwaysComputeTotalAssets: true,
                useRewardsSweeper: false
            })
        );
    }

    function assignDeploymentParameters() internal virtual override {
        // Don't override baseAsset - we want to use wstETH, not the allocator's asset
        if (decimals == 0) {
            revert("Not pre-configured");
        }
        // baseAsset is already set to WSTETH in setDeploymentParameters
    }
}
