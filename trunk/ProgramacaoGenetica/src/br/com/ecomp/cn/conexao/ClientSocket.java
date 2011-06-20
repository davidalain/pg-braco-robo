package br.com.ecomp.cn.conexao;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.Socket;

import br.com.ecomp.cn.pg.BracoRoboPG;
import br.com.ecomp.cn.pg.representacaoIndividuo.Operacao;


/**
 * @authors David Alain 
 *
 */
public class ClientSocket {

	private static ClientSocket instance;
	
	private static DataOutputStream transmissaoServidor;
	private static BufferedReader recepcaoServidor;
	
	private ClientSocket(){}
	
	public static ClientSocket getInstance(){
		if(instance == null){
			try{
				
				instance = new ClientSocket();
				Socket clienteSocket = new Socket(BracoRoboPG.IP_SERVIDOR, BracoRoboPG.PORTA_SERVIDOR);
				
				transmissaoServidor = new DataOutputStream(clienteSocket
						.getOutputStream());
				
				recepcaoServidor = new BufferedReader(
						new InputStreamReader(clienteSocket.getInputStream()));
				
				System.out.println("Conectou a "+BracoRoboPG.IP_SERVIDOR+":"+BracoRoboPG.PORTA_SERVIDOR);
			}catch (Exception e) {
				throw new Error(e.getMessage());
			}
		}
		
		return instance;
	}

	public double calcularDistancia() {
		System.out.print("calculaDistancia");
		double dist = Double.MAX_VALUE;
		try{
			
			transmissaoServidor.writeBytes("dist;");
			if(!recepcaoServidor.ready()){
				String resposta = recepcaoServidor.readLine();
				dist = Double.parseDouble(resposta);
			}
			
		}catch (Exception e) {
			throw new Error(e.getMessage());
		}
		System.out.println(" "+dist);
		return dist;
	}
	
	public int executarOperacao(Operacao op){
		System.out.println("executarOperacao");
		int retorno = -1;
		try{
			
			transmissaoServidor.writeBytes(op.getVertebra() + ";" + op.getValor());
			while(!recepcaoServidor.ready()){
				String resposta = recepcaoServidor.readLine();
				retorno = Integer.parseInt(resposta);
			}
			
		}catch (Exception e) {
			throw new Error(e.getMessage());
		}
		
		return retorno;
	}
	
}
