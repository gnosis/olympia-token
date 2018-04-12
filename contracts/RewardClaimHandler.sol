pragma solidity ^0.4.21;

import "@gnosis.pm/util-contracts/contracts/Token.sol";

contract RewardClaimHandler {
    // The dream:
    //
    // struct RewardInfo {
    //     address[] winners;
    //     mapping (address => uint) rewardAmounts;
    //     uint guaranteedClaimEndTime;
    // }
    //
    // mapping (address =>
    //     mapping (Token =>
    //         RewardInfo)) public state;

    mapping (address => // operator
        mapping (address => // token offered
            address[])) public winners;

    mapping (address => // operator
        mapping (address => // token offered
            mapping (address => // winner
                uint))) public rewardAmounts;

    mapping (address => // operator
        mapping (address => // token offered
            uint)) public guaranteedClaimEndTime;

    function registerRewards(Token token, address[] _winners, uint[] _rewardAmounts, uint duration) public {
        require(
            winners[msg.sender][token].length == 0 &&
            _winners.length > 0 &&
            _winners.length == _rewardAmounts.length
        );

        uint totalAmount = 0;
        for(uint i = 0; i < _winners.length; i++) {
            totalAmount += _rewardAmounts[i];
            rewardAmounts[msg.sender][token][_winners[i]] = _rewardAmounts[i];
        }

        require(token.transferFrom(msg.sender, this, totalAmount));

        winners[msg.sender][token] = _winners;
        guaranteedClaimEndTime[msg.sender][token] = now + duration;
    }

    function claimReward(address operator, Token token) public {
        require(winners[operator][token].length > 0 && token.transfer(msg.sender, rewardAmounts[operator][token][msg.sender]));
        rewardAmounts[operator][token][msg.sender] = 0;
    }

    function retractRewards(Token token) public {
        require(winners[msg.sender][token].length > 0 && now >= guaranteedClaimEndTime[msg.sender][token]);

        uint totalAmount = 0;
        for(uint i = 0; i < winners[msg.sender][token].length; i++) {
            totalAmount += rewardAmounts[msg.sender][token][winners[msg.sender][token][i]];
            rewardAmounts[msg.sender][token][winners[msg.sender][token][i]] = 0;
            // We don't use:
            //     winners[msg.sender][token][i] = 0;
            // because of this:
            // https://ethereum.stackexchange.com/questions/3373/how-to-clear-large-arrays-without-blowing-the-gas-limit
            // This is a more gas efficient overall if more than one run happens
        }

        require(token.transfer(msg.sender, totalAmount));

        winners[msg.sender][token].length = 0;
    }
}
