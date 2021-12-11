pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";

// We can inherit from multiple contacts...
contract ZombieOwnership is ZombieAttack, ERC721 {

  // This function simply takes an address, and returns how many tokens that address owns
  function balanceOf(address _owner) external view returns (uint256) {
    return ownerZombieCount[_owner];
  }

  // This function takes a token ID (in our case, a Zombie ID), and returns the address of the person who owns it
  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
  }

  // We abstract the logic from transferFrom() into its own private function, _transfer, which is then called by transferFrom
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    // We have 2 mappings that will change when ownership changes
    // We increment ownerZombieCount for the person receiving the zombie
    ownerZombieCount[_to]++;
    // We decrement the ownerZombieCount for the person sending the zombie
    ownerZombieCount[_from]--;
    // We change zombieToOwner mapping for this _tokenId so it now points to _to
    zombieToOwner[_tokenId] = _to;
    // The ERC721 spec includes a Transfer event. The last line of this function should fire Transfer with the correct information
      // KEYWORD = fire <- so we emit the event
    emit Transfer(_from, _to, _tokenId);
  }

  // The token's owner calls transferFrom with his address as the _from parameter, the address he wants to transfer to as the _to parameter, and the _tokenId of the token he wants to transfer
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {

  }

  function approve(address _approved, uint256 _tokenId) external payable {

  }
}