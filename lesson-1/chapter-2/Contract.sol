
pragma solidity ^0.4.25;

      contract ZombieFactory {
          // This variable will be permanently stored in the blockchain
          // This is a State variable
          uint dnaDigits = 16;
          uint dnaModulus = 10 ** dnaDigits;

          // This Struct defines our type and the types variables
          struct Zombie {
              string name;
              uint dna;
          }

          Zombie[] public zombies;
          // _name variable is a reference type
          // _dna variable is a value type
          function createZombie (string memory _name, uint _dna) public {
            // Here we create a new Zombie and push it to out zombie array
            zombies.push(Zombie(_name, _dna));  
          }

      }