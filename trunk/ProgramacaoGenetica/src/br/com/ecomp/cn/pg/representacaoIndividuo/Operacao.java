package br.com.ecomp.cn.pg.representacaoIndividuo;

/**
 * @authors David Alain e Leandro Honorato 
 *
 */
public class Operacao {

	private int vertebra;
	private int valor;
	
	public Operacao(int vertebra, int angulo){
		this.vertebra = vertebra;
		this.valor = angulo;
	}
	
	public int getVertebra() {
		return vertebra;
	}

	public void setVertebra(int vertebra) {
		this.vertebra = vertebra;
	}

	public int getValor() {
		return valor;
	}

	public void setValor(int valor) {
		this.valor = valor;
	}

}
