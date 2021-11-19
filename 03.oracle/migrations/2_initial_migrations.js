const Migrations = artifacts.require("Oracle")

module.exports = function (deployer) {
  deployer.deploy(Migrations)
}
