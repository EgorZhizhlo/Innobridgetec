
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InnobridgetecCFA {
    struct Sphere {
        string name;
        address sphereToken;
        uint256 totalInvested;
    }

    address public owner;
    uint256 public sphereCount;
    uint256 public constant MAX_SPHERES = 10;
    mapping(uint256 => Sphere) public spheres;
    mapping(address => mapping(uint256 => uint256)) public investorBalances;
    mapping(address => uint256) public unifiedTokenBalances;
    mapping(address => bool) private inWithdrawal;

    event SphereAdded(uint256 indexed sphereIndex, string name, address sphereToken);
    event InvestmentMade(address indexed investor, uint256 sphereIndex, uint256 amount);
    event UnifiedInvestment(address indexed investor, uint256 totalAmount);
    event Withdrawal(address indexed investor, uint256 sphereIndex, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addSphere(string memory name, address sphereToken) external onlyOwner {
        require(sphereCount < MAX_SPHERES, "Maximum spheres limit reached");
        spheres[sphereCount] = Sphere(name, sphereToken, 0);
        emit SphereAdded(sphereCount, name, sphereToken);
        sphereCount++;
    }

    function invest(uint256 sphereIndex) external payable {
        require(sphereIndex < sphereCount, "Invalid sphere index");
        require(msg.value > 0, "Investment amount must be greater than zero");

        spheres[sphereIndex].totalInvested += msg.value;
        investorBalances[msg.sender][sphereIndex] += msg.value;

        emit InvestmentMade(msg.sender, sphereIndex, msg.value);
    }

    function investWithUnifiedToken(uint256[] memory amounts) external payable {
        require(amounts.length == sphereCount, "Invalid input data");

        uint256 totalAmount = 0;
        for (uint256 i = 0; i < sphereCount; i++) {
            require(amounts[i] > 0, "Investment amount must be greater than zero");
            spheres[i].totalInvested += amounts[i];
            investorBalances[msg.sender][i] += amounts[i];
            totalAmount += amounts[i];
        }
        require(msg.value == totalAmount, "Insufficient funds");

        unifiedTokenBalances[msg.sender] += totalAmount;
        emit UnifiedInvestment(msg.sender, totalAmount);
    }

    function getSphere(uint256 index) external view returns (string memory, address, uint256) {
        require(index < sphereCount, "Invalid index");
        Sphere memory sphere = spheres[index];
        return (sphere.name, sphere.sphereToken, sphere.totalInvested);
    }

    function getInvestorBalances(address investor) external view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](sphereCount);
        for (uint256 i = 0; i < sphereCount; i++) {
            balances[i] = investorBalances[investor][i];
        }
        return balances;
    }

    function withdrawFromSphere(uint256 sphereIndex, uint256 amount) external {
        require(sphereIndex < sphereCount, "Invalid sphere index");
        require(!inWithdrawal[msg.sender], "Reentrant call detected");
        require(investorBalances[msg.sender][sphereIndex] >= amount, "Insufficient balance");

        inWithdrawal[msg.sender] = true;

        investorBalances[msg.sender][sphereIndex] -= amount;
        spheres[sphereIndex].totalInvested -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        inWithdrawal[msg.sender] = false;
        emit Withdrawal(msg.sender, sphereIndex, amount);
    }
}
