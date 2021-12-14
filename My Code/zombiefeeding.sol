pragma solidity ^0.4.25;
import "./zombiefactory.sol";



// LESSON 2️⃣
// LESSON 3️⃣


// We can grab data from any openly stored data on the blockchain
// Here we create an interface for the the function getKitty() from CryptoKitty smart contract
  // Now we can grab data from said function, in this case we want 'genes'
contract KittyInterface {
  // We can just pass in a kittyId to retrieve the values from the CryptoKitty smart contract
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}


contract ZombieFeeding is ZombieFactory {

  // Since we use this check multiple times we make a modifier to clean up the code
  // REFACTOR: changed mod name from ownerOf to onlyOwnerOf after adding ownerOf function to zombieownership.sol
    // We cannot have a modifier and a function with the same name
    // It is required that the function in that contract be named ownerOf as it needs to conform to the ERC721 token standard
  modifier onlyOwnerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

  // REFACTOR V1: KITTY CONTRACT ADDRESS CODE FROM LESSON 2️⃣
  //  This is the address of the CryptoKitty contract
  //address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // Here we create a KittyInterface named kittyContract and initialize it with ckAddress
      // kittyContract (variable) is now pointing to the KittyInterface contract (which is then pointing to CryptoKitty contract?)
      // This line is saying "ckAddress is an address of a contract (CryptoKitty contract) implementing the KittyInterface interface. I would like to reference that contract using the variable kittyContract."
  //KittyInterface kittyContract = KittyInterface(ckAddress);

  // REFACTOR V2: KITTY CONTRACT ADDRESS CODE FROM LESSON 3️⃣
  // The first version was hard coded - we changed it so that we can change the kittyContract address if need be
  // Instead of hard coding ckaddress we simply declare the variable
  KittyInterface kittyContract;
  // Then we create a function that will allow us to set the crypto kitties address as needed
  // We first had this function set as only external
    // This presents a major security flaw as anyone could call it and change the ckaddress
    // Thus why we add the onlyOwner modifier to the function
    // This is call the modifier onlyOwner that is inherited via this path...
          // Ownable.sol -> ZombieFactory -> ZombieFeeding
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }



  // The following definitions are added to set the zombie's readyTime by modifying feedAndMultiply such that: 
    // Feeding triggers a zombie's cooldown, and
    // Zombies can't feed on kitties until their cooldown period has passed
  // We pass a storage pointer (a Zombie storage pointer) that points to our Zombie struct as an argument to our function - this way we don't have to pass our zombieId and have to look stuff up
    // You can only pass storage pointers to private or internal functions
    // Again, the uint32(...) is necessary because now returns a uint256 by default. So we need to explicitly convert it to a uint32

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }
  // Function also takes a Zombie storage argument named _zombie and is an internal view function, and return a bool
    // Function body evaluates true or false
      // Tells us if enough time has passed since the last time the zombies fed
      // if _zombie.readyTime <= now is True then the zombie can eat some cats
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
    return (_zombie.readyTime <= now);
  }




  // This function is called when we have eaten a target
    // It takes either human human Dna (_targetDna) or other species (_species)
    // It was initially a public function - which allowed a user to call the function directly and pass in any _targetDna or _species they wanted
      // Remember, internal is the same as private, except it is also accessible to contracts that inherit from said internal contract
      // REFACTOR: added ownerOf modifier that we created to streamline code
        // RE-REFACTOR: changed name of ownerOf to onlyOwnerOf (see modifier code for explanation)
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal onlyOwnerOf(_zombieID) {
    // We 'require' in order to verify that msg.sender is equal to this zombie's owner
      // Bc we don't want to let someone else feed our zombie
      // So we match the index of _zombieId in the zombieToOwner mapping to msg.sender
      // We verify that msg.sender is equal to the zombie's owner
      // We do this by matching the address that owns the zombie which we find via _zombieId index in zombieToOwner mapping
      // REFACTOR: removed this require when we added modifier to the function
    // require(msg.sender == zombieToOwner[_zombieId]);

    // We need to get our zombie's DNA
    // First we create a local zombie (myZombie), whose data is stored permanentely in Zombie storage
    // We lookup the index of _zombieId in our zombies array and set the variable myZombie to be equal to said index
      // ↑ Where is the zombies array you say? Remember ZombieFeeding inherits ZombieFactory, which is where 'Zombie[] public zombies' is
    Zombie storage myZombie = zombies[_zombieId];
    // After we lookup myZombie we check if our zombies cooldown timer has expired
    require(_isReady(myZombie));
    // Ensure _targetDna isn't longer than 16 digits
    _targetDna == _targetDna % dnaModulus;
    // NewDna is the average between the feeding zombie's DNA and the target's DNA
    // We can access the properties of myZombie with myZombie.<property> (Variable.property)
    uint newDna = (myZombie.dna + _targetDna) / 2;
    // Here we add an if statement comparing the keccak hashes of _species (the 3rd argument, string, we added above) to that of the string 'kitty'
    // We want to replace the last two digits of newDna with 99 as this denotes cat Dna
    // We modulus 100 of the new Dna to get return a whole number remainder
      // Then we add 99 to change the last two digits to the desired numbers
      // Where are _species and "kitty" declared? In CryptoKitty contract❓
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }    
    // We call createZombie, and calling the required parameters... 
      // " (string memory _name, uint _dna) "
      // We ran into an issue here....we tried calling the _createZombie function from within ZombieFeeding, but _createZombie is a private function inside ZombieFactory. This means none of the contracts that inherit from ZombieFactory can access it
    _createZombie("NoName", newDna);
    // Here we call _triggerCooldown so that feeding triggers the timer
    _triggerCooldown(myZombie);
  }


  // This function will make it so that zombies made from kitties have some unique cat like features
  // Here we make a function that takes two parameters
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    // We declare a uint named kittyDna
    // We are going to assign a value to this uint be retreiving it from the KittyInterface
    uint kittyDna;
    // Then we call (via the interface) the kittyContract.getKitty function with _kittyId (because it takes uint256 _id) and store genes in the kittyDna we just declared above
    // We only care about the last value (genes), so we leave all other return fields blank but still insert commas
    // ↓↓This is the val we want  ↓↓Call interface w the contract which takes an Id
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // Then we call feedAndMultiply and pass it both _zombieId and kittyDna
      // We added the parameter 'kitty' because the if statement in feedAndMultiply takes it❓
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  

  }


}





