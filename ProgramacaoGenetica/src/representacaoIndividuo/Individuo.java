package representacaoIndividuo;

import java.util.LinkedList;

public class Individuo {
	
	private LinkedList<Operacao> listaOperacoes;

	public Individuo() {
		listaOperacoes = new LinkedList<Operacao>();
	}

	public float avaliarIndividuo () //É o fitness
	{
		
		return 0;
	}
	
	public boolean isIndividuoValido () //Para depois tratar restriçõess
	{
		return true;
	}
	
	public LinkedList<Operacao> getListaOperacoes() {
		return listaOperacoes;
	}

	public void setListaOperacoes(LinkedList<Operacao> listaOperacoes) {
		this.listaOperacoes = listaOperacoes;
	}
	
}
