const { promisify } = require('util')
const TruffleContract = require('truffle-contract')
const args = require('yargs').argv

module.exports = async function(callback) {
  try {
    if (!args.rewardToken) {
      throw  'You need to provide reward token address. Use --rewardToken parameter'
    }

    const RewardClaimHandler = TruffleContract(
      require('../build/contracts/RewardClaimHandler.json'),
    )
    const accounts = await promisify(web3.eth.getAccounts)()

    RewardClaimHandler.setProvider(web3.currentProvider)

    if (typeof RewardClaimHandler.currentProvider.sendAsync !== 'function') {
      RewardClaimHandler.currentProvider.sendAsync = function() {
        return RewardClaimHandler.currentProvider.send.apply(
          RewardClaimHandler.currentProvider,
          arguments,
        )
      }
    }

    RewardClaimHandler.new(args.rewardToken, {
      from: accounts[0],
      gas: 1000000,
    }).then(deployedContract => {
      console.log(`RewardClaimHandler address is ${deployedContract.address}. SAVE IT! If you lose it, you can go to https://etherscan.io and search for contract creation transaction.`)
      callback()
    })
  } catch (err) {
    callback(err)
  }
}
