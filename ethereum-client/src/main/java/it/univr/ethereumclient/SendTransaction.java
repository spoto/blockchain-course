package it.univr.ethereumclient;

import java.io.IOException;
import java.math.BigInteger;
import java.util.concurrent.ExecutionException;

import org.web3j.crypto.Credentials;
import org.web3j.crypto.RawTransaction;
import org.web3j.crypto.TransactionEncoder;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameterName;
import org.web3j.protocol.core.methods.response.EthGetTransactionCount;
import org.web3j.protocol.core.methods.response.EthSendTransaction;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.protocol.http.HttpService;
import org.web3j.utils.Numeric;

public abstract class SendTransaction {
	protected final static String ME = "0x4f1CF0e04eb777Ede3Bb3460e4b20082A77d646F";
	private final static String ME_PRIVATE_KEY = "31ac46239c94e15105f9399f4b02bd76d0ccea75832c55cc5532a762bb44a57a";
	private final static Credentials credentials = Credentials.create(ME_PRIVATE_KEY);
	protected final Web3j web3 = Web3j.build
		(new HttpService("https://sepolia.infura.io/v3/05550caa054f4fec80ff94136edf2944"));

	public BigInteger transactionCount() throws InterruptedException, ExecutionException {
		EthGetTransactionCount ethGetTransactionCount = web3.ethGetTransactionCount
			(ME, DefaultBlockParameterName.LATEST).sendAsync().get();
		return ethGetTransactionCount.getTransactionCount();
	}

	public final String send(RawTransaction transaction) throws InterruptedException, ExecutionException {
		byte[] signedMessage = TransactionEncoder.signMessage(transaction, credentials);
		String hexValue = Numeric.toHexString(signedMessage);
		System.out.println("signed transaction: " + hexValue);
		EthSendTransaction tr = web3.ethSendRawTransaction(hexValue).sendAsync().get();
		System.out.println("errors: " + tr.hasError());
		if (tr.hasError())
			System.out.println(tr.getError().getMessage());
		return tr.getTransactionHash();
	}

	public final TransactionReceipt waitForReceipt(String transactionHash) throws InterruptedException, IOException {
		TransactionReceipt result;
		do {
			Thread.sleep(10_000);
			result = web3.ethGetTransactionReceipt(transactionHash).send().getResult();
		}
		while (result == null);

		return result;
	}
}
