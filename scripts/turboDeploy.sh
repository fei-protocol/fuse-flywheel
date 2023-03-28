#!/usr/bin/env bash

RPC_URL=# e.g. http://127.0.0.1:8545/
PRIVATE_KEY=#fill in private key

# Fuse pool 18 config
POOL_18_FEI_C_TOKEN='0x17b1A2E012cC4C31f83B90FF11d3942857664efc';
POOL_18_NAME='Fuse Pool 18 FEI ERC4626 Vault';
POOL_18_SYMBOL='4626-fFEI-18';

# 1. Deploy Pool 18 Fei strategy
POOL_18_STRAGEGY=$(forge create FuseERC4626 --constructor-args $POOL_18_FEI_C_TOKEN $POOL_18_NAME $POOL_18_SYMBOL --rpc-url $RPC_URL --private-key $PRIVATE_KEY | grep 'Deployed to:' | awk '{print $NF}')

echo "POOL_18_STRATEGY=$POOL_18_STRAGEGY"

