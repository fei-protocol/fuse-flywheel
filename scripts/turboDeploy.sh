#!/usr/bin/env bash

RPC_URL= # e.g. http://127.0.0.1:8545/
PRIVATE_KEY= #fill in private key

# Fuse pool 8 config
POOL_8_FEI_C_TOKEN='0xd8553552f8868C1Ef160eEdf031cF0BCf9686945'
POOL_8_NAME='Pool8Shares'
POOL_8_SYMBOL='P8S'

# Fuse pool 18 config
POOL_18_FEI_C_TOKEN='0x17b1A2E012cC4C31f83B90FF11d3942857664efc';
POOL_18_NAME='Pool8Shares';
POOL_18_SYMBOL='P18S';

echo "Deploying Fei fuse strategies..."
# 1. Deploy Pool 8 Fei strategy
POOL_8_STRATEGY=$(forge create FuseERC4626 --constructor-args $POOL_8_FEI_C_TOKEN $POOL_8_NAME $POOL_8_SYMBOL --rpc-url $RPC_URL --private-key $PRIVATE_KEY | grep 'Deployed to:' | awk '{print $NF}')

# 2. Deploy Pool 18 Fei strategy
POOL_18_STRAGEGY=$(forge create FuseERC4626 --constructor-args $POOL_18_FEI_C_TOKEN $POOL_18_NAME $POOL_18_SYMBOL --rpc-url $RPC_URL --private-key $PRIVATE_KEY | grep 'Deployed to:' | awk '{print $NF}')

echo "POOL_8_STRATEGY=$POOL_8_STRATEGY"
echo "POOL_18_STRATEGY=$POOL_18_STRAGEGY"

