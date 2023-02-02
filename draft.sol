// SPDX-License-Identifier: Apache-2.0
// Author: Bali Sanctuary Team
pragma solidity ^0.8.17;

contract DNFT {

    uint penalty;

    event NewMember(address _newmMember, string message);
    event LevelUp(address _contributor, string message);

    mapping (address => uint256) NFT_score;
    mapping (address => uint256) LastContribution;
    mapping (address => bool) Provers;
    mapping (address => bool) membershipActive;
    mapping (address => bool) isExpelled;

    uint[] private levels = [9,17,25,33,41,49,57];

    modifier onlyProvers {
        require(Provers[msg.sender] == true);
        _;
    }

    modifier timeGate {
        require(block.timestamp > LastContribution[msg.sender] + 2);
        _;
    }

    modifier expelled {
        require(!isExpelled[msg.sender]);
        _;
    }

    constructor () {
        Provers[msg.sender] = true;
    }


    function mint() external expelled {
        require(NFT_score[msg.sender] < 1, "Your NFT is already minted.");
        NFT_score[msg.sender] = 1;
        LastContribution[msg.sender] = block.timestamp;
        membershipActive[msg.sender] = true;

        emit NewMember(msg.sender, "Welcome!");
    }

    function my_score() external expelled view returns (uint256) {
        return NFT_score[msg.sender];
    }
    /// do we need this or transfrom it in another way?
    function redeem_reward(uint256 _number_of_petals) external expelled returns (uint256){
        require(_number_of_petals < 63);
        require(NFT_score[msg.sender] > _number_of_petals);
        NFT_score[msg.sender] = NFT_score[msg.sender] - _number_of_petals;
        return (_number_of_petals);
    }

    function add_1_petal() external timeGate expelled returns (uint256) {
        require(NFT_score[msg.sender] >= 1, "User needs to mint the NFT first.");
        require(NFT_score[msg.sender] < 64, "WOW! Max level has already reached!");
        NFT_score[msg.sender] = NFT_score[msg.sender] + 1;
        LastContribution[msg.sender] = block.timestamp;
        return NFT_score[msg.sender];
        
    }

    /// put here some ownership functions

    function give_extra_petal(address _contributor, uint _ammount) external onlyProvers {
        NFT_score[_contributor] += _ammount;
    }

    function revokeMembership(address _contributor) external onlyProvers {
        NFT_score[_contributor] = 0;
        membershipActive[_contributor] = false;
        isExpelled[_contributor] = true;
    }

    function add_prover(address _new_prover) external onlyProvers returns (address) {
        Provers[_new_prover] = true;
        return _new_prover;
    }
    /// penalty part if needed ///

    function penaltyAmmount(uint _penalty) external onlyProvers {
        penalty = _penalty;
    }

    function showPenalty() external view returns(uint) {
        return penalty;
    }

    function delayPenalty(address payable _hub) public payable {
        require(msg.value == penalty, "Please send correct ammount.");
        _hub.transfer(penalty);
    }
}
