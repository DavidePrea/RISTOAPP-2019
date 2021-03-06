<%@page import="ristoapp.bean.RistorantiBean"%>
<%@page import="ristoapp.db.SaveMySQL"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@page import="ristoapp.bean.PrenotazioniBean"%>
 <%@page import="ristoapp.bean.ClientiBean"%>
 <%@page import="java.util.ArrayList"%>
 <%@page import="ristoapp.bean.QueryPiattiPrenotatiBean"%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<%@include file="graphicspuntoacca.jsp"%>
<title>Lista prenotazioni</title>

	<%// Controllo se chi accede a questa pagina ha l'autorizzazione o non si ? loggato
	
	String nomeLoggato = "";
	if(request.getSession() != null && request.getSession().getAttribute("CREDENZIALI") != null){	
		ClientiBean cli = (ClientiBean)request.getSession().getAttribute("CREDENZIALI");
		nomeLoggato = cli.getNome(); //nome del profilo
		
  		if(cli.getLivAutorizzazioni() != 0){// L'utente non ? un cliente
  			response.sendRedirect("login.jsp");
  		}}%>
  		
  	<style type="text/css">
  		td, th{
  			text-align:center !important; 
  		}
  		.container{
  			margin-top: 50px;
  			margin-left: auto;
  			margin-right: auto;
  		}
  	</style>
  	

</head>
<body>
	
	<div class="mdl-layout__header">
				<center>
						<table style="width:100%">
							<tr>
							<td align="left"><a href="profilo.jsp"><img class="indietro" src="MEDIA/indietro.png"/></a></td>
								<td align="center" style="width:100%">
									<h2 style="display: inline;vertical-align:middle">Le tue prenotazioni</h2>
									<img class="logo" src="MEDIA/logo.png"/>
								</td>
							</tr>
						</table>
				</center>
	</div>
	

	<!-- PAGE CONTENT -->
	  	<div style="overflow-x: auto;">
		<table class="mdl-data-table mdl-js-data-table mdl-data-table mdl-shadow--2dp container">
		<thead>
			<tr>
				<th>Data</th>
				<th>Ora</th>
				<th>Persone</th>
				<th>Stato pagamento</th>
				<th>Nome Ristorante</th>
				<th>Tipo prenotazione</th>
			</tr>
		</thead>
		<tbody>
	
		<%
				SaveMySQL db= new SaveMySQL();	
				ClientiBean cli = (ClientiBean)request.getSession().getAttribute("CREDENZIALI");  
				ArrayList<PrenotazioniBean> prenotazioni = db.prelevaPrenotazioniCliente(cli);
				
				for(PrenotazioniBean p:prenotazioni){
					
					//Rivavo il nome del ristorante in modo strano
					ArrayList<RistorantiBean> risto = db.getInfoRistoID(p.getIDFRistorante());
					
					// Scritta per pagato
					String pagatoOut;
					if(p.getStatoPagamento()){
						pagatoOut = "<span style='color:green'>pagato</span>";
					}else{
						pagatoOut = "<span style='color:red'>non pagato</span>";
					}
					
					String catPren = "";
					if(p.getIDFCatPrenotazione() == 1) catPren = "Asporto";
					else if(p.getIDFCatPrenotazione() == 2) catPren = "Consegna a casa";
					else if(p.getIDFCatPrenotazione() == 3) catPren = "Al ristorante";
					%>
						<tr>
						<td><%=p.getData()%></td>
						<td><%=p.getOra()%></td>
						<td><%=p.getNumeroPersone()%></td>
						<td><%=pagatoOut%></td>
						<td><%=risto.get(0).getNome()%></td>
						<td><%=catPren%></td>
						<td>
							
							<a href="dettaglipren.jsp?idpren=<%= p.getIDPrenotazione() %>"><input type="submit" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent" value="Dettagli"/></a>
							
						</td>
						<td>
							<% 
							ArrayList<QueryPiattiPrenotatiBean> dettagli = new ArrayList<QueryPiattiPrenotatiBean>();
							dettagli = db.prelevaDettagliPrenotazioneConPiatti(p.getIDPrenotazione());
							if(dettagli.isEmpty() || p.getStatoPagamento()){
							%>
								<!-- se l'ordine non ha piatti o ha gi? pagato disattivo il pulsante -->
								<input type="submit" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent" disabled="disabled" value="Paga ora"/>
								
							<%}else{ %>
								<!-- se la prenotazione non ? stata pagata permetto al cliente di essere rimandato alla schermata di pagamento -->
								<a href="pagamento.jsp?idpren=<%= p.getIDPrenotazione() %>"><input type="submit" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent" value="Paga ora"/></a>
								
							<%} %>
						</tr>
					<%}%>
		</tbody>
		</table>
		</div>
	
	
</body>
</html>