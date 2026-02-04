// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {RolesVerification} from "lib/yieldnest-flex-strategy/script/verification/RolesVerification.sol";
import {BaseScript} from "lib/yieldnest-flex-strategy/script/BaseScript.sol";
import {MainnetStrategyActors} from "@script/Actors.sol";
import {console} from "forge-std/console.sol";
import {ProxyUtils} from "lib/yieldnest-flex-strategy/lib/yieldnest-vault/script/ProxyUtils.sol";
import {VerifyFlexStrategy} from "lib/yieldnest-flex-strategy/script/verification/VerifyFlexStrategy.s.sol";
import {IActors} from "@yieldnest-vault-script/Actors.sol";
import {IContracts} from "@yieldnest-vault-script/Contracts.sol";
import {L1Contracts} from "@yieldnest-vault-script/Contracts.sol";
import {IVault} from "@yieldnest-vault/interface/IVault.sol";

// forge script VerifyFlexStrategy --rpc-url <MAINNET_RPC_URL>
contract VerifyStrategy is VerifyFlexStrategy {
    address public YNETHX = 0x657d9ABA1DBb59e53f9F3eCAA878447dCfC96dCb;
    address public WSTETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;

    function _setup() public virtual override {
        MainnetStrategyActors _actors = new MainnetStrategyActors();
        if (block.chainid == 1) {
            minDelay = 1 days;

            actors = IActors(_actors);
            contracts = IContracts(new L1Contracts());
        }

        address[] memory _allocators = new address[](1);
        _allocators[0] = YNETHX;

        setVerificationParameters(
            VerifyFlexStrategy.VerificationParameters({
                name: "YieldNest wstETH Flex Strategy - ynETHx - SPV1",
                symbol_: "ynFlex-wstETH-ynETHx-SPV1",
                accountTokenName: "YieldNest Flex Strategy - ynETHx - SPV1 Accounting Token",
                accountTokenSymbol: "ynFlexwstETH-ynETHx-SPV1-Tok",
                decimals: 18, // 18 decimals for wstETH
                paused: true,
                targetApy: 0.1 ether, // max 10% rewards per year
                lowerBound: 0.0001 ether, // Ability to mark 0.01% of TVL as losses
                minRewardableAssets: 1e18, // min 1 wstETH
                accountingProcessor: _actors.PROCESSOR(),
                baseAsset: WSTETH,
                allocators: _allocators,
                alwaysComputeTotalAssets: true
            })
        );
    }
}
