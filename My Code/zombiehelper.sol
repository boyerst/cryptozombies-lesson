pragma solidity ^0.4.25;

import "./zombiefeeding.sol";

// ZombieHelper inherits ZombieFeeding, which inherits ZombieFactory, which inherits Ownable
// This file is solely for additional helper methods
  // So as to keep main logic clean ❓

contract ZombieHelper is ZombieFeeding {

  // This modifier uses the zombie level property to restrict access to special abilities
    // Takes 2 args that are passed to it from the calling function
  modifier aboveLevel(uint _level, uint _zombieId) {
    // Body ensures that the users' zombies' level property is greater than or equal to the level that was passed to it from the arguments that are passed in the modifiers in the functions themselves
       // ex: function changeName modifier passes level 2 which will in turn be passed to the main modifier when the function calls the modifier
      // (<zombiesarray[myZombiesID].itsLevelProperty >= theLevel that is passed to the modifier)
    require(zombies[_zombieId].level >= _level);
    // This line ensures rest of the function that called the modifier is executed
    _;
  }
  // Our game will have a few incentives for people to level up their zombies:
    // (1st INCENTIVE) For zombies level 2 and higher, users will be able to change their name
    // This function has an aboveLevel modifier to which we pass the level 2
      // Meaning that in order for the user to exceute this function and this modifier, their zombie's level property must be greater than or equal to 2 
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    // We verify that msg.sender address is equal to the address that the zombieId is stored at
      // ie does the user own the zombie they are editing
      // We utilize the zombieToOwner mapping to retreive the address of the zombieId
    require(msg.sender == zombieToOwner[_zombieId]);
    // The name property of the zombie at passed _zombieId in the zombies array = _newName
    zombies[_zombieId].name = _newName;


  }
  // (2nd INCENTIVE) For zombies level 20 and higher, users will be able to give them custom DNA
    // This function has an above level modifier to which we pass the level 20
      // Meaning that in order for the user to execute this function and this modifier, their zombie's level property must be greater than or equal to 20
  function changeDna(uint _zombieId, uint _newDna, 20) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    // The name property of the zombie at passed _zombieId in the zombies array = _newName
    zombies[_zombieId].dna = _newDna;
  }

  // This is a function that we can call from web3.js to display a user profile with all their zombies
    // Since it is a view function and it is called internally from another view function it does not cost gas - no transactions are executed, simply the reading of data from the blockchain
      // it returns an array of uints (zombieIds) and uses memory as data location 
        // ↑ Uses memory because (1) it is a reference type (Array Type), and (2) it is a variable declared inside of a function
    // With this function we want to return a uint[] array with all users' zombies
  function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
    // We declare a uint[] memory variable called result
      // We set it equal to a NEW uint array that will be have a length equal to the # of zombies the owner has
      // We can access this # with our ownerZombieCount mapping
      // We use the keyword NEW to initialize arrays in memory data storage
    uint[] memory result = new uint[](ownerZombieCount[_owner]);  
    return result;
  }
}
