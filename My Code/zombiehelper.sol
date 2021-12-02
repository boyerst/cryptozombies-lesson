pragma solidity ^0.4.25;

import "./zombiefeeding.sol";

// ZombieHelper inherits ZombieFeeding, which inherits ZombieFactory, which inherits Ownable
contract ZombieHelper is ZombieFeeding {

  // This modifier uses the zombie level property to restrict access to special abilities
    // Takes 2 args
  modifier aboveLevel(uint _level, uint _zombieId) {
    // Body ensures 
      // (<zombiesarray[myZombiesID].itsLevelProperty >= theLevel that is passed to the modifier)
    require(zombies[_zombieId].level >= _level);
    // This line ensures rest of the function that called the modifier is executed
    _;
  }

}
