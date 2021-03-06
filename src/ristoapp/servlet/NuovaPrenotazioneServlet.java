package ristoapp.servlet;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import ristoapp.bean.ClientiBean;
import ristoapp.bean.PiattiBean;
import ristoapp.bean.PrenotazioniBean;
import ristoapp.bean.PrenotazioniDettagliBean;
import ristoapp.bean.RistorantiBean;
import ristoapp.db.SaveMySQL;

@WebServlet("/nuovaprenotazioneservlet")
public class NuovaPrenotazioneServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    public NuovaPrenotazioneServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("You got caught by the POST police, you are not allowed to use a GET");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String whatsend = request.getParameter("whatsend");
		
		
		//Ricevo l'id del ristorante
		if(whatsend.equalsIgnoreCase("prenota")) {
			String idristo = request.getParameter("idristorante");
			
			request.getSession().removeAttribute("IDRISTO");
			request.getSession().setAttribute("IDRISTO", idristo);
			
			response.sendRedirect("nuovaprenotazione.jsp");
		}
		
		//Creo la prenotazione del cliente
		if(whatsend.equalsIgnoreCase("creaprenotazione")) {
			String data = request.getParameter("data");
			String ora = request.getParameter("ora");
			String posti = request.getParameter("posti");
			int categoria = Integer.parseInt(request.getParameter("categoria"));
			
			ClientiBean cliente= (ClientiBean) request.getSession().getAttribute("CREDENZIALI"); //Ricavo l'idutente
			PrenotazioniBean prenotazione= new PrenotazioniBean();
			prenotazione.setIDFCliente(cliente.getIDCliente());
			prenotazione.setData(data);
			prenotazione.setOra(ora);
			prenotazione.setNumeroPersone(posti);
			prenotazione.setIDFCatPrenotazione(categoria);
			prenotazione.setStatoPagamento(false);
			int ID = Integer.parseInt(request.getSession().getAttribute("IDRISTO").toString()); //Ricavo l'idristorante
			prenotazione.setIDFRistorante(ID);
			int IDPren = 0;
			int postilib = 0;
			SaveMySQL db = new SaveMySQL();
			
			if(prenotazione.getIDFCatPrenotazione()==3) {
			try {
				RistorantiBean risto = db.getInfoRistoranteDaID(ID);
				
				ArrayList<PrenotazioniBean> prenotazioni = db.prelevaPrenotazioniRistoranteTraDueOre(risto, prenotazione);
				postilib = risto.getNumeroPosti();
				
				for (int i = 0; i < prenotazioni.size(); i++) {
					postilib = postilib - Integer.parseInt(prenotazioni.get(i).getNumeroPersone());
				}
				
			} catch (Exception e1) {
				e1.printStackTrace();
				ServletContext sc = request.getSession().getServletContext();
				RequestDispatcher rd = sc.getRequestDispatcher("/erroregenerico.jsp");
				rd.forward(request, response);
			}
			}
				
			if(prenotazione.getNumeroPersone()==null) {
				prenotazione.setNumeroPersone("0");
			}
			
			if( prenotazione.getIDFCatPrenotazione()!=3  || postilib >= Integer.parseInt(prenotazione.getNumeroPersone())) {
			try {
				//Se ? possibile prenotare
				IDPren=db.nuovaPrenotazione(prenotazione);
			} 
			catch (Exception e) {
				System.out.println("Errore in scrittura sul databass");
				e.printStackTrace();
				ServletContext sc = request.getSession().getServletContext();
				RequestDispatcher rd = sc.getRequestDispatcher("/erroregenerico.jsp");
				rd.forward(request, response);
			}
			
			request.getSession().removeAttribute("IDPREN");
			request.getSession().setAttribute("IDPREN", IDPren);
			request.getSession().removeAttribute("TipoPren");
			request.getSession().setAttribute("TipoPren", categoria);
			
			response.sendRedirect("inseriscidettaglipren.jsp");
			
			}else{
				//Se il ristorante ? pieno
				ServletContext sc = request.getSession().getServletContext();
				RequestDispatcher rd = sc.getRequestDispatcher("/ristorantepieno.jsp");
				rd.forward(request, response);
			}
		}
		
		//Qui inserisco i dettagli della prenotazione, cio? i piatti che vengo ordinati in inseriscidettaglipren.jsp
		if(whatsend.equalsIgnoreCase("dettaglipren")) {
			ArrayList<PiattiBean> rs;
			ArrayList<PrenotazioniDettagliBean> piatti = new ArrayList<PrenotazioniDettagliBean>();
			SaveMySQL db= new SaveMySQL();
			int risto= Integer.parseInt(request.getSession().getAttribute("IDRISTO").toString());
			try {
				rs=  db.prelevaPiattRistorante(risto);
				for(int i=0; i<rs.size(); i++){
					
					if(rs.get(i).getDisponibile()==true){
						//cerco i risultati e li invio al databass
						int piattoid = rs.get(i).getIDPiatto();
						if(request.getParameter(Integer.toString(piattoid)) != "") {
							PrenotazioniDettagliBean piatto= new PrenotazioniDettagliBean();
							piatto.setIDFOrdine(Integer.parseInt(request.getSession().getAttribute("IDPREN").toString()));
							piatto.setIDFPiatto(piattoid);
							piatto.setPrezzo(db.prezzopiatto(piattoid));
							piatto.setQuantita(Integer.parseInt(request.getParameter(Integer.toString(piattoid))));
							piatto.setSconto(0);//TODO:modificare per ottenere sconti
							piatti.add(piatto);
						}
					}
				}
				db.inserisciDettagli(piatti);
				ServletContext sc = request.getSession().getServletContext();
				RequestDispatcher rd = sc.getRequestDispatcher("/prenotazionecompletataconpiatti.jsp");
				rd.forward(request, response);
			} catch (Exception e) {
				e.printStackTrace();
				ServletContext sc = request.getSession().getServletContext();
				RequestDispatcher rd = sc.getRequestDispatcher("/erroregenerico.jsp");
				rd.forward(request, response);
			}			
		}
		
		
		//Nel caso in cui il cliente prenota al ristorante e non vuole ordinare online non aggiungo nessun dettaglio alla prenotazione
		if(whatsend.equalsIgnoreCase("nodettagli")) {
			ServletContext sc = request.getSession().getServletContext();
			RequestDispatcher rd = sc.getRequestDispatcher("/prenotazionecompletata.jsp");
			rd.forward(request, response);
			
		}	
		
		
		//Quando un utente vuole cancellare una prenotazione
		if(whatsend.equalsIgnoreCase("elimina")) {
			
			SaveMySQL db= new SaveMySQL();
			
			try {
				db.eliminaPrenotazione(Integer.parseInt(request.getParameter("idpren")));
			} catch (NumberFormatException e) {
				
				e.printStackTrace();
				ServletContext sc = request.getSession().getServletContext();
				RequestDispatcher rd = sc.getRequestDispatcher("/erroregenerico.jsp");
				rd.forward(request, response);
			} catch (Exception e) {
				
				e.printStackTrace();
				ServletContext sc = request.getSession().getServletContext();
				RequestDispatcher rd = sc.getRequestDispatcher("/erroregenerico.jsp");
				rd.forward(request, response);
			}
			
			ServletContext sc = request.getSession().getServletContext();
			RequestDispatcher rd = sc.getRequestDispatcher("/listaprenotazioni.jsp");
			rd.forward(request, response);
			
		}	
			
	}
}
