
pragma solidity ^0.4.25;


      // LESSON 1: Here we create a function that takes a name, uses it to generate a random zombie, and adds that zombie to our app's zombie database on the blockchain.
      

      contract ZombieFactory {

          // We want an event to let our front-end know every time a new zombie was created, so the app can display it.
          // ❓We don't use underscore because they are global variables?
          event NewZombie(uint zombieId, string name, uint dna);


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

          // We use mappings to store zombie ownership
          // This one keeps track of the address that owns a zombie
            // Key = uint, Value = address
          mapping (uint => address) public zombieToOwner;
          // This mapping keeps track of how many zombies an owner has
            // Key = address, Value = uint
          mapping (address => uint) ownerZombieCount;


          // _name variable is a reference type
          // _dna variable is a value type
          // Here we create a new Zombie using _name and _dna
          function _createZombie (string memory _name, uint _dna) private {
            // ...and push it to out zombie array
            // ↓ old .push before we modified it to produce the zombies index (uint id)
            // zombies.push(Zombie(_name, _dna));  
            // ↓ new .push that will give us the zombie id that we can emit to the event
              // ❓So we still push the zombie to the array AND get the id via isolating the index number of the new zombie?

            uint id = zombies.push(Zombie(_name, _dna)) - 1;
            // Modification here to instruct the function to fire NewZombie event after adding a new zombie to the array 

            // We use msg.sender to update _createZombie regarding zombie ownership (via mappings)
            // Since we received the new zombie's id above, we will update our zombieToOwner mapping to store msg.sender under that id (ie store the senders address under the zombie id address)
            zombieToOwner[id] = msg.sender;
            // Second, we have to increase ownerToZombieCount for this msg.sender (ie we add another count of a zombie under this owners address)
            ownerZombieCount[msg.sender]++;

              // We need to tell our front end that a zombie was added on the blockchain, it will be listening
            emit NewZombie (id, _name, _dna);
          }

          // MAKE DNA
          // This is a view function because it doesn't actually change state in Solidity, just views it
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

          // MAKE A ZOMBIE WITH THE DNA
          // Public function that takes an input, the zombie's name, used the name to create a zombie with random DNA
              // the parameter _name is data that is stored in memory
          function createRandomZombie (string memory _name) public {
            // Run _generateRandomDna on _name and store it in uint called randDna
            uint randDna = _generateRandomDna(_name);
            // Run _createZombie function and pass it _name and randDna
            _createZombie(_name, randDna);
          }

      }









