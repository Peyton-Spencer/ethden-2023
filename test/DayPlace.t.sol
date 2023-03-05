// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import "../src/DayPlace.sol";

contract PassFactoryTest is PRBTest, StdCheats {
    DayPlace internal marketplace = new DayPlace(vm.envString("URI"));

    // function setUp() public { }
}
