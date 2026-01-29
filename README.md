# dex-amm-protocol

A simplified Decentralized Exchange using Automated Market Maker (AMM) protocol with constant product formula \(x * y = k\).

## Project Overview

This project implements a fully functional Decentralized Exchange (DEX) using the Automated Market Maker (AMM) model, similar to Uniswap V2. It demonstrates how DeFi protocols enable decentralized trading without centralized intermediaries.

## Task Description

The objective is to build a simplified DEX that allows users to:

- Add liquidity to trading pairs and receive LP (Liquidity Provider) tokens
- Remove liquidity by burning LP tokens
- Swap between two ERC-20 tokens using the constant product formula
- Earn trading fees as a liquidity provider

## Key Features

### 1. Liquidity Pool Management

- Add initial and subsequent liquidity to the pool
- Proportional LP token minting using the square root formula for initial liquidity
- LP token distribution based on share of the pool
- Remove liquidity and withdraw tokens with accrued fees

### 2. Constant Product Formula (AMM)

- Implements the formula: `x * y = k`
- Where `x` and `y` are token reserves and `k` remains constant (ignoring fees)
- Automatic price discovery based on reserve ratios
- Fee mechanism ensures \(k'\) is greater than or equal to \(k\) after swaps

### 3. Trading Mechanism

- Swap TokenA for TokenB: `swapAForB()`
- Swap TokenB for TokenA: `swapBForA()`
- 0.3% trading fee mechanism:
  - `amountInWithFee = amountIn * 997`
  - `amountOut = (amountInWithFee * reserveOut) / ((reserveIn * 1000) + amountInWithFee)`
  - Fees remain in the pool, benefiting liquidity providers

### 4. Price Discovery

- Current price: `price = reserveB / reserveA`
- Price updates dynamically after each trade
- `getPrice()` and `getReserves()` functions expose pool state

## Architecture

### Smart Contracts

#### `contracts/DEX.sol`

Main DEX contract implementing:

- State management for token reserves and LP ownership
- Liquidity management functions
- Swap functionality with fee calculations
- Price discovery mechanisms
- Square root calculation for LP token minting

**Key Functions:**

- `addLiquidity(uint256 amountA, uint256 amountB)` – Add liquidity to the pool
- `removeLiquidity(uint256 liquidityAmount)` – Remove liquidity and burn LP tokens
- `swapAForB(uint256 amountAIn)` – Swap token A for token B
- `swapBForA(uint256 amountBIn)` – Swap token B for token A
- `getPrice()` – Get current exchange rate
- `getReserves()` – Get current pool reserves
- `getAmountOut()` – Calculate output amount with fees

#### `contracts/MockERC20.sol`

ERC-20 token contract for testing:

- Inherits from OpenZeppelin’s ERC20
- Mints 1 million tokens to deployer on creation
- Includes mint function for test token distribution

## Testing

### Test Suite: `test/DEX.test.js`

Comprehensive testing with **27** test cases covering:

#### Liquidity Management Tests (8)

- Initial liquidity provision
- Correct LP token minting for first provider
- Subsequent liquidity additions
- Price ratio maintenance
- Partial liquidity removal
- Correct token amounts on removal
- Error handling for zero amounts
- Prevention of over-withdrawal

#### Token Swap Tests (8)

- Token A to Token B swaps
- Token B to Token A swaps
- Correct output calculation with 0.3% fee
- Reserve updates after swaps
- Constant product verification (k increases due to fees)
- Error handling for zero swaps
- Large swaps with high price impact
- Multiple consecutive swaps

#### Price Calculation Tests (3)

- Initial price verification
- Price updates after swaps
- Error handling for zero reserves

#### Fee Distribution Tests (2)

- Fee accumulation for liquidity providers
- Fee distribution to LPs based on pool share (overall value does not decrease)

#### Edge Case Tests (3)

- Very small liquidity amounts
- Very large liquidity amounts
- Unauthorized access prevention

#### Event Tests (3)

- `LiquidityAdded` event emission
- `LiquidityRemoved` event emission
- `Swap` event emission

## Running Tests

### Without Docker

```bash
npm install
npm run compile
npm test
npm run coverage
npm run deploy

With Docker
bash
docker-compose up --build -d
docker-compose exec app npm test
docker-compose exec app npm run coverage
docker-compose exec app npm run deploy
docker-compose down
Setup Instructions
Prerequisites
Node.js v18+ (tested with v20 and v24)

Docker & Docker Compose (optional)

Git

## Installation (Local)
Clone the repository:

bash
git clone https://github.com/N-Haritha16/dex_Amm_protocol
cd dex_Amm_protocol
Install dependencies:

bash
npm install
Compile contracts:

bash
npm run compile
Run tests:

bash
npm test
Check coverage:

bash
npm run coverage
# Example result:
# Statements: 97.5%, Branches: 66.67%, Functions: 90.91%, Lines: 98.44%
Deploy contracts (Hardhat local network):

bash
npm run deploy
# Example output:
# Deploying DEX AMM...
# Token A deployed to: 0x...
# Token B deployed to: 0x...
# DEX deployed to:     0x...
Docker Setup
Build and start containers:

bash
docker-compose up --build -d
Run tests in container:

bash
docker-compose exec app npm test
View coverage:

bash
docker-compose exec app npm run coverage
Deploy from container:

bash
docker-compose exec app npm run deploy
Stop containers:

bash
docker-compose down
Note: Recent Docker Compose versions ignore the version field in docker-compose.yml; it is safe to remove it to avoid warnings.

## Implementation Details
Mathematical Formulas
LP Token Minting (First Provider)
text
liquidityMinted = sqrt(amountA * amountB)
Subsequent Liquidity Additions
text
liquidityA      = (amountA * totalLiquidity) / reserveA
liquidityB      = (amountB * totalLiquidity) / reserveB
liquidityMinted = min(liquidityA, liquidityB)  // balanced pool
Liquidity Removal
text
amountA = (liquidityBurned * reserveA) / totalLiquidity
amountB = (liquidityBurned * reserveB) / totalLiquidity
Swap Output Calculation (0.3% Fee)
text
amountInWithFee = amountIn * 997     // 99.7% of input (0.3% fee)
numerator       = amountInWithFee * reserveOut
denominator     = (reserveIn * 1000) + amountInWithFee
amountOut       = numerator / denominator
Constant Product Formula Verification
text
Before swap: k  = reserveA * reserveB
After swap:  k' = reserveA' * reserveB'
The fee mechanism ensures 
k
′
≥
k
k 
′
 ≥k, since fees stay in the pool and are distributed indirectly to LPs.

Project Structure
text
dex-amm-protocol/
├── contracts/
│   ├── DEX.sol              # Main DEX implementation
│   └── MockERC20.sol        # ERC-20 token for testing
├── test/
│   └── DEX.test.js          # 27 comprehensive test cases
├── scripts/
│   └── deploy.js            # Deployment script
├── Dockerfile               # Docker container configuration
├── docker-compose.yml       # Docker Compose setup
├── .dockerignore            # Files to exclude from Docker builds
├── hardhat.config.js        # Hardhat configuration
├── package.json             # Project dependencies & scripts
└── README.md                # Documentation (this file)
Technologies Used
Solidity 0.8.19 – Smart contract language

Hardhat – Ethereum development framework

Ethers.js – Ethereum JavaScript library

Chai – Assertion library for testing

Node.js 18+ – JavaScript runtime

Docker – Containerization

OpenZeppelin – Secure smart contract libraries

Smart Contracts Implemented
DEX.sol – Full AMM functionality (liquidity, swaps, pricing, fees)

MockERC20.sol – ERC-20 token for testing and local experimentation

Comprehensive Test Suite
27 test cases covering:

Liquidity management

Swap mechanics

Fee accumulation and distribution

Edge cases

Event emissions

Configuration & Setup
Hardhat configuration with optimizer settings

package.json scripts:

compile, test, coverage, deploy

Docker setup:

Dockerfile, docker-compose.yml, .dockerignore

Deployment
scripts/deploy.js handles automated deployment and logs contract addresses.

## Documentation
This README for high-level overview and usage

NatSpec-style comments in contracts

Clear function naming and separation of concerns

## Security Considerations
Input validation for non-zero amounts

Proper reserve tracking and updates

Overflow protection via Solidity 0.8+ checked arithmetic

Event emissions for all critical state changes

Fee calculation using integer math to avoid precision errors

## Known Limitations
No slippage protection (could add minAmountOut parameters)

Single trading pair per DEX instance

No flash loans or flash swaps

Basic access control; no role-based permissions or governance

## Future Enhancements
Slippage protection via minAmountOut

Support for multiple trading pairs

Flash swap functionality

Governance token and staking mechanisms

Time-locked operations for governance

Multi-hop routing for better price discovery

## Repository
🔗 GitHub: https://github.com/N-Haritha16/dex_Amm_protocol