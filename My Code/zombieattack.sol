pragma solidity >=0.5.0 <0.6.0;
import "./zombiehelper.sol";


contract ZombieAttack is ZombieHelper {

  uint randNonce = 0;
  // Attacking zombie has 70% chance of winning
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    // Increments randNonce
    randNonce++;
    // Calculates the uint typecast of keccak256 hash of abi.encodePacked(now, msg.sender, randNonce) and returns that value % _modulus
      // 1. takes the timestamp of now, the address of the sender, and an incrementing nonce (a random number)
      // 2. It "packs" the arguments using an ABI encoding function to return bytes
      // 3. Then we use keccak to compute a Keccak-256 hash algorithm with an output of 256 bits
      // 4. Then we use % _modulus
      // 5. Returns a uint typecast 

    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  // Includes ownerOf modifier to ensure the owner owns the zombieId they are calling the function with
  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    // Declare a storage pointer to the owners zombie
      // We declare that myZombie is a Zombie Struct in the apps' zombies array under this zombieId and it is data stored in storage
    Zombie storage myZombie = zombies[_zombieId];
    // Declare a storage pointer to the zombie attack target
      // We declare that the enemyZombie is a Zombie Struct in the apps' zombies array under this zombieId and it is data stored in storage
    Zombie storage enemyZombie = zombies[_targetId]; 
    // We need a random number between 0-99 to determine outcome of battle
      // We use randMod function and pass it the appropriate numbeer
    uint rand = randMod(100);
  }
}