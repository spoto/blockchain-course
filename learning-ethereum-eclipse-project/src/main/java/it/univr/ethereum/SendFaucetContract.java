package it.univr.ethereum;

import java.io.IOException;
import java.math.BigInteger;
import java.util.concurrent.ExecutionException;

import org.web3j.crypto.RawTransaction;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.utils.Convert;
import org.web3j.utils.Convert.Unit;

public class SendFaucetContract extends SendTransaction {
	// the bytecode can be obtained from Remix or by running
	// solc --bin Faucet.sol
	private final static String BYTECODE = "608060405234801561001057600080fd5b5060e78061001f6000396000f3fe608060405260043610601c5760003560e01c80632e1a7d4d14601e575b005b348015602957600080fd5b50605360048036036020811015603e57600080fd5b81019080803590602001909291905050506055565b005b67016345785d8a0000811115606957600080fd5b3373ffffffffffffffffffffffffffffffffffffffff166108fc829081150290604051600060405180830381858888f1935050505015801560ae573d6000803e3d6000fd5b505056fea265627a7a72315820e340ff6efbc9d1c29bb236686fb6a9afeb721330419e71152617ce949a179dfe64736f6c634300050b0032";

	public String sendContract() throws InterruptedException, ExecutionException {
		RawTransaction transaction = RawTransaction.createContractTransaction
			(transactionCount(),                          // nonce
			Convert.toWei("1", Unit.GWEI).toBigInteger(), // gas price,
			BigInteger.valueOf(200_000L),                 // gas limit,
			BigInteger.ZERO,                              // value
			BYTECODE);                                    // data

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
