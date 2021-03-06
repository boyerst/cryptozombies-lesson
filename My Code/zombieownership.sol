pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";

/// @title A contract to transfer zombie ownerships
/// @author Steve Boyer
/// @dec Compliant with OpenZeppelin's implementation of the ERC721 spec draft
// We can inherit from multiple contacts...
contract ZombieOwnership is ZombieAttack, ERC721 {


  // Mapping to ensure only owner or approved address can transfer token
    // Only stores addresses that are approved by the owner of a token
  mapping (uint => address) zombieApprovals;


  // This function simply takes an address, and returns how many tokens that address owns
  function balanceOf(address _owner) external view returns (uint256) {
    return ownerZombieCount[_owner];
  }

  // This function takes a token ID (in our case, a Zombie ID), and returns the address of the person who owns it
  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
  }

  // Function to transfer ownership from one person to another
  // We abstract the logic from transferFrom() into its own private function, _transfer, which is then called by transferFrom
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    // We have 2 mappings that will change when ownership changes
    // REFACTOR V1: 
    // ownerZombieCount[_to]++;
    // ownerZombieCount[_from]--;

    // REFACTOR V2: instead of incrementing with math operations, we added SafeMath methods
    // We increment ownerZombieCount for the person receiving the zombie
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
    // We decrement the ownerZombieCount for the person sending the zombie
    ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);



    // We change zombieToOwner mapping for this _tokenId so it now points to _to
    zombieToOwner[_tokenId] = _to;
    // The ERC721 spec includes a Transfer event. The last line of this function should fire Transfer with the correct information
      // KEYWORD = fire <- so we emit the event
    emit Transfer(_from, _to, _tokenId);
  }

  // The token's owner calls transferFrom with his address as the _from parameter, the address he wants to transfer to as the _to parameter, and the _tokenId of the token he wants to transfer
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    // Require that only the owner or approved address can transfer
        // We use the logical OR operator
    require(zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId == msg.sender]);
    // Call _transfer function
    _transfer(_from, _to, _tokenId);
  }

  // Added onlyOwnerOf modifier to ensure only owner of token can approve
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    // We set the approved address for the tokenId in the zombieApprovals mapping
    zombieApprovals[_tokenId] = _approved;
    // Since there is an Approval event in erc721 contract, we have to fire the event after it has been completed
    emit Approval(msg.sender, _approved, _tokenId);
  }
}
















