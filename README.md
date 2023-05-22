# antiwhale.sol

This repository contains the smart contract code for AntiWhale (MXD), an ERC20-compatible token deployed on the Binance Smart Chain (BSC). The AntiWale token is designed to provide a decentralized digital currency solution with built-in features for tax deductions, transaction limits, and wallet restrictions.

Key Features:
- Tax Function: The contract includes a tax function that deducts a percentage of the transferred tokens as a tax. The deployer can adjust the tax percentage after deployment, with an initial tax percentage set at 5%.
- Wallet Limit: A single wallet cannot hold more than 2% of the total supply. This restriction prevents concentration of tokens in a single address and promotes wider distribution.
- Transaction Limit: The maximum token transfer per transaction is limited to 0.05% of the total supply. This limit prevents large token movements and enhances liquidity management.
- Marketing Wallet: The collected tax is sent to a marketing wallet address specified by the deployer. The deployer can change the marketing wallet address after deployment.
- Deployer Exemption: The token deployer is exempted from all types of taxes and limits, providing flexibility for managing the token's ecosystem.

CodeWithJD