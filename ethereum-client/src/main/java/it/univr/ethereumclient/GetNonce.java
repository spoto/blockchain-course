package it.univr.ethereumclient;

import java.math.BigInteger;
import java.util.concurrent.ExecutionException;

import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameterName;
import org.web3j.protocol.core.methods.response.EthGetTransactionCount;
import org.web3j.protocol.http.HttpService;

public class GetNonce {
	private final static String ME = "0xb2B68C5E29C4267A24BB92daC5579D93f9A74812";
	private final Web3j web3 = Web3j.build(new HttpService("https://ropsten.infura.io/v3/05550caa054f4fec80ff94136edf2944"));

	public BigInteger transactionCount() throws InterruptedException, ExecutionException {
		EthGetTransactionCount ethGetTransactionCount = web3.ethGetTransactionCount(ME, DefaultBlockParameterName.LATEST).sendAsync().get();
		return ethGetTransactionCount.getTransactionCount();
	}

	public static void main(String[] args) throws InterruptedException, ExecutionException {
		var gn = new GetNonce();
		System.out.println("Next nonce is " + gn.transactionCount());
	}
}
