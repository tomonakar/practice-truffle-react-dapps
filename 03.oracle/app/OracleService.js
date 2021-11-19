import Web3 from "web3"
import Tx from "ethereumjs-tx"
import fetch from "node-fetch"

import contractJson from "../build/contracts/Oracle.json"

const web3 = new Web3("ws://127.0.0.1:7545")

// Ganacheからアドレスを取得
const addressContract = "0x5775897c39291A388E7C326DaA44f0fD047E3C4C"
const contractInstance = new web3.eth.Contract(
  contractJson.abi,
  addressContract,
)
const privateKey = Buffer.from(
  "49f3d032423e578e2040c41b9307ddcfe5c5d9681f33773676e3bdb84708d5f1",
  "hex",
)
const address = "0x2AdcCa69B88E0C05D4191246E9C06B1a146D1824"

web3.eth.getBlockNumber().then((n) => listenEvent(n - 1))

function listenEvent(lastBlock) {
  contractInstance.events.__callbackNewData(
    {},
    { fromBlock: lastBlock, toBlock: "latest" },
    (err, event) => {
      event ? updateData() : null
      err ? console.error(err) : null
    },
  )
}

function updateData() {
  const url =
    "https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-07&end_date=2015-09-08&api_key=DEMO_KEY"

  fetch(url)
    .then((res) => res.json())
    .then((json) => setDataContract(json.element_count))
}

function setDataContract(_value) {
  web3.eth.getTransactionCount(address, (err, txNumb) => {
    contractInstance.methods
      .setNumberAsteroids(_value)
      .estimateGas({}, (err, gasAmount) => {
        const rawTx = {
          nonce: web3.utils.toHex(txNumb),
          gasPrice: web3.utils.toHex(web3.utils.toWei("1.4", "gwei")),
          gasLimit: web3.utils.toHex(gasAmount),
          to: addressContract,
          value: "0x00",
          data: contractInstance.methods.setNumberAsteroids(_value).encodeABI(),
        }

        const tx = new Tx(rowTx)
        tx.sign(privateKey)
        const serializedTx = tx.serialize().toString("hex")
        web3.eth.sendSignedTransaction("0x" + serializedTx)
      })
  })
}
