pragma solidity ^0.4.25;

import "./zombiefeeding.sol";

// ZombieHelper inherits ZombieFeeding, which inherits ZombieFactory, which inherits Ownable
// This file is solely for additional helper methods
  // So as to keep main logic clean ❓

contract ZombieHelper is ZombieFeeding {

  // Define a uint that will be used in levelUp function
    // ether is a built in unit 
    // ENSURE to place the 0 before the decimal!
  uint levelUpFee = 0.001 ether;



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


  // onlyOwner makes it so that only the owner of this contract can withdraw ethereum
    // external so can only be called outside of this contract
  function withdraw() external onlyOwner {
    // payable makes the address able to accept ethereum as only address payable provides the transfer function
      // Explicit conversions to and from address to address payable are allowed but must be set EXPLICITLY
      // The _owner variable is of type uint160 so we must explicitly cast it to address payable
    address payable _owner = address(uint160(owner()));
    // When this function is called, use the transfer function to transfer the total balance stored on the contract to the owners address
      //_ownersContract.transferFunction(ethereumBalance(ofThisAddress).ofThisContract)
    _owner.transfer(address(this).balance);
  }
  


  // Function to change the fees of the game as price of ETH fluctuates
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }



  // Takes one parameter, the ID of the zombie that the user wants to level up
    // It is external, so it can be only be called from outside of the contract
    // It is payable, so it can receive Ether in conjunction with a call
  function levelUp(uint _zombieId) external payable {
    // Require that the amount of ether in the transaction payload is equal to the levelUpFee
    require(msg.value == levelUpFee);
    // If the above requirement is met, level the users zombie up by 1 level
      // "Add one level to the level property of the zombie in the zombies array currently stored at the index .... <zombieId>"
    zombies[_zombieId].level++;
  }



  // Our game will have a few incentives for people to level up their zombies:
    // (1st INCENTIVE) For zombies level 2 and higher, users will be able to change their name
    // This function has an aboveLevel modifier to which we pass the level 2
      // Meaning that in order for the user to exceute this function and this modifier, their zombie's level property must be greater than or equal to 2 
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {
    // REFACTOR: added ownerOf modifier & removed require statement
    // We verify that msg.sender address is equal to the address that the zombieId is stored at
      // ie does the user own the zombie they are editing
      // We utilize the zombieToOwner mapping to retreive the address of the zombieId
    //require(msg.sender == zombieToOwner[_zombieId]);

    // The name property of the zombie at passed _zombieId in the zombies array = _newName
    zombies[_zombieId].name = _newName;
  }


  // (2nd INCENTIVE) For zombies level 20 and higher, users will be able to give them custom DNA
    // This function has an above level modifier to which we pass the level 20
      // Meaning that in order for the user to execute this function and this modifier, their zombie's level property must be greater than or equal to 20
      // REFACTOR: added ownerOf modifier & removed require statement
        // RE-REFACTOR: changed name of ownerOf to onlyOwnerOf (see modifier code for explanation)
  function changeDna(uint _zombieId, uint _newDna, 20) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId) {
    
    // require(msg.sender == zombieToOwner[_zombieId]);

    // The name property of the zombie at passed _zombieId in the zombies array = _newName
    zombies[_zombieId].dna = _newDna;
  }


  // This is a function that we can call from web3.js to display a user profile with all their zombies
    // Since it is a view function and it is called internally from another view function it does not cost gas - no transactions are executed, simply the reading of data from the blockchain
      // it returns an array of uints (zombieIds) and uses memory as data location 
        // ↑ Uses memory because (1) it is a reference type (Array Type), and (2) it is a variable declared inside of a function
    // With this function we want to return a uint[] array with all users' zombieIds
  function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
    // We declare a uint[] memory variable called result
      // We set it equal to a NEW (newly initialized) uint array that will have a length equal to the # of zombies the owner has
          // array[](length of array)
      // We can access this # with our ownerZombieCount mapping
      // We use the keyword NEW to initialize arrays in memory data storage
    uint[] memory result = new uint[](ownerZombieCount[_owner]);  
    // Here we declare a uint called counter and set it to 0
      // This is used to keep track of the index # inside of our result[] array
      // This will tell the code in the for loop that the index # starts at 0
    uint counter = 0;
    // 1. INIIALIZE: the variable to start at 0
    // 2. TEST CONDITION: if the variable i is less than the length of the Dapps' zombies array, then...continue to the code inside the for loop
      // If FALSE, we done here, the loop ends
    // 3. ITERATION STATEMENT: After the x value of the variable i has been found to pass the test condition, followed by the code in the body of the for loop, increase the value of the variable i by 1 and go through the loop again
    for (uint i = 0; i < zombies.length; i++) {
      // Where i = zombieIds
      // Inside the for loop, we make an if statement that checks if the address that owns the zombieId is equal to the address of the _owner
        // Remember, zombieToOwner is a mapping that keeps track of the address that owns a zombieId
            // mapping (at a uint => stores an address) public <that stores the zombieId>
          // So we will be checking the address that each zombieId is attached to, and matching it the the _owner address
          // Every zombie in the zombies array will be checked
    
      if (zombieToOwner[i] == _owner) {
        // ...if they match, add the zombies' ID to index in the array represented by the current value of i
        result[counter] = i;
        // Increase the value of the counter so that next time the counter variable is referenced, it will represent the next index # in the result array
          // Thus, we will attach the zombieId of the next 'match' to that index
        counter++;
      }
    }
    return result;
  }
}































