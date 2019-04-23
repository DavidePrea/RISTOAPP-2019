<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ristoapp.bean.ClientiBean"%>
<%@page import="ristoapp.bean.QueryPiattiPrenotatiBean"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Dettagli prenotazione</title>
	<%@include file="graphicspuntoacca.jsp"%>
		<% 
		// Controllo se chi accede a questa pagina ha l'autorizzazione
		String nomeLoggato = "";
		if(request.getSession() != null && request.getSession().getAttribute("CREDENZIALI") != null){	
			ClientiBean cli = (ClientiBean)request.getSession().getAttribute("CREDENZIALI");
			nomeLoggato = cli.getNome();
	  		if(cli.getLivAutorizzazioni() != 1){
	  			// L'utente non � un ristoratore
	  			response.sendRedirect("login.jsp");
	  		}%>
		<%}
		else{
			// L'utente non  loggato
			response.sendRedirect("login.jsp");
		}%>
</head>
<body class="text-center">

	<div class="mdl-layout__header">		
		<table style="width:100%">
			<tr>
				<td align="left"><a href="ilmioristorante.jsp"><img class="indietro" src="MEDIA/indietro.png"/></a></td>
				<td align="center" style="width:100%">
					<h2 style="display: inline;vertical-align:middle">Dettagli prenotazine</h2>
					<img class="logo" style="vertical-align:middle" src="MEDIA/logo.png"/>
				</td>
			</tr>
		</table>
	</div>
		
	<% if(request.getSession() != null && request.getSession().getAttribute("DETTAGLIPRENOTAZIONECONPIATTO") != null){
	
		ArrayList<QueryPiattiPrenotatiBean> piattiPrenotati = (ArrayList<QueryPiattiPrenotatiBean>)request.getSession().getAttribute("DETTAGLIPRENOTAZIONECONPIATTO");
	%>
	
	<div class="page centratabella">
	
		<h3>Dettagli prenotazione n� <%= piattiPrenotati.get(0).getIDFOrdine() %></h3>
		
		<div style="overflow-x: auto;">
		<table class="mdl-data-table mdl-js-data-table mdl-data-table mdl-shadow--2dp">
		<thead>
			<tr>
				<th>Foto</th>
				<th>Nome</th>
				<th>Quantit�</th>
				<th>Prezzo base</th>
				<th>Sconto</th>
				<th>Prezzo finale</th>
			</tr>
		</thead>
		<tbody>
		
		<% 
		float prezzoFinale, totale = 0;
		for(QueryPiattiPrenotatiBean p:piattiPrenotati){
			prezzoFinale = p.getPrezzo()*p.getQuantita()*((100-p.getSconto())/100);
			totale += prezzoFinale;
		%>
			<tr>
				<td><img style="float:left" height='70px' src='<%=p.getUrl()%>'/></td>
				<td><%=p.getNome()%></td>
				<td><%=p.getQuantita()%></td>
				<td><%=p.getPrezzo()%></td>
				<td><%=p.getSconto()%></td>
				<td><b><%=prezzoFinale%></b></td>
			</tr>
		<%}%>
		</tbody>
		<thead>
			<tr>
				<th></th>
				<th></th>
				<th></th>
				<th></th>
				<th></th>
				<th>Totale</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><b style='color:green'><%=totale%></b></td>
			</tr>
		</tbody>
		</table>
		</div>
	</div>
	
	<% }else{%>
		Abbiamo riscontrato un problema, perfavore riprova pi� tardi...
	<%}%>

</body>
</html>