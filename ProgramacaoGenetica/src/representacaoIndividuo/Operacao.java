package representacaoIndividuo;

public class Operacao {

	enum Movimento
	{
		mover_junta1,
		mover_junta2,
		mover_junta3
	}
	
	private Movimento op;
	private int valor;
	
	public Operacao(Movimento op, int valor) {
		this.op = op;
		this.valor = valor;
	}

	public Movimento getOp() {
		return op;
	}

	public void setOp(Movimento op) {
		this.op = op;
	}

	public int getValor() {
		return valor;
	}

	public void setValor(int valor) {
		this.valor = valor;
	}

}
