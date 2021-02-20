package it.univr.ethereumclient;

import java.math.BigInteger;
import java.util.concurrent.ExecutionException;

import org.web3j.crypto.RawTransaction;

public class SendToFaucet extends SendTransaction {
	// the Ropsten faucet
	private final static String FAUCET = "0x81b7E08F65Bdf5648606c89998A9CC8164397647";

	public String sendToFaucet() throws InterruptedException, ExecutionException {
		RawTransaction transaction = RawTransaction.createEtherTransaction
			(transactionCount(),             // nonce
			BigInteger.valueOf(100_000L),    // gas price,
			BigInteger.valueOf(21_000L),     // gas limit,
			FAUCET,                          // to
			BigInteger.valueOf(5_000_000L)); // value

		return send(transaction);
	}

	public static void main(String[] args) throws InterruptedException, ExecutionException {
		var stf = new SendToFaucet();
		System.out.println("transaction hash: " + stf.sendToFaucet());
	}
}
