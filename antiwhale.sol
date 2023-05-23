// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title AntiWhale BEP20 Token
 * @dev Implementation of the AntiWhale BEP20 token.
 * @author CodeWithJd (github.com/CodeWithJd)
 */
contract AntiWhale {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint8 public decimals;

    // Define mapping to track each account's balance
    mapping(address => uint256) public balanceOf;

    // Define mapping to track allowance of a spender on behalf of an owner
    mapping(address => mapping(address => uint256)) public allowance;

    // Define mapping to track accounts exempted from token tax
    mapping(address => bool) public isExemptFromTax;

    // Define maximum limit per wallet
    uint256 private maxWalletLimit;

    // Define maximum transfer amount per transaction
    uint256 private maxTransferAmount;

    // Define tax percentage
    uint256 private _taxPercentage;

    // Define tax multiplier for calculating tax
    uint256 private constant _taxMultiplier = 10000;

    // Address of the deployer of the contract (owner)
    address private _deployer;

    // Address of the marketing wallet that receives the tax
    address private _marketingWallet;

    // Event that is triggered when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Event that is triggered when an allowance is approved
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Initializes the AntiWhale token contract.
     * @param marketingWallet The address of the marketing wallet.
     */
    constructor(address marketingWallet) {
        // Initializing token details
        name = "AntiWhale";
        symbol = "MXD";
        totalSupply = 100000 * 10**10; // 10^10 decimals
        decimals = 10;

        // Assigning total supply to the deployer
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);

        // Setting limits
        maxWalletLimit = totalSupply / 50; // 2% of total supply
        maxTransferAmount = totalSupply / 2000; // 0.05% of total supply

        // Exempting deployer from tax
        isExemptFromTax[msg.sender] = true;
        _deployer = msg.sender;

        // Setting tax percentage
        _taxPercentage = 500; // 5%

        // Setting marketing wallet
        _marketingWallet = marketingWallet;
    }

    /**
     * @dev Transfers tokens from the sender to the given recipient.
     * @param to The address to transfer tokens to.
     * @param value The amount of tokens to transfer.
     * @return A boolean value indicating whether the transfer was successful.
     */
    function transfer(address to, uint256 value) external returns (bool) {
        // Perform necessary checks for address and value
        require(to != address(0), "Invalid address");
        require(value > 0, "Invalid amount");

        // If sender is exempted from tax or is the deployer, perform regular transfer
        if (isExemptFromTax[msg.sender] || msg.sender == _deployer) {
            require(balanceOf[msg.sender] >= value, "Insufficient balance");
            require(balanceOf[to] + value <= maxWalletLimit, "Exceeds maximum wallet limit");
            require(value <= maxTransferAmount, "Exceeds maximum transfer amount");

            balanceOf[msg.sender] -= value;
            balanceOf[to] += value;

            emit Transfer(msg.sender, to, value);
        } else {
            // Else, calculate tax, deduct it and transfer the rest
            uint256 taxAmount = (value * _taxPercentage) / _taxMultiplier;
            uint256 transferAmount = value - taxAmount;

            require(balanceOf[msg.sender] >= value, "Insufficient balance");
            require(balanceOf[to] + transferAmount <= maxWalletLimit, "Exceeds maximum wallet limit");
            require(transferAmount <= maxTransferAmount, "Exceeds maximum transfer amount");

            balanceOf[msg.sender] -= value;
            balanceOf[to] += transferAmount;

            // Transfer the tax to the marketing wallet
            if (taxAmount > 0) {
                balanceOf[_marketingWallet] += taxAmount;
                emit Transfer(msg.sender, _marketingWallet, taxAmount);
            }

            emit Transfer(msg.sender, to, transferAmount);
        }

        return true;
    }

    /**
     * @dev Approves the given spender to spend tokens on behalf of the owner.
     * @param spender The address allowed to spend tokens.
     * @param value The amount of tokens to approve.
     * @return A boolean value indicating whether the approval was successful.
     */
    function approve(address spender, uint256 value) external returns (bool) {
        require(spender != address(0), "Invalid address");

        // Set the allowance for the given spender
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfers tokens from the given sender to the given recipient.
     * @param from The address to transfer tokens from.
     * @param to The address to transfer tokens to.
     * @param value The amount of tokens to transfer.
     * @return A boolean value indicating whether the transfer was successful.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(value > 0, "Invalid amount");
        require(value <= allowance[from][msg.sender], "Exceeds allowance");

        // Decrease the allowance
        allowance[from][msg.sender] -= value;

        // Perform the token transfer
        transferTokens(from, to, value);
        return true;
    }

    /**
     * @dev Internal function to transfer tokens from one address to another.
     * @param from The address to transfer tokens from.
     * @param to The address to transfer tokens to.
     * @param value The amount of tokens to transfer.
     */
    function transferTokens(address from, address to, uint256 value) internal {
        if (isExemptFromTax[from] || from == _deployer) {
            require(balanceOf[from] >= value, "Insufficient balance");
            require(balanceOf[to] + value <= maxWalletLimit, "Exceeds maximum wallet limit");
            require(value <= maxTransferAmount, "Exceeds maximum transfer amount");

            balanceOf[from] -= value;
            balanceOf[to] += value;

            emit Transfer(from, to, value);
        } else {
            uint256 taxAmount = (value * _taxPercentage) / _taxMultiplier;
            uint256 transferAmount = value - taxAmount;

            require(balanceOf[from] >= value, "Insufficient balance");
            require(balanceOf[to] + transferAmount <= maxWalletLimit, "Exceeds maximum wallet limit");
            require(transferAmount <= maxTransferAmount, "Exceeds maximum transfer amount");

            balanceOf[from] -= value;
            balanceOf[to] += transferAmount;

            // Transfer the tax to the marketing wallet
            if (taxAmount > 0) {
                balanceOf[_marketingWallet] += taxAmount;
                emit Transfer(from, _marketingWallet, taxAmount);
            }

            emit Transfer(from, to, transferAmount);
        }
    }
}
