pragma solidity >=0.5.0 <0.6.0;
import "./zombiehelper.sol";


contract ZombieAttack is ZombieHelper {
  uint randNonce = 0;
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
}