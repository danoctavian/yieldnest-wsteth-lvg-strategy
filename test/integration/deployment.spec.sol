// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {BaseIntegrationTest} from "./BaseIntegrationTest.sol";
import {BaseScript} from "lib/yieldnest-flex-strategy/script/BaseScript.sol";
import {FlexStrategy} from "lib/yieldnest-flex-strategy/src/FlexStrategy.sol";

contract FlexStrategyDeployment is BaseIntegrationTest {
    function test_verify_setup() public view {
        // Verify the deployment parameters are correct
        assertEq(strategy.symbol(), "ynFlex-wstETH-ynETHx-LVG1");
        assertEq(strategy.asset(), 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0); // wstETH
        assertEq(accountingModule.targetApy(), 0.1 ether); // 10% APY
        assertEq(accountingModule.lowerBound(), 0.0001 ether);
    }
}
