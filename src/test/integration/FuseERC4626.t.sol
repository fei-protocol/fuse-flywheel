pragma solidity ^0.8.10;

import {MockERC20} from "../mocks/MockERC20.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {MockFusePriceOracle} from "../mocks/MockFusePriceOracle.sol";
import {CToken} from "../../external/CToken.sol";
import {Unitroller} from "../../external/Unitroller.sol";
import {FuseERC4626} from "../../vaults/fuse/FuseERC4626.sol";
import {DSTestPlus} from "solmate/test/utils/DSTestPlus.sol";
import {FusePoolUtils} from "../utils/FusePoolUtils.sol";

contract IntegrationTestFuseERC4626 is DSTestPlus {
    MockERC20 private token;
    MockERC20 private token2;
    CToken private cToken;
    CToken private cToken2;
    MockFusePriceOracle oracle;
    address private masterOracle;
    Unitroller private troller;
    FuseERC4626 private vault;

    function setUp() public {
        hevm.label(address(this), "IntegrationTestFuseERC4626");

        token = new MockERC20();
        token2 = new MockERC20();
        oracle = new MockFusePriceOracle();

        address[] memory tokens = new address[](2);
        tokens[0] = address(token);
        tokens[1] = address(token2);
        hevm.label(tokens[0], "tokens[0]");
        hevm.label(tokens[1], "tokens[1]");
        hevm.label(address(oracle), "oracle");

        // Rari addresses
        hevm.label(
            FusePoolUtils.MASTER_PRICE_ORACLE_INITIALIZABLECLONES,
            "MasterPriceOracle InitializableClones"
        );
        hevm.label(
            FusePoolUtils.MASTER_PRICE_ORACLE_IMPLEMENTATION,
            "MasterPriceOracle Implementation"
        );
        hevm.label(
            FusePoolUtils.MASTER_PRICE_ORACLE_RARI_DEFAULT,
            "MasterPriceOracle Rari (default)"
        );
        hevm.label(
            FusePoolUtils.FUSE_POOL_DIRECTORY,
            "Rari Capital: Fuse Pool Directory"
        );
        hevm.label(
            FusePoolUtils.FUSE_COMPTROLLER_IMPLEMENTATION,
            "Rari Capital: Comptroller implementation"
        );
        hevm.label(FusePoolUtils.FUSE_JUMP_RATE_MODEL, "JumpRateModel");
        hevm.label(FusePoolUtils.FUSE_CERC20_DELEGATE, "CErc20Delegate");

        // create the Fuse pool
        (
            address _masterOracle,
            address _troller,
            address[] memory _cTokens
        ) = FusePoolUtils.createPool(tokens, address(oracle));

        // set state variables & hevm labels
        masterOracle = _masterOracle;
        troller = Unitroller(_troller);
        cToken = CToken(_cTokens[0]);
        cToken2 = CToken(_cTokens[1]);
        hevm.label(_masterOracle, "masterOracle");
        hevm.label(_troller, "troller");
        hevm.label(_cTokens[0], "cToken");
        hevm.label(_cTokens[1], "cToken2");

        // set oracle price values (static = 1 ETH)
        oracle.mockSetPrice(_cTokens[0], 1e18);
        oracle.mockSetPrice(_cTokens[1], 1e18);

        // create vault
        vault = new FuseERC4626(
            address(cToken),
            "fToken-x ERC4626 wrapper",
            "4626-fToken-x"
        );
        hevm.label(address(vault), "vault");

        // allow this contract to use both tokens as collateral
        // and borrow both tokens
        uint256[] memory results = troller.enterMarkets(_cTokens);
        require(results[0] == 0, "Failed to enter cToken market");
        require(results[1] == 0, "Failed to enter cToken2 market");
    }

    function testFeiRari() public {
        hevm.label(0x956F47F50A910163D8BF957Cf5846D573E7f87CA, "fei");
        hevm.label(0xd8553552f8868C1Ef160eEdf031cF0BCf9686945, "fFei8");
        hevm.label(0xd51dbA7a94e1adEa403553A8235C302cEbF41a3c, "timelock");
        hevm.label(0x8d5ED43dCa8C2F7dFB20CF7b53CC7E593635d7b9, "core");

        ERC20 fei = ERC20(0x956F47F50A910163D8BF957Cf5846D573E7f87CA); // FEI
        CToken fFei8 = CToken(0xd8553552f8868C1Ef160eEdf031cF0BCf9686945); // fFEI-8

        // call core.grantMinter(TestContract) as FEI DAO Timelock
        hevm.prank(0xd51dbA7a94e1adEa403553A8235C302cEbF41a3c); // DAO timelock
        (bool success, ) = address(0x8d5ED43dCa8C2F7dFB20CF7b53CC7E593635d7b9) // core
            .call(
                abi.encodeWithSignature("grantMinter(address)", address(this))
            );
        require(success, "failed to grant minter");
        FuseERC4626 fFei8Vault = new FuseERC4626(
            address(fFei8),
            "fFEI-8 ERC4626 wrapper",
            "wfFEI-8"
        );

        // mint FEI to self
        (success, ) = address(0x956F47F50A910163D8BF957Cf5846D573E7f87CA).call( // fei
            abi.encodeWithSignature(
                "mint(address,uint256)",
                address(this),
                100000 ether
            )
        );
        require(success, "failed to mint fei");

        // allow this contract to use feirari
        address[] memory cTokens = new address[](1);
        cTokens[0] = address(fFei8);
        uint256[] memory results = Unitroller(fFei8.comptroller()).enterMarkets(
            cTokens
        );
        require(results[0] == 0, "Failed to enter fFEI-8 market");

        // deposit in the vault and in the cToken directly
        fei.approve(address(fFei8Vault), 50000 ether);
        fei.approve(address(fFei8), 50000 ether);
        require(fFei8.mint(50000 ether) == 0, "mint failed");
        fFei8Vault.deposit(50000 ether, address(this));

        // borrow
        require(fFei8.borrow(25000 ether) == 0, "borrow failed");

        // check balances
        assertEq(fei.balanceOf(address(this)), 25000 ether);
        assertApproxEq(fFei8Vault.totalAssets(), 50000 ether, 2);
        assertApproxEq(
            fFei8.balanceOf(address(fFei8Vault)),
            fFei8.balanceOf(address(this)),
            1
        );
    }

    function testInit() public {
        // wrapper metadata
        assertEq(address(vault.cToken()), address(cToken));
        assertEq(address(vault.cTokenUnderlying()), address(token));

        // vault metadata
        assertEq(address(vault.asset()), address(token));
        assertEq(vault.totalAssets(), 0);
        assertEq(vault.totalSupply(), 0);

        // balance checks
        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(address(cToken)), 0);
        assertEq(vault.balanceOf(address(this)), 0);
    }

    function testMaxDepositPaused() public {
        // there should be no maximum to deposit initially
        assertEq(vault.maxDeposit(address(this)), type(uint256).max);

        // pause cToken.mint
        troller._setMintPaused(address(cToken), true);

        // the max deposit should be updated
        assertEq(vault.maxDeposit(address(this)), 0);
    }

    function testMaxDepositSupplyCap(uint256 supplyCap) public {
        // there should be no maximum to deposit initially
        assertEq(vault.maxDeposit(address(this)), type(uint256).max);

        // set supply cap in Fuse market to supplyCap
        address[] memory cTokens = new address[](1);
        cTokens[0] = address(cToken);
        uint256[] memory newSupplyCaps = new uint256[](1);
        newSupplyCaps[0] = supplyCap;
        troller._setMarketSupplyCaps(cTokens, newSupplyCaps);

        // the max deposit should be updated
        if (supplyCap != 0) {
            // if non-zero, should be updated to the value
            assertEq(vault.maxDeposit(address(this)), supplyCap);
        } else {
            // if zero, should not have set a maximum
            assertEq(vault.maxDeposit(address(this)), type(uint256).max);
        }
    }

    function testMaxMintPaused() public {
        // there should be no maximum to mint initially
        assertEq(vault.maxMint(address(this)), type(uint256).max);

        // pause cToken.mint
        troller._setMintPaused(address(cToken), true);

        // the max mint should be updated
        assertEq(vault.maxMint(address(this)), 0);
    }

    function testMaxMintSupplyCap(uint256 supplyCap) public {
        // there should be no maximum to mint initially
        assertEq(vault.maxMint(address(this)), type(uint256).max);

        // set supply cap in Fuse market to supplyCap
        address[] memory cTokens = new address[](1);
        cTokens[0] = address(cToken);
        uint256[] memory newSupplyCaps = new uint256[](1);
        newSupplyCaps[0] = supplyCap;
        troller._setMarketSupplyCaps(cTokens, newSupplyCaps);

        // the max mint should be updated
        if (supplyCap != 0) {
            // if non-zero, should be updated to the value
            assertEq(vault.maxMint(address(this)), supplyCap);
        } else {
            // if zero, should not have set a maximum
            assertEq(vault.maxMint(address(this)), type(uint256).max);
        }
    }

    function testMaxWithdrawNoCash() public {
        // deposit
        token.mint(address(this), 1e18);
        token.approve(address(vault), 1e18);
        vault.deposit(1e18, address(this));

        // check the withdrawable amounts
        assertEq(vault.maxWithdraw(address(this)), 1e18);

        // simulate a user borrowing half of the tokens using another token as collateral
        uint256 cash = 0.5e18;
        hevm.mockCall(
            address(cToken),
            abi.encodeWithSignature("getCash()"),
            abi.encodePacked(cash)
        );

        // check updated withdrawable amounts
        assertEq(cToken.getCash(), 0.5e18);
        assertEq(vault.maxWithdraw(address(this)), 0.5e18);
    }

    function testMaxRedeemNoCash() public {
        // deposit
        token.mint(address(this), 1e18);
        token.approve(address(vault), 1e18);
        vault.deposit(1e18, address(this));

        // check the redeemable amounts
        assertEq(vault.maxRedeem(address(this)), 1e18);

        // simulate a user borrowing half of the tokens using another token as collateral
        uint256 cash = 0.5e18;
        hevm.mockCall(
            address(cToken),
            abi.encodeWithSignature("getCash()"),
            abi.encodePacked(cash)
        );

        // check updated redeemable amounts
        assertEq(cToken.getCash(), 0.5e18);
        assertEq(vault.maxRedeem(address(this)), 0.5e18);
    }

    function testTotalAssets(uint256 deposit1) public {
        // deposit() reverts for 0 & overly large values
        hevm.assume(deposit1 > 1);
        hevm.assume(deposit1 <= type(uint128).max);

        uint256 deposit2 = deposit1 / 2;
        uint256 donation = deposit1;

        // the cToken.exchangeRate() can be off by 1 wei, and this exchange
        // rate is used to convert between the number of cTokens held to the
        // number of underlying tokens, so if we have 1000 tokens, we can
        // have up to 5000 wei of error (5 cToken = 1 token).
        uint256 tolerance = 5 * ((deposit1 + deposit2 + donation + 1) / 1e18);
        // under this amount of tokens, the rounding errors become more
        // significant (rounded down divisions etc), so we have to tolerate
        // at least 8 wei of error :
        // - the cToken rounds down
        // - libfuse rounds 6 times (totalBorrows, interestAccumulated, totalReserves, totalAdminFees, totalFuseFees, final mulwadDown)
        // - the vault rounds down
        if (tolerance < 8) tolerance = 8;

        // Example of what happens if we tolerate a fixed error of 1000:
        //  399 986201907602584529     DEPOSIT 1
        //  199 993100953801292264     DEPOSIT 2
        //  599 979302861403876793     DEPOSIT 1 + DEPOSIT 2
        //  999 965504769006461322     DEPOSIT 1 + DEPOSIT 2 + DONATION(=DEPOSIT 1)
        //  999 965504769006460321     AFTER DONATION vault.totalAssets()
        //                 => 1001     error
        //  999 965504769006461322     TOKEN BALANCE ON CTOKEN
        // 2999 013786576756947450     cToken.totalSupply()
        //      200000000000000000     cToken.echangeRateStored() initial
        //      333333333333333333     cToken.echangeRateStored() after donation
        // ~3000 cTokens * 0.20 exchangeRate =  600 tokens => ok before donation
        // ~3000 cTokens * 0.33 exchangeRate = 1000 tokens => ok after donation

        // there should be no assets initially
        assertEq(vault.totalAssets(), 0);

        // first user deposit
        token.mint(address(this), deposit1);
        token.approve(address(vault), deposit1);
        uint256 shares1 = vault.deposit(deposit1, address(this));

        // after deposit1 checks
        assertApproxEq(vault.totalAssets(), deposit1, tolerance);
        assertEq(shares1, deposit1); // initial deposit is 1:1
        assertEq(vault.totalSupply(), deposit1);

        // second user deposit
        token.mint(address(this), deposit2);
        token.approve(address(vault), deposit2);
        uint256 shares2 = vault.deposit(deposit2, address(this));

        // after deposit2 checks
        assertApproxEq(vault.totalAssets(), deposit1 + deposit2, tolerance);
        assertEq(vault.totalSupply(), shares1 + shares2);

        // donation to cToken (increasing share price)
        token.mint(address(cToken), donation);
        assertEq(
            token.balanceOf(address(cToken)),
            deposit1 + deposit2 + donation
        );

        // after donation checks
        assertApproxEq(
            vault.totalAssets(),
            deposit1 + deposit2 + donation,
            tolerance
        );
        assertEq(vault.totalSupply(), shares1 + shares2); // should not move
    }

    function testMint(uint256 shares) public {
        uint256 previewAssets = vault.previewMint(shares);
        token.mint(address(this), previewAssets);
        token.approve(address(vault), previewAssets);

        if (shares == 0) {
            hevm.expectRevert(bytes("ZERO_SHARES"));
            vault.mint(shares, address(this));
        } else if (shares > type(uint128).max) {
            hevm.expectRevert(bytes("MANY_SHARES"));
            vault.mint(shares, address(this));
        } else {
            uint256 balanceBefore = token.balanceOf(address(this));
            uint256 returnedAssets = vault.mint(shares, address(this));
            uint256 spentAssets = balanceBefore -
                token.balanceOf(address(this));

            assertEq(previewAssets, spentAssets);
            assertEq(returnedAssets, spentAssets);
        }
    }

    function testDeposit(uint256 assets) public {
        uint256 previewShares = vault.previewDeposit(assets);
        token.mint(address(this), assets);
        token.approve(address(vault), assets);

        if (assets == 0) {
            hevm.expectRevert(bytes("ZERO_ASSETS"));
            vault.deposit(assets, address(this));
        } else if (assets > type(uint128).max) {
            hevm.expectRevert(bytes("MANY_ASSETS"));
            vault.deposit(assets, address(this));
        } else {
            uint256 balanceBefore = vault.balanceOf(address(this));
            uint256 returnedShares = vault.deposit(assets, address(this));
            uint256 receivedShares = vault.balanceOf(address(this)) -
                balanceBefore;

            assertEq(previewShares, receivedShares);
            assertEq(returnedShares, receivedShares);
        }
    }

    function testRedeem(uint256 shares) public {
        // seed the current contract with vault shares
        token.mint(address(this), type(uint256).max);
        token.approve(address(vault), type(uint256).max);
        vault.mint(type(uint128).max, address(this));
        vault.mint(1e18, address(this));

        if (shares == 0) {
            hevm.expectRevert(bytes("ZERO_SHARES"));
            vault.redeem(shares, address(this), address(this));
        } else if (shares > type(uint128).max) {
            hevm.expectRevert(bytes("MANY_SHARES"));
            vault.redeem(shares, address(this), address(this));
        } else {
            uint256 previewAssets = vault.previewRedeem(shares);
            uint256 balanceBefore = token.balanceOf(address(this));
            uint256 returnedAssets = vault.redeem(
                shares,
                address(this),
                address(this)
            );
            uint256 receivedAssets = token.balanceOf(address(this)) -
                balanceBefore;

            assertEq(previewAssets, receivedAssets);
            assertEq(returnedAssets, receivedAssets);
        }
    }

    function testWithdraw(uint256 assets) public {
        // seed the current contract with vault shares
        token.mint(address(this), type(uint256).max);
        token.approve(address(vault), type(uint256).max);
        vault.mint(type(uint128).max, address(this));
        vault.mint(1e18, address(this));

        if (assets == 0) {
            hevm.expectRevert(bytes("ZERO_ASSETS"));
            vault.withdraw(assets, address(this), address(this));
        } else if (assets > type(uint128).max) {
            hevm.expectRevert(bytes("MANY_ASSETS"));
            vault.withdraw(assets, address(this), address(this));
        } else {
            uint256 previewShares = vault.previewWithdraw(assets);
            uint256 balanceBefore = vault.balanceOf(address(this));
            uint256 returnedShares = vault.withdraw(
                assets,
                address(this),
                address(this)
            );
            uint256 spentShares = balanceBefore -
                vault.balanceOf(address(this));

            assertEq(spentShares, previewShares);
            assertEq(returnedShares, spentShares);
        }
    }
}
