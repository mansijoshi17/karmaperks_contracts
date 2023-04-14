// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KarmaToken is ERC20{
    constructor() ERC20("KarmaTokenTest", "KAT"){}

    mapping(address => mapping(string => uint256)) private categoriesBalance;

    function issueToken(address[] calldata receivers, uint256 amount, string calldata category) external{
        for (uint256 i = 0; i < receivers.length; i++) {
           _mint(receivers[i], amount);
           categoriesBalance[receivers[i]][category] = categoriesBalance[receivers[i]][category] + 1;
        }
    }

    function getBalance(address userAddress, string calldata category) external view returns(uint256){
       return categoriesBalance[userAddress][category];
    }
}
