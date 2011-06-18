package br.com.ecomp.cn.conexao;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.Socket;

import br.com.ecomp.cn.pg.representacaoIndividuo.Operacao;

public class ClientSocket {

	private static ClientSocket instance;
	
	private static DataOutputStream transmissaoServidor;
	private static BufferedReader recepcaoServidor;
	
	private ClientSocket(){
		
	}
	
	public static ClientSocket getInstance(){
		
		if(instance == null){
			try{
				
				instance = new ClientSocket();
				Socket clienteSocket = new Socket("192.168.100.1", 9000);
				
				transmissaoServidor = new DataOutputStream(clienteSocket
						.getOutputStream());
				
				recepcaoServidor = new BufferedReader(
						new InputStreamReader(clienteSocket.getInputStream()));
				
			}catch (Exception e) {
				throw new Error(e.getMessage());
			}
		}
		
		return instance;
	}

	public double calcularDistancia() {
		double retorno = Double.MAX_VALUE;
		try{
			transmissaoServidor.writeBytes("#99#\n");
			while(!recepcaoServidor.ready()){
				String resposta = recepcaoServidor.readLine();
				String[] partes = resposta.split("#");
				retorno = Double.parseDouble(partes[0]);
			}
			
		}catch (Exception e) {
			throw new Error(e.getMessage());
		}
		
		return retorno;
	}
	
	public int executarOperacao(Operacao op){
		
		int retorno = -1;
		try{
			transmissaoServidor.writeBytes("#" + op.getVertebra() + "#" + op.getValor() + '\n');
			while(!recepcaoServidor.ready()){
				String resposta = recepcaoServidor.readLine();
				String[] partes = resposta.split("#");
				retorno = Integer.parseInt(partes[0]);
			}
			
		}catch (Exception e) {
			throw new Error(e.getMessage());
		}
		
		return retorno;
	}
	
}
