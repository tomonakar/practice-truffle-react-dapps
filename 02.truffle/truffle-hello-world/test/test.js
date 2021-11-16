const Hello = artifacts.require("Hello")

contract("Hello", (accounts) => {
  it("1. Function getMessage(): メッセージを受け取る", async () => {
    const instance = await Hello.deployed()
    const message = await instance.getMessage.call({ from: accounts[0] })
    assert.equal(message, "Hello world")
  })

  it("2. Function setMessage(): メッセージ変更", async () => {
    const instance = await Hello.deployed()
    const tx = await instance.setMessage("Joan", { from: accounts[2] })
    console.log(accounts)
    console.log(accounts[2])
    console.log(tx)
    const msg = await instance.getMessage.call()
    assert.equal(msg, "Joan")
  })
})
