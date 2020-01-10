const Migrations = artifacts.require("validator_registration");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
