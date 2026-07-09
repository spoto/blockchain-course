package it.univr.ethereumclient;

import java.io.IOException;
import java.math.BigInteger;
import java.util.concurrent.ExecutionException;

import org.web3j.crypto.RawTransaction;
import org.web3j.protocol.core.methods.response.EthGasPrice;

public class SendToFaucet extends SendTransaction {
	// the Sepolia faucet
	private final static String FAUCET = "0x15095Ec8FB1Fc9C664b3223459dFF43158ACe7aD";

	public String sendToFaucet() throws InterruptedException, ExecutionException, IOException {
		EthGasPrice gasPrice =  web3.ethGasPrice().send();
		System.out.println("gas price: " + gasPrice.getGasPrice());
		RawTransaction transaction = RawTransaction.createEtherTransaction
			(transactionCount(),             // nonce
			gasPrice.getGasPrice(),          // gas price,
			BigInteger.valueOf(21_000L),     // gas limit,
			FAUCET,                          // to
			BigInteger.valueOf(5L)); // value

		return send(transaction);
	}

	public static void main(String[] args) throws InterruptedException, ExecutionException, IOException {
		var stf = new SendToFaucet();
		System.out.println("transaction hash: " + stf.sendToFaucet());
	}
}
