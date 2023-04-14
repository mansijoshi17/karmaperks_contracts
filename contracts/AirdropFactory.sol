// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./AirdropToken.sol";


contract AirdropFactory is Ownable {
    using SafeMath for uint;
    

    event TokenCreated(address, address);
     event TokensMinted(
        uint256[] tokenIds,
        address[] indexed minters
    );


    mapping(address => address[]) public collections;

    function createToken(string memory name, string memory symbol) public {
        address _address = address(new AirdropToken(name, symbol)); // Created Token contract.
        collections[msg.sender].push(_address);
        emit TokenCreated(msg.sender, _address);
    }

    function bulkMintERC721(
        address tokenAddress,
        address[] calldata recipients
    ) public {
        uint256[] memory tokenIds = new uint256[](recipients.length);
        for (uint256 i = 0; i < recipients.length; i++) {
           uint256 tokenId = AirdropToken(tokenAddress).safeMint(recipients[i]);
           tokenIds[i] = tokenId;
        }
        if (tokenIds.length == recipients.length) {
            emit TokensMinted(tokenIds, recipients);
        }
    }

    function bulkTranferERC20(
        address tokenAddress,
        address[] calldata recipients,
        uint256 amount
    ) public {
        uint256 totalAmount = amount.mul(recipients.length);
        require(IERC20(tokenAddress).balanceOf(msg.sender) >= totalAmount, "You don't have sufficient balance!");
        for (uint256 i = 0; i < recipients.length; i++) {
        IERC20(tokenAddress).transferFrom(msg.sender, recipients[i], amount);
        }
    }
}