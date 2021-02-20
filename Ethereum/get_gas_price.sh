#!/bin/sh

# complete below with your own Infura ID
curl https://mainnet.infura.io/v3/05550caa054f4fec80ff941... -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_gasPrice", "params": [],"id":1}'
