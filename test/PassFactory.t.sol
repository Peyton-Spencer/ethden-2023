// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { RealEstateFactory } from "../src/RealEstateFactory.sol";
import { PassFactory } from "../src/PassFactory.sol";

contract PassFactoryTest is PRBTest, StdCheats {
    RealEstateFactory internal estates = new RealEstateFactory();
    PassFactory internal passMaker = new PassFactory(estates);

    // function setUp() public { }

    function testGetEstatesContract() public view {
        address es = address(passMaker.getEstatesContract());
        assert(es == address(estates));
    }
}
