# Flipper Contract (PolkaVM)

This is a simple "Flipper" smart contract written in Rust for the Polkadot Virtual Machine (PVM). It stores a single boolean value that can be flipped between `true` and `false`. This project demonstrates how to write, compile, and deploy RISC-V smart contracts on Polkadot using the `pallet-revive` stack.

## Prerequisites

Before getting started, ensure you have the following tools installed:

1.  **Rust & Cargo**:
    ```bash
    cargo install --force --locked cargo-pvm-contract
    ```

2.  **Foundry (for `cast` and `alloy`)**:
    ```bash
    curl -L https://foundry.paradigm.xyz | bash
    foundryup
    ```
3. **Having an available network to deploy**: You may [either run a local node](https://docs.polkadot.com/smart-contracts/dev-environments/local-dev-node/), or deploy on the Polkadot Testnet.

## Compilation

To compile the contract into a `.polkavm` binary:

```bash
cargo build
```

This will produce the PolkaVM bytecode at:
`target/flipper.debug.polkavm` (or `target/flipper.polkavm` for release builds).

## Deployment

We use `cast` (from Foundry) to deploy the contract via the Ethereum JSON-RPC compatibility layer provided by `revive`.

1.  **Set up environment variables**:
    ```bash
    export ETH_RPC_URL="https://services.polkadothub-rpc.com/testnet" # If using a localnode, set it to: http://localhost:8545
    export PRIVATE_KEY=0x5fb92d6e98884f76de468fa3f6278f8807c48bebc13595d45af5bdc4da702133
    ```
    > [!CAUTION]
    > **SECURITY WARNING**: The private key above is a well-known standard development key for the `revive-dev-node`. It works out of the box for local testing but **MUST NOT BE USED FOR PRODUCTION PURPOSES!!!!** Doing so will result in the loss of your funds.

2.  **Deploy the contract**:

    **Option 1: Using `jq` (Recommended)**
    ```bash
    RUST_ADDRESS=$(cast send --private-key $PRIVATE_KEY --create "$(xxd -p -c 99999 target/flipper.debug.polkavm)" --json | jq -r .contractAddress)
    echo "Deployed at: $RUST_ADDRESS"
    ```

    **Option 2: Manual (No `jq`)**
    If you don't have `jq` installed, run the command without piping to it:
    ```bash
    cast send --private-key $PRIVATE_KEY --create "$(xxd -p -c 99999 target/flipper.debug.polkavm)"
    ```

    You should see output similar to this:
    ```text
    blockHash            0xf215391078dd412eb90095e5c5ad4454a761299ef51ce9ad44e0dc5178f957ee
    blockNumber          2
    contractAddress      <YOUR_CONTRACT_ADDRESS>
    cumulativeGasUsed    0
    effectiveGasPrice    50000000000
    from                 0xf24FF3a9CF04c71Dbc94D0b566f7A27B94566cac
    gasUsed              295239
    logs                 [{"address":"0xc01ee7f10ea4af4673cfff62710e1d7792aba8f3","topics":["0x1865bbf6b35a0abc70661ed5e4050e07bb8d173ef7c0c116598f4d4adb7a668a"],"data":"0x0000000000000000000000000000000000000000000000000000000000000001","blockHash":"0xf215391078dd412eb90095e5c5ad4454a761299ef51ce9ad44e0dc5178f957ee","blockNumber":"0x2","transactionHash":"0x93ebd9be398540e72ce2f656173dcc49e7551d6ea875ff58c1aca06264c7dea6","transactionIndex":"0x1","logIndex":"0x3","removed":false}]
    logsBloom            0x00000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000400000000000000000000000000000000000000001000
    root
    status               1 (success)
    transactionHash      0x93ebd9be398540e72ce2f656173dcc49e7551d6ea875ff58c1aca06264c7dea6
    transactionIndex     1
    type                 2
    blobGasPrice
    blobGasUsed
    to                   0xc01Ee7f10EA4aF4673cFff62710E1D7792aBa8f3
    ```

    Copy the `contractAddress` manually and set the environment variable:
    ```bash
    export RUST_ADDRESS=<YOUR_CONTRACT_ADDRESS>
    ```

## Interaction

Once deployed, you can interact with the contract using `cast`.

### Check Current Value
The `get()` function returns the current boolean state.

```bash
cast call $RUST_ADDRESS "get() returns (bool)"
```

### Flip the Value
The `flip()` function toggles the boolean state.

```bash
cast send --private-key $PRIVATE_KEY $RUST_ADDRESS "flip()"
```

### Verify Change
Call `get()` again to see the flipped value.

```bash
cast call $RUST_ADDRESS "get() returns (bool)"
```

## Project Structure

- `src/flipper.rs`: The smart contract logic.
- `Flipper.sol`: The Solidity interface/ABI definition.
    > **Note**: While this file defines the ABI, the Rust contract uses the `sol!` macro to define the interface inline for demonstration purposes. In a real-world scenario, you could generate the ABI from this Solidity file.
- `Cargo.toml`: Project dependencies and configuration.
