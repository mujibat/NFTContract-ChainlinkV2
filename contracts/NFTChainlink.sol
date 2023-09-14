// SPDX-License-Identifier: MIT
// This is for DEMO purposes only and should not be used in production!

pragma solidity ^0.8.10;

// Importing other contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract NFTContract is ERC721, VRFConsumerBaseV2 {
    struct Traits {
        uint256 strength;
        uint256 energy;
        uint256 speed;
        uint256 intelligence;
        uint256 wisdom;
        uint256 charisma;
        uint256 experience;
        string name;
    }

    Traits[] public traits;

VRFCoordinatorV2Interface COORDINATOR;


uint64 private s_subscriptionId;
uint32 private callbackGasLimit = 2500000;
uint16 private requestConfirmations = 3;
uint32 private numWords = 6;
uint256[] public s_randomWords;

// Contract owner's address
address private s_owner;

// VRF settings specific to Gorli testnet
address private vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
bytes32 private keyHash = 0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f;

constructor(uint64 subscriptionId, address to, uint tokenId) ERC721("NFTCON", "NFTC")
        VRFConsumerBaseV2(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D)
        // s_owner(msg.sender)
    {
        COORDINATOR = VRFCoordinatorV2Interface(
            0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D
        );
        s_subscriptionId = subscriptionId;
        _mint(to, tokenId);
    }

// Function to request random Numbers from the VRF
function requestRandomWords() public {
// Will revert if subscription is not set and funded.
COORDINATOR.requestRandomWords(
keyHash,
s_subscriptionId,
requestConfirmations,
callbackGasLimit,
numWords
);
}


function fulfillRandomWords(uint256, uint256[] memory randomWords, address to) internal  {
s_randomWords = randomWords;

}
//  function fulfillRandomness(bytes32 requestId, uint256 randomNumber, address to)
//         internal
//         override
//     {
//         uint256 newId = traits.length;
//         uint256 strength = (randomNumber % 100);
//         uint256 energy = ((randomNumber % 10000) / 100 );
//         uint256 speed = ((randomNumber % 1000000) / 10000 );
//         uint256 intelligence = ((randomNumber % 100000000) / 1000000 );
//         uint256 wisdom = ((randomNumber % 10000000000) / 100000000 );
//         uint256 charisma = ((randomNumber % 1000000000000) / 10000000000);
//         uint256 experience = 0;
//         string memory name = (randomNumber % 100);

//         traits.push(
//             Traits(
//                  strength,
//                  energy,
//                  speed,
//                  intelligence,
//                  wisdom,
//                  charisma,
//                 experience,
//                 name
//             )
          
//         );
//         _safeMint(to, newId);
//     }


// Modifier to restrict certain functions to contract owner
modifier onlyOwner() {
require(msg.sender == s_owner);
_;
}


 function _baseURI() internal view virtual override returns (string memory) {
    return 'ipfs://QmdNQuGhj15m6CLZtcABUv7KgHFJMZ92KUfG4ujerqhDuW';
    
  }

 
    function tokenURI(uint256 tokenId) public view  override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI)) : "";
    }


    }
