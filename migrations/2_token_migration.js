const Token = artifacts.require("Token");

module.exports = async function (deployer) {
    await deployer.deploy(Token, 'Game The Bai', 'The Bai');
    let tokenInstance = await Token.deployed();
};
