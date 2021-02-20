package it.univr.ethereumclient;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.Collections;
import java.util.concurrent.ExecutionException;

import org.web3j.abi.FunctionEncoder;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.generated.Uint256;
import org.web3j.crypto.RawTransaction;
import org.web3j.utils.Convert;
import org.web3j.utils.Convert.Unit;

public class CallWithdraw extends SendTransaction {
	// a Faucet.sol already deployed (for instance, with Remix)
	private final static String FAUCET = "0x78D632E695458B87ec7747234C2c9B306d3aa197";

	public String withdrawFromFaucetContract() throws InterruptedException, ExecutionException {
		Function sig = new Function("withdraw", // function name
			Arrays.asList(new Uint256(Convert.toWei("1", Unit.SZABO).toBigInteger())), // actuals
			Collections.emptyList()); // return types

		String data = FunctionEncoder.encode(sig);

		RawTransaction transaction = RawTransaction.createTransaction
			(transactionCount(),                           // nonce
			Convert.toWei("10", Unit.GWEI).toBigInteger(), // gas price,
			BigInteger.valueOf(50_000L),                   // gas limit,
			FAUCET,                                        // to
			data);                                         // value

		return send(transaction);
	}

	public static void main(String[] args) throws InterruptedException, ExecutionException {
		var cw = new CallWithdraw();
		System.out.println("transaction hash: " + cw.withdrawFromFaucetContract());
	}
}

