const Token = artifacts.require("Token");

module.exports = async function (deployer) {
  await deployer.deploy(Token);

  let tokenInstance = await Token.deployed();

  var url = './data.json'

  const jsonData = require(url);

  for (var i in jsonData) {
    await tokenInstance.mint();
    var price = jsonData[i]['price'];

    tokenInstance.setPrice(i + 1, web3.utils.toWei(price, 'ether'))
  }
};
