// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {ObolLidoSplitFactory} from "src/lido/ObolLidoSplitFactory.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {ObolLidoSplitTestHelper} from "./ObolLidoSplitTestHelper.sol";

contract ObolLidoSplitFactoryTest is ObolLidoSplitTestHelper, Test {
  ObolLidoSplitFactory internal lidoSplitFactory;
  ObolLidoSplitFactory internal lidoSplitFactoryWithFee;

  address demoSplit;

  event CreateObolLidoSplit(address split);

  function setUp() public {
    uint256 mainnetBlock = 17_421_005;
    vm.createSelectFork(getChain("mainnet").rpcUrl, mainnetBlock);

    lidoSplitFactory = new ObolLidoSplitFactory(
      address(0),
      0,
      ERC20(STETH_MAINNET_ADDRESS),
      ERC20(WSTETH_MAINNET_ADDRESS)
    );

    lidoSplitFactoryWithFee = new ObolLidoSplitFactory(
      address(this),
      1e3,
      ERC20(STETH_MAINNET_ADDRESS),
      ERC20(WSTETH_MAINNET_ADDRESS)
    );

    demoSplit = makeAddr("demoSplit");
  }

  function testCan_CreateSplit() public {
    vm.expectEmit(true, true, true, false, address(lidoSplitFactory));
    emit CreateObolLidoSplit(address(0x1));

    lidoSplitFactory.createSplit(demoSplit);

    vm.expectEmit(true, true, true, false, address(lidoSplitFactoryWithFee));
    emit CreateObolLidoSplit(address(0x1));

    lidoSplitFactoryWithFee.createSplit(demoSplit);
  }

  function testCannot_CreateSplitInvalidAddress() public {
    vm.expectRevert(ObolLidoSplitFactory.Invalid_Wallet.selector);
    lidoSplitFactory.createSplit(address(0));

    vm.expectRevert(ObolLidoSplitFactory.Invalid_Wallet.selector);
    lidoSplitFactoryWithFee.createSplit(address(0));
  }
}