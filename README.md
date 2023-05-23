# AntiWhale BEP20 Token

## Overview
This repository contains an implementation of a BEP20 token with anti-whale measures. The contract has been developed with Solidity and is meant for deployment on the Binance Smart Chain.

## Key Features

- **Anti-whale Mechanism**: To prevent large-scale market manipulation, the contract has mechanisms in place to limit the number of tokens that can be transferred in a single transaction, as well as the maximum amount of tokens a single wallet can hold.

- **Tax Mechanism**: A tax percentage is applied on each transfer operation. This tax is transferred to a predefined marketing wallet. Notably, certain addresses can be exempted from this tax, and the tax percentage can be adjusted by the deployer of the contract.

- **Flexible Control**: The deployer has the ability to set the maximum transaction limit, the maximum tokens per wallet limit, the tax percentage, and the marketing wallet address.

## Smart Contract

The smart contract, `AntiWhale.sol`, provides the token implementation. It includes the following public methods:

- `transfer(address to, uint256 value)`: Transfers tokens from the sender to the given recipient.

- `approve(address spender, uint256 value)`: Approves the given spender to spend tokens on behalf of the owner.

- `transferFrom(address from, address to, uint256 value)`: Transfers tokens from the given sender to the given recipient.

It also includes the following deployer-only methods:

- `setTaxPercentage(uint256 percentage)`: Sets the tax percentage applied to token transfers.

- `setMaxTransactionLimit(uint256 limit)`: Sets the maximum transaction limit.

- `setMaxWalletLimit(uint256 limit)`: Sets the maximum tokens per wallet limit.

- `setMarketingWallet(address wallet)`: Sets the address of the marketing wallet.

- `setExemptFromTax(address account, bool exempt)`: Sets the exemption status for the given account from token taxes.

## Usage

To use this contract:

1. Deploy it on the Binance Smart Chain.
2. Initialize the contract by setting the `marketingWallet` in the constructor.
3. Set the desired tax percentage, max transaction limit, max wallet limit, marketing wallet address, and tax exemptions as necessary.
4. Transfer tokens to the desired addresses.

## Warning

Please thoroughly test this contract before deploying it on the mainnet. It is always recommended to have the code audited by a reputable firm to ensure security and functionality.
