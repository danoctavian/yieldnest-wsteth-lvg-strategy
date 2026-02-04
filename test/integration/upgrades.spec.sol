pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import {BaseIntegrationTest} from "./BaseIntegrationTest.sol";
import {TransparentUpgradeableProxy} from
    "lib/openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {UpgradeUtils} from "lib/yieldnest-flex-strategy/script/UpgradeUtils.sol";
import {ProxyUtils} from "lib/yieldnest-vault/script/ProxyUtils.sol";
import {AccountingModule} from "lib/yieldnest-flex-strategy/src/AccountingModule.sol";
import {AccountingToken} from "lib/yieldnest-flex-strategy/src/AccountingToken.sol";
import {FlexStrategy} from "lib/yieldnest-flex-strategy/src/FlexStrategy.sol";

contract UpgradesTest is BaseIntegrationTest {
    //DeployStrategy strategy;

    function setUp() public override {
        super.setUp();
    }

    function testDeploymentParameters() public {
        // // Check if the deployment parameters are set correctly
        assertEq(strategy.symbol(), "ynFlex-wstETH-ynETHx-SPV1");
        assertEq(strategy.asset(), 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0);
    }

    function testAccountingModuleUpgrade() public {
        // Deploy a new implementation of AccountingModule
        AccountingModule newAccountingModuleImplementation = new AccountingModule();

        UpgradeUtils.timelockUpgrade(
            deployment.timelock(),
            deployment.actors().ADMIN(),
            address(deployment.accountingModule()),
            address(newAccountingModuleImplementation)
        );

        assertEq(
            address(ProxyUtils.getImplementation(address(deployment.accountingModule()))),
            address(newAccountingModuleImplementation)
        );
    }

    function testAccountingTokenUpgrade() public {
        // Deploy a new implementation of AccountingToken
        AccountingToken newAccountingTokenImplementation = new AccountingToken(address(0));

        UpgradeUtils.timelockUpgrade(
            deployment.timelock(),
            deployment.actors().ADMIN(),
            address(deployment.accountingToken()),
            address(newAccountingTokenImplementation)
        );

        assertEq(
            address(ProxyUtils.getImplementation(address(deployment.accountingToken()))),
            address(newAccountingTokenImplementation)
        );
    }

    function testFlexStrategyUpgrade() public {
        // Deploy a new implementation of FlexStrategy
        FlexStrategy newFlexStrategyImplementation = new FlexStrategy();

        UpgradeUtils.timelockUpgrade(
            deployment.timelock(),
            deployment.actors().ADMIN(),
            address(deployment.strategy()),
            address(newFlexStrategyImplementation)
        );

        assertEq(
            address(ProxyUtils.getImplementation(address(deployment.strategy()))),
            address(newFlexStrategyImplementation)
        );
    }
}
