package ristoapp.bean;

public class PrenotazioniDettagliBean implements java.io.Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8905967347413230537L;

	private int IDPrenotazioneDett;
	private int IDFOrdine;
	private int IDFPiatto;
	private double Prezzo;
	private int Sconto;
	private int Quantit�;
	
	
	//Getter e Setter
	public int getIDPrenotazioneDett() {
		return IDPrenotazioneDett;
	}
	public void setIDPrenotazioneDett(int iDPrenotazioneDett) {
		IDPrenotazioneDett = iDPrenotazioneDett;
	}
	public int getIDFOrdine() {
		return IDFOrdine;
	}
	public void setIDFOrdine(int iDFOrdine) {
		IDFOrdine = iDFOrdine;
	}
	public int getIDFPiatto() {
		return IDFPiatto;
	}
	public void setIDFPiatto(int iDFPiatto) {
		IDFPiatto = iDFPiatto;
	}
	public double getPrezzo() {
		return Prezzo;
	}
	public void setPrezzo(double prezzo) {
		Prezzo = prezzo;
	}
	public int getSconto() {
		return Sconto;
	}
	public void setSconto(int sconto) {
		Sconto = sconto;
	}
	public int getQuantit�() {
		return Quantit�;
	}
	public void setQuantit�(int quantit�) {
		Quantit� = quantit�;
	}
	
	
}
