pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol"

// We can inherit from multiple contacts...
contract ZombieOwnership is ZombieAttack, ERC721 {

}