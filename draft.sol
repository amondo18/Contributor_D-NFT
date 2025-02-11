// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;

/// @author Bali Sanctuary Team
/// @title Contributors' D-NFT
contract DNFT {
    mapping (address => uint256) NFT_score;
    mapping (address => uint256) LastContribution;
    mapping (address => bool) Provers;

    modifier onlyProvers {
        require(Provers[msg.sender] == true);
        _;
    }

    constructor () {
        /** @dev There should be multiple provers.
                 Also, it might be a good idea to get at least 2 approvals for petal additions. **/
        Provers[msg.sender] = true;
    }

    function mint() external {
        require(NFT_score[msg.sender] < 1, "Your NFT is already minted.");
        NFT_score[msg.sender] = 1;
    }

    function redeem_reward(uint256 _number_of_petals) external returns (uint256){
        require(_number_of_petals < 63);
        require(NFT_score[msg.sender] > _number_of_petals);
        NFT_score[msg.sender] = NFT_score[msg.sender] - _number_of_petals;
        return (_number_of_petals);
    }

    function add_1_petal(address _contributor) external onlyProvers returns (uint256) {
        require(NFT_score[_contributor] >= 1, "User needs to mint the NFT first.");
        require(NFT_score[_contributor] < 64, "WOW! Max was already level reached!");
        NFT_score[_contributor] = NFT_score[_contributor] + 1;
        LastContribution[_contributor] = block.timestamp;
        return NFT_score[_contributor];
    }

    function give_extra_petal(address _contributor, uint _ammount) external onlyProvers {
        NFT_score[_contributor] += _ammount;
    }

    function add_prover(address _new_prover) external onlyProvers returns (address) {
        Provers[_new_prover] = true;
        return _new_prover;
    }

    function my_score() public view returns (uint256) {
        return NFT_score[msg.sender];
    }

    function score_of(address _address) public view returns(uint256) {
        return NFT_score[_address];
    }
}
