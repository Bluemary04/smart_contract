//VER: ethers.io
const { expect } = require("chai");

describe("CryptoShop Contract", function () {
  async function deployCryptoShopFixture() {
    const [owner, address1, address2] = await ethers.getSigners();

    const CryptoShopContract = await ethers.getContractFactory("CryptoShop");

    const CryptoShop = await CryptoShopContract.deploy();

    await CryptoShop.deployed();

    // Fixtures can return anything you consider useful for your tests
    return { CryptoShop, CryptoShopContract, owner, address1, address2 };
  }

  async function addProduct(CryptoShop, description, price, quantity) {
    const tx = await CryptoShop.addProduct(description, price, quantity);
    const receipt = await tx.wait();

    //DEBUG:console.log({events: JSON.stringify(receipt.events[0].transactionHash)});

    const itemIndex = receipt.events[0].args[0];

    const itemDetail = receipt.events[0].args[1];

    const productId = receipt.events[0].transactionHash;

    return { itemIndex, itemDetail, productId }
  }

  describe("Product catalog", function () {
    it("Catalog should start empty", async function () {
      const { CryptoShop } = await deployCryptoShopFixture();

      const catalogLength = await CryptoShop.getCatalogLength();
      expect(catalogLength, ("Catalog is not empty")).to.equal(0);
      await expect(CryptoShop.getCatalogItemAt(1)).to.be.revertedWith("Item not found");
    });

    it("Item added must show in catalog", async function () {
      const { CryptoShop } = await deployCryptoShopFixture();

      const itemIndex0 = await addProduct(CryptoShop, "My description", 20, 30);
      const itemIndex1 = await addProduct(CryptoShop, "My description", 20, 30); //FOR THIS TEST ONLY, order is non deterministic
      await expect(itemIndex0.itemIndex.eq(0), (`Item at position ${itemIndex0.itemIndex} does not equal ${0}`)).to.be.true;
      await expect(itemIndex1.itemIndex.eq(1), (`Item at position ${itemIndex0.itemIndex} does not equal ${1}`)).to.be.true;
    });

    it("Item added without price or stock should fail", async function () {
      const { CryptoShop } = await deployCryptoShopFixture();

      await expect(addProduct(CryptoShop, "My description", 0, 30)).to.be.revertedWith("Price must be greater than 0");
      await expect(addProduct(CryptoShop, "My description", 20, 0)).to.be.revertedWith("Stock must be greater than 0");
    });
    // TO DO: check item data eg: description not empty 
  })

  describe("Buy product", function () {
    it("Buying item should decrease stock by 1", async function () { });

    it("Buying product with correct transaction should emit product id", async function () {
      const { CryptoShop, owner, address2 } = await deployCryptoShopFixture();
      const { itemDetail, productId } = await addProduct(CryptoShop, "My description", 5, 1);

      await expect(CryptoShop.buyProduct(productId, itemDetail.price, 1, address2.address))
        .to.emit(CryptoShop, "Transfer").withArgs(owner.address, address2.address, itemDetail.price);
    })

    it("Buying item without enough stock should fail", async function () {
      const { CryptoShop, owner } = await deployCryptoShopFixture();
      const { itemDetail, productId } = await addProduct(CryptoShop, "My description", 5, 1);

      await expect(CryptoShop.buyProduct(productId, itemDetail.price, 0, owner.address)).to.be.revertedWith("Not enough stock to complete transaction");
    });

    it("Buying item below price should fail", async function () {
      const { CryptoShop, owner } = await deployCryptoShopFixture();
      const { itemDetail, productId } = await addProduct(CryptoShop, "My description", 20, 10);

      //DEBUG:console.log(itemDetail);

      await expect(CryptoShop.buyProduct(productId, itemDetail.price, 1, owner.address)).to.be.revertedWith("Not enough tokens");
    });
  })

});
