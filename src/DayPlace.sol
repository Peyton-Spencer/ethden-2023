// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/// @notice This is the time period for which the rate is charged.
enum RatePeriod {
    DAILY,
    HOURLY
}

struct PropertyMetadata {
    RatePeriod period;
    uint256 ratePerPeriod;
    uint256 securityDeposit;
    /// @notice map of unix timestamps to availability
    /// @dev days start at midnight UTC (12:00 AM)
    bytes calendar;
}

/// @notice The Day Marketplace contract.
contract DayPlace is ERC1155 {
    // mapping (uint256 => uint256) public
    // OwnerHub

    uint256 public constant DAYS_TOKEN_FT = 0 << 128;
    uint256 public constant PROPERTY_TOKEN_NFT = 1 << 128;
    uint256 public constant STAY_TOKEN_NFT = 2 << 128;
    uint128 public propertyTokenNftIndex = 1;

    mapping(uint256 => PropertyMetadata) public metadataByPropertyID;
    Stay[][] public staysByPropertyID;

    constructor(string memory uri_) ERC1155(uri_) { }

    struct Stay {
        address[] guests;
        uint256 propertyID;
        uint256 startTime;
        uint256 endTime;
    }

    function mintProperty(PropertyMetadata memory meta) external {
        bytes memory data;
        uint256 id = nextPropertyID();
        _mint(_msgSender(), id, 1, data);
        metadataByPropertyID[id] = meta;
        propertyTokenNftIndex++;
    }

    function batchMintProperty(
        PropertyMetadata[] memory meta,
        uint256[] memory ids,
        uint256[] memory amounts
    )
        external
    {
        bytes memory data;
        _mintBatch(_msgSender(), ids, amounts, data);
    }

    function mintDaysForProperty(uint256 propertyID, uint256 dayCount) external { }

    // function _ownerOf(uint256 propertyID) {
    //     balanceOf(msg.sender, propertyID);
    // }

    function nextPropertyID() public view returns (uint256) {
        return PROPERTY_TOKEN_NFT + propertyTokenNftIndex;
    }
}
