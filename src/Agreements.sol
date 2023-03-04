// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { GuestHub } from "./GuestHub.sol";
import { OwnerHub } from "./OwnerHub.sol";

contract Agreements {
    OwnerHub public ownerHub = new OwnerHub();
    GuestHub public guestHub = new GuestHub();
    Stay[][] public staysByPropertyID;

    struct Stay {
        GuestHub.Guest[] guests;
        OwnerHub.Property property;
        uint256 startTime;
        uint256 endTime;
    }
}
