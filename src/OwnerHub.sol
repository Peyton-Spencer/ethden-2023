// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

contract OwnerHub {
    mapping(address => Property[]) public propertiesByOwner;

    /// @notice This is the time period for which the rate is charged.
    enum RatePeriod {
        Daily,
        Hourly
    }

    struct Property {
        // 160 + 64 + 32 bits
        // 160 bits for owner address, 96 bits property ID
        uint256 packedOwnerId;
        address[] guests;
        RatePeriod period;
        uint256 ratePerPeriod;
        uint256 securityDeposit;
    }
}
