 
## Repository:
 * `https://github.com/Bluemary04/hard-hat.git`
***
 
* Once you have cloned the repo, install package.json
 
* On Terminal, change path to the project's path
 
* To install all dependencies run -> npm ci
 
## Compiling contracts:
 
To compile the contract, run `npx hardhat compile` in your terminal.
 
## Executing tests:
 
To execute tests in the test folder, run `npx hardhat test` in your terminal. 
 
## Deploy to a live network:
 
To deploy to a live network, you must follow [this section of the tutorial](https://hardhat.org/tutorial/deploying-to-a-live-network). Please, bear in mind that the current project has a .env file to store keys used to deploy to remote networks. The file .env_example is a model of what you should have in your .env file.