pragma solidity ^0.8.1;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Strings.sol";

contract Token is ERC721 {
    using Strings for uint256;

    // string public domain = "localhost:8080";

    mapping(uint256 => address) internal cardToOwner;
    mapping(uint256 => uint256) internal cardToPrice;
    mapping(address => uint256) internal ownerCardCount;
    uint256 nextId = 1;
    uint16 internal constant CARD_PER_COLLECTION = 5;

    constructor() ERC721("The bai", "The") {}

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getWalletBalance() public view returns (uint256) {
        return address(msg.sender).balance;
    }

    function mint() public {
        _safeMint(msg.sender, nextId);

        cardToOwner[nextId] = msg.sender;
        ownerCardCount[msg.sender] = ownerCardCount[msg.sender] + 1;
        nextId++;
    }

    function getAllCardIds() public view returns (uint256[] memory) {
        if (nextId <= 1) {
            return new uint256[](0);
        }

        uint256[] memory ids = new uint256[](nextId - 1);
        uint256 i = 0;
        while (i < nextId - 1) {
            ids[i] = i + 1;
            i = i + 1;
        }

        return ids;
    }

    function getOwnCardIds(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerCount = ownerCardCount[_owner];
        if (ownerCount == 0) {
            return new uint256[](0);
        }

        uint256[] memory ids = new uint256[](ownerCount);
        uint256 i = 1;
        uint256 count = 0;
        while (count < ownerCount || i < nextId) {
            if (cardToOwner[i] == _owner) {
                ids[count] = i;
                count++;
            }
            i++;
        }

        return ids;
    }

    function getOwnCollection(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerCount = ownerCardCount[_owner];
        if (ownerCount == 0) {
            return new uint256[](0);
        }

        uint256[] memory myCards = getOwnCardIds(_owner);

        if (ownerCount <= CARD_PER_COLLECTION) {
            return myCards;
        }

        uint256 cardsLength = myCards.length;
        while (cardsLength > CARD_PER_COLLECTION) {
            uint256 removeIndex = block.timestamp % cardsLength;

            for (uint256 i = removeIndex; i < cardsLength - 1; i++) {
                myCards[i] = myCards[i + 1];
            }
            delete myCards[cardsLength - 1];
            cardsLength--;
        }

        uint256[] memory ids = new uint256[](CARD_PER_COLLECTION);
        for (uint256 i = 0; i < CARD_PER_COLLECTION; i++) {
            ids[i] = myCards[i];
        }

        return ids;
    }

    function setPrice(uint256 _tokenId, uint256 price) public {
        // require(
        //     msg.sender == cardToOwner[_tokenId],
        //     "you must owner to set token price"
        // );

        cardToPrice[_tokenId] = price;
    }

    function getTokenPrice(uint256 _tokenId) public view returns (uint256) {
        return cardToPrice[_tokenId];
    }

    function buyCard() external payable {
        uint256 _tokenId = 1;
        uint256 price = cardToPrice[_tokenId];

        // string memory s1 = string.concat(
        //     " payment must be exact ",
        //     Strings.toString(msg.value)
        // );
        // string memory s2 = string.concat(Strings.toString(price), s1);
        // require(msg.value == price, s2);

        address owner = cardToOwner[_tokenId];

        // require(msg.sender == owner, "you cannot buy your own token ");

        //do transfer
        _transfer(owner, msg.sender, _tokenId);

        cardToOwner[_tokenId] = msg.sender;
        ownerCardCount[msg.sender] = ownerCardCount[msg.sender] + 1;
        if (ownerCardCount[owner] > 0) {
            ownerCardCount[owner] = ownerCardCount[owner] - 1;
        }
    }

    function getContractEthBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
