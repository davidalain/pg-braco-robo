package br.com.ecomp.cn.pg.representacaoIndividuo;

/**
 * @authors David Alain e Leandro Honorato 
 *
 */
public class Operacao {

	private int eixo;
	private int angulo;
	
	public Operacao(int vertebra, int angulo){
		this.eixo = vertebra;
		this.angulo = angulo;
	}
	
	public int getEixo() {
		return eixo;
	}

	public void setEixo(int eixo) {
		this.eixo = eixo;
	}

	public int getAngulo() {
		return angulo;
	}

	public void setAngulo(int valor) {
		this.angulo = valor;
	}

}
