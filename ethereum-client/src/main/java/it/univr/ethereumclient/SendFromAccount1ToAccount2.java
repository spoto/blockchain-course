package it.univr.ethereumclient;

import java.io.IOException;
import java.math.BigInteger;
import java.util.concurrent.ExecutionException;

import org.web3j.crypto.RawTransaction;
import org.web3j.protocol.core.methods.response.EthGasPrice;

public class SendFromAccount1ToAccount2 extends SendTransaction {

	public String sentFromAccount1ToAccount2() throws InterruptedException, ExecutionException, IOException {
		EthGasPrice gasPrice =  web3.ethGasPrice().send();
		System.out.println("gas price: " + gasPrice.getGasPrice());
		RawTransaction transaction = RawTransaction.createEtherTransaction
			(transactionCount(ACCOUNT_1),    // nonce
			gasPrice.getGasPrice(),          // gas price,
			BigInteger.valueOf(21_000L),     // gas limit,
			ACCOUNT_2,                       // to
			BigInteger.valueOf(15L));        // value

		return send(transaction);
	}

	public static void main(String[] args) throws InterruptedException, ExecutionException, IOException {
		var send = new SendFromAccount1ToAccount2();
		String txHash = send.sentFromAccount1ToAccount2();
		System.out.println("transaction hash: " + txHash);
		System.out.println(send.waitForReceipt(txHash));
	}
}
