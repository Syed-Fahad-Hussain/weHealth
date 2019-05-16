var Token = artifacts.require("./ERC20.sol");
var Storage = artifacts.require("./Storage.sol");

module.exports = async function (deployer) {
  await deployer.deploy(Token);
  await deployer.deploy(Storage, Token.address);


};
