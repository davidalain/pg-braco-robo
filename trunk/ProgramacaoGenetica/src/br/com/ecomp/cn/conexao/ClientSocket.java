package br.com.ecomp.cn.conexao;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.Socket;
import java.util.LinkedList;

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
		double dist = Double.MAX_VALUE;
		try{
			
			transmissaoServidor.writeBytes(";dist;");
			transmissaoServidor.flush();
			
			if(!recepcaoServidor.ready()){
				String resposta = recepcaoServidor.readLine();
				dist = Double.parseDouble(resposta);
//				System.out.println("distancia: "+dist);
			}
			
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
			
			//System.out.println(";"+op.getVertebra() + ";" + op.getValor());
			if(!recepcaoServidor.ready()){
				String resposta = recepcaoServidor.readLine();
				retorno = Integer.parseInt(""+resposta.charAt(2));
			}
			
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
			
			if(!recepcaoServidor.ready()){
				String resposta = recepcaoServidor.readLine();
				retorno = Integer.parseInt(""+resposta.charAt(2));
			}
			
		}catch (Exception e) {
			throw new Error(e.getMessage());
		}
		
		return retorno;
	}
	
}
