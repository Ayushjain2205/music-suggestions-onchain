// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract MusicPortal {
    uint256 totalSuggestions;
    uint256 private seed;

    mapping(address => uint256) public suggestionsMap;

    event NewSuggestion(
        address indexed from,
        uint256 timestamp,
        string message
    );

    struct Suggestion {
        address suggester; // addess of person who suggested
        string message;
        uint256 timestamp;
    }

    Suggestion[] suggestions;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function suggest(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalSuggestions += 1;
        console.log("%s has suggested song %s", msg.sender, _message);
        suggestionsMap[msg.sender] += 1;
        console.log(
            "%s has suggested %d songs",
            msg.sender,
            suggestionsMap[msg.sender]
        );

        suggestions.push(Suggestion(msg.sender, _message, block.timestamp));

        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed < 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewSuggestion(msg.sender, block.timestamp, _message);
    }

    function getAllSuggestions() public view returns (Suggestion[] memory) {
        return suggestions;
    }

    function getTotalSuggestions() public view returns (uint256) {
        console.log("We have %d total music suggestions", totalSuggestions);
        return totalSuggestions;
    }
}
