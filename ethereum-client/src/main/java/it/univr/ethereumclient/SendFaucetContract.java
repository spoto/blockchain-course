package it.univr.ethereumclient;

import java.io.IOException;
import java.math.BigInteger;
import java.util.concurrent.ExecutionException;

import org.web3j.crypto.RawTransaction;
import org.web3j.protocol.core.methods.response.EthGasPrice;
import org.web3j.protocol.core.methods.response.TransactionReceipt;

public class SendFaucetContract extends SendTransaction {
	// the bytecode can be obtained from Remix or by running
	// solc --bin Faucet.sol
	private final static String BYTECODE = "6080604052348015600e575f80fd5b506101478061001c5f395ff3fe608060405260043610610021575f3560e01c80632e1a7d4d1461002c57610028565b3661002857005b5f80fd5b348015610037575f80fd5b50610052600480360381019061004d91906100e6565b610054565b005b67016345785d8a0000811115610068575f80fd5b3373ffffffffffffffffffffffffffffffffffffffff166108fc8290811502906040515f60405180830381858888f193505050501580156100ab573d5f803e3d5ffd5b5050565b5f80fd5b5f819050919050565b6100c5816100b3565b81146100cf575f80fd5b50565b5f813590506100e0816100bc565b92915050565b5f602082840312156100fb576100fa6100af565b5b5f610108848285016100d2565b9150509291505056fea2646970667358221220152d21817fef5d5bdac9fa699316fb6e33866d3484f27ef0a7eab45a8575445564736f6c634300081a0033";

	public String sendContract() throws InterruptedException, ExecutionException, IOException {
		EthGasPrice gasPrice =  web3.ethGasPrice().send();
		RawTransaction transaction = RawTransaction.createContractTransaction
			(transactionCount(),            // nonce
			gasPrice.getGasPrice(),         // gas price,
			BigInteger.valueOf(125_000L),   // gas limit,
			BigInteger.ZERO,                // value
			BYTECODE);                      // data

		return send(transaction);
	}

	public static void main(String[] args) throws InterruptedException, ExecutionException, IOException {
		var sfc = new SendFaucetContract();
		String hash = sfc.sendContract();
		System.out.println("transaction hash: " + hash);
		TransactionReceipt receipt = sfc.waitForReceipt(hash);
		System.out.println("contract address: " + receipt.getContractAddress());
	}
}
