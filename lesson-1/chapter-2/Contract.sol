
pragma solidity ^0.4.25;

      contract ZombieFactory {
          // This variable will be permanently stored in the blockchain
          // This is a State variable
          uint dnaDigits = 16;
          // We use this to ensure out DNA is only 16 characters long 
              // (Modulus operator gives the remainder after integer division)
          uint dnaModulus = 10 ** dnaDigits;

          // This Struct defines our type and the types variables
          struct Zombie {
              string name;
              uint dna;
          }

          Zombie[] public zombies;
          // _name variable is a reference type
          // _dna variable is a value type
          function _createZombie (string memory _name, uint _dna) private {
            // Here we create a new Zombie and push it to out zombie array
            zombies.push(Zombie(_name, _dna));  
          }

          // This is a view function because it doesn't actually change state in Solidity, just views
          // It will generate a random DNA numbeer from a string
          function _generateRandomDna(string memory _str) private view returns (uint) {
            // First we pack our parameter '_str' to make it of type 'bytes' ---  abi.encodePacked(_str)
            // Then we call keccak256
            // This produces a pseudorandom hexadecimal that we typecast as a uint
                // ❓We have to typecast this result in order to store it a uint?????
            // We store the above hexadecimal (typecasted as a uint) in a uint called rand
            uint rand = uint(keccak256(abi.encodePacked(_str)));    
            //We want our DNA to be 16 digits long, so we have to use the modulus operator % to shorten the integer to said 16 digits
                // ❓From 256 bit to 16????
            return rand % dnaModulus;

          }

      }