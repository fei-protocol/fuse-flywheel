// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {Unitroller} from "../../external/Unitroller.sol";

library FusePoolUtils {
    address public constant MASTER_PRICE_ORACLE_INITIALIZABLECLONES =
        address(0x91cE5566DC3170898C5aeE4ae4dD314654B47415);
    address public constant MASTER_PRICE_ORACLE_IMPLEMENTATION =
        address(0xb3c8eE7309BE658c186F986388c2377da436D8fb);
    address public constant MASTER_PRICE_ORACLE_RARI_DEFAULT =
        address(0x1887118E49e0F4A78Bd71B792a49dE03504A764D);
    address public constant FUSE_POOL_DIRECTORY =
        address(0x835482FE0532f169024d5E9410199369aAD5C77E);
    address public constant FUSE_COMPTROLLER_IMPLEMENTATION =
        address(0xE16DB319d9dA7Ce40b666DD2E365a4b8B3C18217);
    address public constant FUSE_JUMP_RATE_MODEL =
        address(0xbAB47e4B692195BF064923178A90Ef999A15f819);
    address public constant FUSE_CERC20_DELEGATE =
        address(0x67Db14E73C2Dce786B5bbBfa4D010dEab4BBFCF9);

    function createPool(address[] memory tokens, address oracle)
        external
        returns (
            address masterOracle,
            address troller,
            address[] memory cTokens
        )
    {
        // create a new master price oracle
        (bool success, bytes memory data) = MASTER_PRICE_ORACLE_INITIALIZABLECLONES
            .call(
                abi.encodeWithSignature(
                    "clone(address,bytes)",
                    MASTER_PRICE_ORACLE_IMPLEMENTATION,
                    abi.encodeWithSignature(
                        "initialize(address[],address[],address,address,bool)",
                        new address[](0), // underlyings
                        new address[](0), // oracles
                        MASTER_PRICE_ORACLE_RARI_DEFAULT, // default oracle
                        address(this), // pool admin
                        true // canAdminOwerwrite
                    )
                )
            );
        require(success, "Error creating master price oracle");
        assembly {
            masterOracle := mload(add(data, 32))
        }

        // create a new Rari pool (call Rari Capital: Fuse Pool Directory)
        (success, data) = FUSE_POOL_DIRECTORY.call(
            abi.encodeWithSignature(
                "deployPool(string,address,bool,uint256,uint256,address)",
                "Test Pool", // name
                FUSE_COMPTROLLER_IMPLEMENTATION, // implementation
                false, // enforceWhitelist
                0.5e18, // closeFactor
                1.08e18, // liquidationIncentive
                masterOracle // priceOracle
            )
        );
        require(success, "Error creating pool");
        assembly {
            troller := mload(add(data, 64))
        }

        // accept admin of the comptroller
        Unitroller(troller)._acceptAdmin();

        // add token price to master oracle
        address[] memory oracles = new address[](tokens.length);
        for (uint256 i = 0; i < oracles.length; i++) {
            oracles[i] = oracle;
        }
        (success, data) = masterOracle.call(
            abi.encodeWithSignature("add(address[],address[])", tokens, oracles)
        );
        require(success, "Error setting new token price feed in master oracle");

        // add tokens in the fuse pool
        cTokens = new address[](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            Unitroller(troller)._deployMarket(
                false, // isCEther
                abi.encode( // CErc20Delegator constructor data
                    tokens[i], // underlying
                    troller, // comptroller
                    FUSE_JUMP_RATE_MODEL, // interestRateModel
                    "fToken-x", // name
                    "Fuse pool x Token", // symbol
                    FUSE_CERC20_DELEGATE, // implementation
                    bytes(""), // becomeImplementationData
                    uint256(0), // reserveFactorMantissa
                    uint256(0) // adminFeeMantissa
                ),
                0.7e18 // collateralFactorMantissa
            );
            cTokens[i] = Unitroller(troller).cTokensByUnderlying(tokens[i]);
            require(
                cTokens[i] != address(0),
                "Error adding token to Fuse pool"
            );
        }
    }
}
