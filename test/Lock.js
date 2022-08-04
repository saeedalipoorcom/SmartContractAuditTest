const {
  time,
  loadFixture,
} = require('@nomicfoundation/hardhat-network-helpers');
const {
  anyValue,
} = require('@nomicfoundation/hardhat-chai-matchers/withArgs');
const { expect } = require('chai');

describe('Lock', function () {
  let deployer;
  let addr1;
  let addr2;
  let addr3;

  let TX;
  let answer;

  let RLCContract;

  beforeEach(async () => {
    [deployer, addr1, addr2, addr3] = await ethers.getSigners();

    const RLC = await ethers.getContractFactory('RLC');
    RLCContract = await RLC.deploy();
    await RLCContract.deployed();
  });

  describe('check details', () => {
    it('Should track name and symbol', async () => {
      const tokenName = 'RedLine Coin';
      const tokenSymbol = 'RLC';
      expect(await RLCContract.name()).to.equal(tokenName);
      expect(await RLCContract.symbol()).to.equal(tokenSymbol);

      expect(await RLCContract.balanceOf(deployer.address)).to.equal(
        ethers.utils.parseEther('3000000000')
      );
    });
  });

  describe('Check functions for transfer token between users', () => {
    it('Test transfer contract', async () => {
      // deployer has initial balance and can transfer token !
      await expect(
        RLCContract.connect(deployer).transfer(
          addr2.address,
          ethers.utils.parseEther('1000000000')
        )
      )
        .to.emit(RLCContract, 'Transfer')
        .withArgs(
          deployer.address,
          addr2.address,
          ethers.utils.parseEther('1000000000')
        );

      // now check balance of deployer ! from
      expect(await RLCContract.balanceOf(deployer.address)).to.equal(
        ethers.utils.parseEther('2000000000')
      );

      // now check balance of addr2 ! to
      expect(await RLCContract.balanceOf(addr2.address)).to.equal(
        ethers.utils.parseEther('1000000000')
      );

      // addr1 has not enough balance to transfer and we should get error !
      await expect(
        RLCContract.connect(addr1).transfer(
          addr2.address,
          ethers.utils.parseEther('1')
        )
      ).to.be.revertedWith(
        'there is not enough balance for transfer token'
      );
    });

    it('Test transferFrom contract', async () => {
      // deployer has initial balance and can transfer token !
      TX = await RLCContract.connect(deployer).approve(
        addr2.address,
        ethers.utils.parseEther('3000000000')
      );
      await TX.wait(1);
      // check allowance that deployer created !
      answer = await RLCContract.allowance(
        deployer.address,
        addr2.address
      );
      expect(answer).to.equal(ethers.utils.parseEther('3000000000'));
      // now check balance of addr2 ! to
      expect(await RLCContract.balanceOf(deployer.address)).to.equal(
        ethers.utils.parseEther('3000000000')
      );
      // now make transfer from ! BUT THIS FUNCTION CAN CALL FROM CONTRACTS TO TRANSFER MONEY FROM USER TO THEM !
      await expect(
        RLCContract.connect(addr2).transferFrom(
          deployer.address,
          addr2.address,
          ethers.utils.parseEther('1000000000')
        )
      )
        .to.emit(RLCContract, 'Transfer')
        .withArgs(
          deployer.address,
          addr2.address,
          ethers.utils.parseEther('1000000000')
        );
      // now check balance of deployer ! from
      expect(await RLCContract.balanceOf(deployer.address)).to.equal(
        ethers.utils.parseEther('2000000000')
      );
      // now check balance of addr2 ! to
      expect(await RLCContract.balanceOf(addr2.address)).to.equal(
        ethers.utils.parseEther('1000000000')
      );
      // now allowance should decrease
      answer = await RLCContract.allowance(
        deployer.address,
        addr2.address
      );
      expect(answer).to.equal(ethers.utils.parseEther('2000000000'));
      // now check error with allowance
      // first change allowance !
      TX = await RLCContract.connect(deployer).approve(
        addr2.address,
        ethers.utils.parseEther('1000000000')
      );
      await TX.wait(1);
      // now see in action :)
      await expect(
        RLCContract.connect(deployer).transferFrom(
          deployer.address,
          addr2.address,
          ethers.utils.parseEther('2000000000')
        )
      ).to.be.revertedWith(
        'there is not enough allowance for transfer token'
      );
      // lest check something :) address 3 can't  transfer from because of require allowance!
      // now address 3 call function transfer from to transfer token from deployer to his address
      await expect(
        RLCContract.connect(addr3).transferFrom(
          deployer.address,
          addr3.address,
          ethers.utils.parseEther('100')
        )
      ).to.be.revertedWith(
        'there is not enough allowance for transfer token'
      );
    });
  });
});
