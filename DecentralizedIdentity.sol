// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.17;

/**
 * @title DecentralizedIdentity
 * @dev A simple self-sovereign identity system for Core Chain users
 */
contract DecentralizedIdentity {
    struct Identity {
        string displayName;
        bytes32 dataHash;      // Hash of additional off-chain identity data
        uint256 createdAt;
        uint256 updatedAt;
        bool exists;
    }
    
    // Mapping from user address to their identity
    mapping(address => Identity) private identities;
    
    // Events
    event IdentityCreated(address indexed user, string displayName, bytes32 dataHash);
    event IdentityUpdated(address indexed user, string displayName, bytes32 dataHash);
    
    /**
     * @dev Creates a new identity for the caller
     * @param _displayName A human-readable display name
     * @param _dataHash Hash of additional off-chain identity data
     */
    function createIdentity(string memory _displayName, bytes32 _dataHash) external {
        require(!identities[msg.sender].exists, "Identity already exists");
        
        identities[msg.sender] = Identity({
            displayName: _displayName,
            dataHash: _dataHash,
            createdAt: block.timestamp,
            updatedAt: block.timestamp,
            exists: true
        });
        
        emit IdentityCreated(msg.sender, _displayName, _dataHash);
    }
    
    /**
     * @dev Updates an existing identity
     * @param _displayName New display name
     * @param _dataHash New hash of additional off-chain identity data
     */
    function updateIdentity(string memory _displayName, bytes32 _dataHash) external {
        require(identities[msg.sender].exists, "Identity does not exist");
        
        Identity storage identity = identities[msg.sender];
        identity.displayName = _displayName;
        identity.dataHash = _dataHash;
        identity.updatedAt = block.timestamp;
        
        emit IdentityUpdated(msg.sender, _displayName, _dataHash);
    }
    
    /**
     * @dev Retrieves identity information
     * @param _user Address of the user
     * @return displayName User's display name
     * @return dataHash Hash of additional off-chain identity data
     * @return createdAt Timestamp when identity was created
     * @return updatedAt Timestamp when identity was last updated
     */
    function getIdentity(address _user) external view returns (
        string memory displayName,
        bytes32 dataHash,
        uint256 createdAt,
        uint256 updatedAt
    ) {
        require(identities[_user].exists, "Identity does not exist");
        
        Identity memory identity = identities[_user];
        return (
            identity.displayName,
            identity.dataHash,
            identity.createdAt,
            identity.updatedAt
        );
    }
}
