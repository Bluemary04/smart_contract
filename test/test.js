//VER: ethers.io
const { expect } = require("chai");

describe("CryptoShop Contract", function () {
  async function deployCryptoShopFixture() {
    const [owner] = await ethers.getSigners();

    const CryptoShopContract = await ethers.getContractFactory("CryptoShop");

    const CryptoShop = await CryptoShopContract.deploy();

    await CryptoShop.deployed();

    // Fixtures can return anything you consider useful for your tests
    return { CryptoShop, CryptoShopContract, owner};
  }

  async function addProduct(CryptoShop) {
    const tx = await CryptoShop.addProduct("my producto", 20, 30);
    const receipt = await tx.wait();

    //DEBUG:console.log({events: JSON.stringify(receipt.events, null, 1)});

    const itemIndex = receipt.events[0].args[0];

    return {itemIndex}
  }

  it("Catalog should start empty", async function () {
    const  { CryptoShop } = await deployCryptoShopFixture();

    const catalogLength = await CryptoShop.getCatalogLength();
    expect(catalogLength).to.equal(0);
    await expect(CryptoShop.getCatalogItemAt(1)).to.be.revertedWith("Item not found");
  });

  it("Item added must show in catalog", async function () {
    const { CryptoShop } = await deployCryptoShopFixture();

    const itemIndex0 = await addProduct(CryptoShop);
    console.log({itemIndex0});
    expect(itemIndex0.itemIndex.eq(0), ("Item not found")).to.be.true; //TODO: buscar o agregar una función para loguear bien- ethereum waffle

    const itemIndex1 = await addProduct(CryptoShop); //FOR THIS TEST ONLY, order is non deterministic
    console.log({itemIndex1});
    expect(itemIndex1.itemIndex.eq(1)).to.be.true;
  }); 
    // TO DO: check item data eg: description not empty 
  it("Buying item should decrease stock by 1", async function () {});
  it("Buying item without stock should fail", async function () {});
  it("Buying item below price should fail", async function () {});
});
