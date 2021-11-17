pragma solidity ^0.4.25;
import "./zombiefactory.sol";


contract ZombieFeeding is ZombieFactory {


  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    // We require in order to verify that msg.sender is equal to this zombie's owner
      // So we match the index of _zombieId in the zombieToOwner mapping to msg.sender
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
  }
}
