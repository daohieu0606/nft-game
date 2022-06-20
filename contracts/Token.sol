pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Token is ERC721 {
    using Strings for uint256;

    // string public domain = "localhost:8080";

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getWalletBalance() public view returns (uint256) {
        return address(msg.sender).balance;
    }
}
