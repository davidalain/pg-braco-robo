package br.com.ecomp.cn.conexao;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.Socket;
import java.util.LinkedList;

import br.com.ecomp.cn.pg.AlgoritmoPG;
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
				Socket clienteSocket = new Socket(AlgoritmoPG.IP_SERVIDOR, AlgoritmoPG.PORTA_SERVIDOR);
				
				transmissaoServidor = new DataOutputStream(clienteSocket
						.getOutputStream());
				
				recepcaoServidor = new BufferedReader(
						new InputStreamReader(clienteSocket.getInputStream()));
				
				System.out.println("Conectou a "+AlgoritmoPG.IP_SERVIDOR+":"+AlgoritmoPG.PORTA_SERVIDOR);
			}catch (Exception e) {
				throw new Error(e.getMessage());
			}
		}
		
		return instance;
	}

	public double calcularDistancia() {
		double dist = 1000.2;
		try{
			System.out.println("A");
			transmissaoServidor.writeBytes("#dist;");
			transmissaoServidor.flush();
			System.out.println("B");
			
			
			
			while(!recepcaoServidor.ready()){
				
			}
			
			//if(recepcaoServidor.ready()){
				System.out.println("C");
				String resposta = recepcaoServidor.readLine();
				int indiceFinal = (resposta.length() - 2) > 3 ? (resposta.length() - 2) : 3;
				System.out.println("reposta: "+resposta);
				resposta = resposta.substring(2, indiceFinal);
				dist = Double.parseDouble(resposta);
			//}
			
		}catch (Exception e) {
			throw new Error(e.getMessage());
		}
		return dist;
	}
	
	public int executarOperacao(Operacao op){
		int retorno = 1;
		try{
			
			transmissaoServidor.writeBytes(";"+op.getEixo() + ";" + op.getAngulo());
			transmissaoServidor.flush();
			
			
			while(!recepcaoServidor.ready()){
				
			}
			//if(recepcaoServidor.ready()){
				String resposta = recepcaoServidor.readLine();
				retorno = Integer.parseInt(""+resposta.charAt(2));
			//}
			
		}catch (Exception e) {
			throw new Error(e.getMessage());
		}
		
		return retorno;
	}
	
	public int executarOperacoes(LinkedList<Operacao> operacoes){
		int retorno = 1;
		try{
			
			String comando = "";
			for(Operacao op : operacoes){
				comando += "#"+op.getEixo() + ";" + op.getAngulo();
			}
			
			transmissaoServidor.writeBytes(comando);
			transmissaoServidor.flush();
			
			while(!recepcaoServidor.ready()){
				
			}
			
			String resposta = recepcaoServidor.readLine();
			retorno = Integer.parseInt(""+resposta.charAt(2));
			
		}catch (Exception e) {
			throw new Error(e.getMessage());
		}
		
		return retorno;
	}
	
}
