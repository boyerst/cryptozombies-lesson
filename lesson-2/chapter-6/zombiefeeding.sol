pragma solidity ^0.4.25;
import "./zombiefactory.sol";

// ZombieFeeding inherits ZombieFactory


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

  // This is the address of the CryptoKitty contract
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // Here we create a KittyInterface named kittyContract and initialize it with ckAddress
    // kittyContract (variable) is now pointing to the KittyInterface contract (which is then pointing to CryptoKitty contract?)
    // This line is saying "ckAddress is an address of a contract (CryptoKitty contract) implementing the KittyInterface interface. I would like to reference that contract using the variable kittyContract."
  KittyInterface kittyContract = KittyInterface(ckAddress);


  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    // We 'require' in order to verify that msg.sender is equal to this zombie's owner
      // Bc we don't want to let someone else feed our zombie
      // So we match the index of _zombieId in the zombieToOwner mapping to msg.sender
      // We verify that msg.sender is equal to the zombie's owner
      // We do this by matching the address that owns the zombie which we find via _zombieId index in zombieToOwner mapping
    require(msg.sender == zombieToOwner[_zombieId]);
    // We need to get our zombie's DNA
    // First we create a local zombie (myZombie), whose data is stored permanentely in 'storage'
    // We set the variable myZombie to be equal to the index of _zombieId in our zombies array
      // ↑ Where is the zombies array you say? Remember ZombieFeeding inherits ZombieFactory, which is where 'Zombie[] public zombies' is
    Zombie storage myZombie = zombies[_zombieId];
    // Ensure _targetDna isn't longer than 16 digits
    _targetDna == _targetDna % dnaModulus;
    // NewDna is the average between the feeding zombie's DNA and the target's DNA
    // We can access the properties of myZombie with myZombie.<property> (Variable.property)
    uint newDna = (myZombie.dna + _targetDna) / 2;
    // Here we add an if statement comparing the keccak hashes of _species (the 3rd argument, string, we added above) to that of the string 'kitty'
    // We want to replace the last two digits of newDna with 99 as this denotes cat Dna
    // We modulus 100 of the new Dna to get return a whole number remainder
      // Then we add 99 to change the last two digits to the desired numbers
      // ❓Where are _species and "kitty" declared? In CryptoKitty contract?
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }    
    // We call createZombie, and calling the required parameters... 
      // " (string memory _name, uint _dna) "
      // We ran into an issue here....we tried calling the _createZombie function from within ZombieFeeding, but _createZombie is a private function inside ZombieFactory. This means none of the contracts that inherit from ZombieFactory can access it
    _createZombie("NoName", newDna);
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





