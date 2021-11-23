pragma solidity ^0.4.25;
import "./zombiefactory.sol";


contract ZombieFeeding is ZombieFactory {


  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    // We 'require' in order to verify that msg.sender is equal to this zombie's owner
      // Bc we don't want to let someone else feed our zombie
      // So we match the index of _zombieId in the zombieToOwner mapping to msg.sender
      // We verify that msg.sender is equal to the zombie's owner
      // We do this by matching the address that owns the zombie which we find via _zombieId index in zombieToOwner mapping
    require(msg.sender == zombieToOwner[_zombieId]);
    // We need to get the zombie's DNA
    // First we create a local zombie (myZombie), whose data is stored permanentely in 'storage'
    // We set the variable myZombie to be equal to the index of _zombieId in our zombies array
      // ❓Where is zombies array?
    Zombie storage myZombie = zombies[_zombieId];
    // Ensure _targetDna isn't longer than 16 digits
    _targetDna == _targetDna % dnaModulus;
    // NewDna is the average between the feeding zombie's DNA and the target's DNA
    // We can access the properties of myZombie with myZombie.<property> (Variable.property)
    uint newDna = (myZombie.dna + _targetDna) / 2;
    // We call createZombie, and calling the required parameters... 
      // " (string memory _name, uint _dna) "
    _createZombie("NoName", newDna);
    // 

  }
}
