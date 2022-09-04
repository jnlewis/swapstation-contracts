var MyContract = artifacts.require("./SwapStation.sol");

module.exports = function(deployer) {
  deployer.deploy(MyContract);
};
