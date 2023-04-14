// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./comman/ERC721URIStorage.sol";


// This contract is for transfering karmaperks nft to the contributors 
contract KarmaPerks is ERC721URIStorage, ReentrancyGuard {
    address payable public owner;
    using Counters for Counters.Counter;
    address karmaTokenContract;

    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _compaginedIdCounter; // Counter for compagine id which issuer will create.

    event TokensMinted(
        uint256 indexed compagineId,
        uint256[] tokenIds,
        address[] indexed minters
    );

    constructor() ERC721("TestKarmaPerks", "TKT") {
        owner = payable(msg.sender);
    }

    struct token {
        uint256 tokenId;
        address creator;
        address minter;
        uint256 compagineId;
    }

    mapping(uint256 => token) private tokens;
    mapping(address => address[]) public airdropNFTS;

    /**
     * @dev value == 0 is for to check the nft we are minting is for certificate or badges. For badges we set tokenURI in mint.
     * @param tokenURI Metadata of nft.
     */
    function safeMint(
        string calldata tokenURI,
        address recipient
    ) internal returns (uint256) {
        require(bytes(tokenURI).length > 0, "Token URI must not be empty");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return tokenId;
    }

    /**
     * @param tokenUri Metadata of nft.
     */
    function bulkMintERC721(
        string calldata tokenUri,
        address[] calldata minters
    ) external nonReentrant {
        uint256 compagineId = _compaginedIdCounter.current();
        _compaginedIdCounter.increment();
        uint256[] memory tokenIds = new uint256[](minters.length);
        for (uint256 i = 0; i < minters.length; i++) {
            uint256 tokenId = safeMint(tokenUri, minters[i]);
            tokens[tokenId] = token(
                tokenId,
                msg.sender,
                minters[i],
                compagineId
            );
            tokenIds[i] = tokenId;
        }
        if (tokenIds.length == minters.length) {
            emit TokensMinted(compagineId, tokenIds, minters);
        }
    }
}
