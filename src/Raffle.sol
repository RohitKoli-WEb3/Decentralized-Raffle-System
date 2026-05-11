// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

error Raffle_NotEnoughEthSent();

/**
 * @title A sample Raffle contract
 * @author Rohit
 * @notice This contract is creating a sample Raffle
 * @dev It implements Chainlink VRFv2.5 and Chainlink Automation
 */

contract Raffle is VRFConsumerBaseV2Plus {
    uint private immutable i_entranceFee;
    uint private immutable i_interval; // @dev Duration of lottery in seconds
    address payable[] private s_players; // array stores the address of players
    uint private s_lastTimeStamp;

    event EnteredRaffle(address indexed player);

    // To set the entrancee fee with use of constructor
    constructor(
        uint entranceFee,
        uint interval,
        address vrfCoordinator
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        // require(msg.value > i_entranceFee , "Not enough ETH sent");
        if (msg.value < i_entranceFee) revert Raffle_NotEnoughEthSent();
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    /* 
        1. Get a random number
        2. Use the random number to pick a player
        3. Automatically called
    */

    function pickWinner() public {
        // Check to see if enough time has passed if not then revert the trx
        if (block.timestamp - s_lastTimeStamp < i_interval) revert();

        // requestId = s_vrfCoordinator.requestRandomWords(
        //     VRFV2PlusClient.RandomWordsRequest({
        //         keyHash: s_keyHash,
        //         subId: s_subscriptionId,
        //         requestConfirmations: requestConfirmations,
        //         callbackGasLimit: callbackGasLimit,
        //         numWords: numWords,
        //         extraArgs: VRFV2PlusClient._argsToBytes(
        //             // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
        //             VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
        //         )
        //     })
        // );
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] calldata randomWords
    ) internal override {}

    // Getter Function
    function getEntranceFee() external view returns (uint) {
        return i_entranceFee;
    }
}
