
pragma solidity ^0.4.25;

      contract ZombieFactory {
          // this will be permanently stored in the blockchain
          uint dnaDigits = 16;
          uint dnaModulus = 10 ** dnaDigits;

          struct Zombie {
              string name;
              uint dna;
          }

          Zombie[] public zombies;

      }