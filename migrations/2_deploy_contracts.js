var SupplyChain = artifacts.require("./SupplyChain.sol");
//var SupplyChain = artifacts.require("./ProxySupplyChain.sol");

module.exports = function(deployer) {
  deployer.deploy(SupplyChain);
};
