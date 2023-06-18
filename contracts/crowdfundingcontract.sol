// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

contract Crowdfunding {
     
    address public owner;
    uint public totalFunds;
    uint public numDonors;
    uint public deadline;
    uint public fundingGoal;
    bool public goalReached = false;
    uint public numRequests;
    mapping(address => uint) public donations;
    mapping(address => uint) public donationPercentages;
    mapping (uint => WithdrawalRequest) public WithdrawalRequests;
    event DonationReceived(address donor, uint amount);
    
    // Modificador para restringir o acesso apenas ao dono do contrato
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }
    
    // Construtor que define o endereço do dono do contrato e a meta de arrecadação e prazo limite
    constructor(uint _fundingGoal, uint _deadline) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
        deadline = block.timestamp + _deadline;
    }
    
    // Função que permite a doação de ether para o contrato, desde que o prazo não tenha sido atingido e a meta não tenha sido alcançada
    function donate() public payable {
        require(block.timestamp < deadline, "The deadline for donations has passed.");
        require(!goalReached, "The funding goal has already been reached.");
        require(msg.value > 0, "Donation amount must be greater than zero.");
        donations[msg.sender] = msg.value;
        totalFunds += msg.value;
        numDonors++;
        emit DonationReceived(msg.sender, msg.value);

        if (totalFunds >= fundingGoal) {
            goalReached = true;
        }
    }
    
    // Estrutura que possui os atributos de um pedido de saque
    struct WithdrawalRequest {
        uint amount;
        string purpose;
        bool executed;
        uint numOfApprovals;
        mapping(address => bool) approvals;
    }

    // Função para o proprietário do contrato fazer um pedido de saque desde que a meta for atingida
    function withdrawFunds(uint amount, string memory purpose) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient funds.");
        require(goalReached, "The funding goal has not been reached yet.");
        
        WithdrawalRequest storage request = WithdrawalRequests[numRequests];
        numRequests++;
        request.amount = amount;
        request.purpose = purpose;
        request.executed = false;
        request.numOfApprovals = 0;   
    }
    
    // Função que mostra a quantidade de pedidos de saques
    function getWithdrawalRequests() public view returns (uint[] memory) {
        uint[] memory requestIndices = new uint[](numRequests);
        for (uint i = 0; i < numRequests; i++) {
            requestIndices[i] = i;
        }
        return requestIndices;
    }

    // Função para que os donors recebam o reembolso caso o contrato não for cumprido
    function refund() public {
        require(block.timestamp >= deadline, "The deadline for donations has not passed yet.");
        require(!goalReached, "The funding goal has already been reached.");
    
        uint donation = donations[msg.sender];
        require(donation > 0, "You have not made any donations to this campaign.");
    
        donations[msg.sender] = 0;
        totalFunds -= donation;
        numDonors--;
        emit DonationReceived(msg.sender, donation);
    
        payable(msg.sender).transfer(donation);
    }

    // Função para um donor poder aprovar um pedido de saque
    function approveWithdrawalRequest(uint requestIndex) public {
        require(goalReached, "The funding goal has not been reached yet.");
        require(donations[msg.sender] > 0, "You must be a donor to approve a withdrawal request.");

        WithdrawalRequest storage request = WithdrawalRequests[requestIndex];
        require(!request.executed, "The withdrawal request has already been executed.");
        require(!request.approvals[msg.sender], "You have already approved this withdrawal request.");

        uint donationPercentage = (donations[msg.sender] * 100) / totalFunds;
        donationPercentages[msg.sender] = donationPercentage;

        uint votingWeight = (donationPercentages[msg.sender]);

        request.numOfApprovals += votingWeight;
        request.approvals[msg.sender] = true;
    }

    // Função que transfere os fundos descritos no pedido de saque especificado
    function transferWithdrawalRequest(uint requestIndex) public onlyOwner{
        require(goalReached, "The funding goal has not been reached yet.");

        WithdrawalRequest storage request = WithdrawalRequests[requestIndex];
        require(!request.executed, "The withdrawal request has already been executed.");

        if (request.numOfApprovals > 50) {

            request.executed = true;
            payable(owner).transfer(request.amount);
        }
    }
}