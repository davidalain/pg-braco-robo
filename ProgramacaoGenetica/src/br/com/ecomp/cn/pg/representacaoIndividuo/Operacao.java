package br.com.ecomp.cn.pg.representacaoIndividuo;

public class Operacao {

	enum Movimento
	{
		mover_junta1,
		mover_junta2,
		mover_junta3
	}
	
	private Movimento op;
	private int vertebra;
	private int valor;
	
	public Operacao(Movimento op, int valor) {
		this.op = op;
		this.valor = valor;
	}
	
	public Operacao(int vertebra, int angulo){
		this.vertebra = vertebra;
		this.valor = angulo;
	}

	public Movimento getOp() {
		return op;
	}

	public void setOp(Movimento op) {
		this.op = op;
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
