// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import { DayPlace, PropertyMetadata, RatePeriod } from "../src/DayPlace.sol";

contract ERC1155ReceiverDoNothing {
    function onERC1155Received(
        address, /* operator */
        address, /* from */
        uint256, /* id */
        uint256, /* value */
        bytes calldata /* data */
    )
        external
        pure
        returns (bytes4)
    {
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function onERC1155BatchReceived(
        address, /* operator */
        address, /* from */
        uint256[] calldata, /* ids */
        uint256[] calldata, /* values */
        bytes calldata /* data */
    )
        external
        pure
        returns (bytes4)
    {
        return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
    }
}

contract DayPlaceTest is PRBTest, StdCheats {
    DayPlace private marketplace = new DayPlace(vm.envString("URI"));
    ERC1155ReceiverDoNothing private receiver = new ERC1155ReceiverDoNothing();

    // function setUp() public { }

    function testURI() external {
        string memory uri = vm.envString("URI");
        console2.log(uri);
        assertEq(marketplace.uri(1), uri);
    }

    function testSingleMintProperty(
        uint256 _ratePerPeriod,
        uint256 _securityDeposit,
        bytes memory _calendar
    )
        external
    {
        _mintPropertyToReceiver(_ratePerPeriod, _securityDeposit, _calendar);
        uint256 expectedID = marketplace.nextPropertyID() - 1;
        assert(marketplace.balanceOf(address(receiver), expectedID) == 1);

        (RatePeriod p, uint256 rate, uint256 deposit,) = marketplace.metadataByPropertyID(expectedID);
        console2.log("rate", rate, "deposit", deposit);
        console2.log("ratePeriod", uint256(p));
    }

    function testMultiMintProperty(
        uint8 _mintCount,
        uint256 _ratePerPeriod,
        uint256 _securityDeposit,
        bytes memory _calendar
    )
        external
    {
        for (uint256 index = 0; index < _mintCount; index++) {
            _mintPropertyToReceiver(_ratePerPeriod, _securityDeposit, _calendar);
            uint256 expectedID = marketplace.nextPropertyID() - 1;
            assert(marketplace.balanceOf(address(receiver), expectedID) == 1);
        }
    }

    function _mintPropertyToReceiver(
        uint256 _ratePerPeriod,
        uint256 _securityDeposit,
        bytes memory _calendar
    )
        private
    {
        // set msg.sender to the receiver contract
        address recv = address(receiver);
        vm.prank(recv);
        PropertyMetadata memory meta = PropertyMetadata({
            period: RatePeriod.HOURLY,
            ratePerPeriod: _ratePerPeriod,
            securityDeposit: _securityDeposit,
            calendar: _calendar
        });

        marketplace.mintProperty(meta);
    }
}
