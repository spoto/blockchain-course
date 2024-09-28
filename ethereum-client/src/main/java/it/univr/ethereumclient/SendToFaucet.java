package it.univr.ethereumclient;

import java.io.IOException;
import java.math.BigInteger;
import java.util.concurrent.ExecutionException;

import org.web3j.crypto.RawTransaction;
import org.web3j.protocol.core.methods.response.EthGasPrice;

public class SendToFaucet extends SendTransaction {
	// the Sepolia faucet
	private final static String FAUCET = "0xC0f3833B7e7216EEcD9f6bC2c7927A7aA36Ab58B";

	public String sendToFaucet() throws InterruptedException, ExecutionException, IOException {
		EthGasPrice gasPrice =  web3.ethGasPrice().send();
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
