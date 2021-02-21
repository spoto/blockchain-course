package it.univr.ethereumclient;

import java.io.IOException;

import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.EthGasPrice;
import org.web3j.protocol.http.HttpService;

public class GetGasPrice {
	public static void main(String[] args) throws IOException {
		Web3j web3 = Web3j.build
			(new HttpService("https://ropsten.infura.io/v3/05550caa054f4fec80ff94136edf2944"));
		EthGasPrice gasPrice =  web3.ethGasPrice().send();
		System.out.println(gasPrice.getGasPrice());
	}
}

