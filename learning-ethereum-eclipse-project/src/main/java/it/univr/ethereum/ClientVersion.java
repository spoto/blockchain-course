package it.univr.ethereum;

import java.io.IOException;

import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.Web3ClientVersion;
import org.web3j.protocol.http.HttpService;

public class ClientVersion {
	public static void main(String[] args) throws IOException {
		Web3j web3 = Web3j.build(new HttpService("https://ropsten.infura.io/v3/05550caa054f4fec80ff94136edf2944"));
		Web3ClientVersion web3ClientVersion = web3.web3ClientVersion().send();
		System.out.println(web3ClientVersion.getWeb3ClientVersion());
	}
}
