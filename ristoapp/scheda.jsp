<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ristoapp.bean.ClientiBean"%>
<%@page import="ristoapp.bean.RistorantiBean"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Dettagli</title>
	<%@include file="graphicspuntoacca.jsp"%>
		<% 
		// Controllo se chi accede a questa pagina ha l'autorizzazione
		String nomeLoggato = "";
		if(request.getSession() != null && request.getSession().getAttribute("CREDENZIALI") != null){	
			ClientiBean cli = (ClientiBean)request.getSession().getAttribute("CREDENZIALI");
			
			nomeLoggato = cli.getNome();
	  		if(cli.getLivAutorizzazioni() != 0){
	  			// L'utente non ? un cliente
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
				<td align="left"><a href="bacheca.jsp"><img class="indietro" src="MEDIA/indietro.png"/></a></td>
				<td align="center" style="width:100%">
					<h2 style="display: inline;vertical-align:middle">Dettaglio Ristorante </h2>
					<img class="logo" style="vertical-align:middle" src="MEDIA/logo.png"/>
				</td>
			</tr>
		</table>
	</div>
	
	<% if(request.getSession() != null && request.getSession().getAttribute("DETRISTO") != null){
	
		ArrayList<RistorantiBean> dettRist = (ArrayList<RistorantiBean>) request.getSession().getAttribute("DETRISTO");
	%>
	<div >
	
		<h3>Dettaglio di  &#10077; <%=dettRist.get(0).getNome()%> &#10078;</h3>
		
		<div style="overflow-x: auto;">
		<table class="mdl-data-table mdl-js-data-table mdl-data-table mdl-shadow--2dp">
		<thead>
			<tr>
				<th>Foto</th>
				<th>Nome</th>
				<th>Categoria</th>
				<th>Indirizzo</th>
				<th>Telefono</th>
				<th>Posta elettronica</th>
				<th>Comune</th>
				<th>&#127777;</th>
				<th>&#128021;</th>
				<th>&#127760;</th>
				<th>&#9855;</th>
				<th>&#127359;&#65039;</th>
				<th>Numero Posti</th>
				<th>Descrizione</th>
			</tr>
		</thead>
		<tbody>
		
		<% 
		
		RistorantiBean ris = new RistorantiBean();
		
		
		for(RistorantiBean p:dettRist){
			
			int id = p.getIDRistorante();
			ris.setIDRistorante(id);
			int cat = p.getIDFCatCucina();
			boolean tavolo = p.getSerScegliTavolo();
			boolean wifi = p.getSerWifi();
			boolean animali = p.getSerAnimali();
			boolean clima = p.getSerClimatizzazione();
			boolean dis = p.getSerDisabili();
			boolean park = p.getSerParcheggio();
			String tel = p.getTelefono();
			String url = p.getUrl();
			
			
			
		%>
		
			<tr>
				<td><img style="float:left" height="70px" width="100px" src=<%=url%>/></td>
				<td><%=p.getNome()%></td>
				<% if(cat == 1){%>
					<td>All you can eat</td>
				<%}else if(cat == 2){ %>
					<td>Pizzeria</td>
				<%}else if(cat == 3){ %> 
					<td>Ristorante</td>
				<%}else if(cat == 4){ %> 
					<td>Cucina locale</td>
				<%}else if(cat == 5){ %> 
					<td>Fast Food</td>
				<%} %>
				
				<td><%=p.getIndirizzo()%></td>
				<td><%=tel%></td>
				<td><%=p.getEmail()%></td>
				<td><%=p.getComune()%></td>
			
				<% if(clima == true){%>
					<td>&#10004;</td>
				<%}else if(clima == false){ %>
					<td>&#10008;</td>
				<%} %>
				<% if(animali == true){%>
					<td>&#10004;</td>
				<%}else if(animali == false){ %>
					<td>&#10008;</td>
				<%} %>
				<% if(wifi == true){%>
					<td>&#10004;</td>
				<%}else if(wifi == false){ %>
					<td>&#10008;</td>
				<%} %>
				<% if(dis == true){%>
					<td>&#10004;</td>
				<%}else if(dis == false){ %>
					<td>&#10008;</td>
				<%} %>
				<% if(park == true){%>
					<td>&#10004;</td>
				<%}else if(park == false){ %>
					<td>&#10008;</td>
				<%} %>
				<td><%=p.getNumeroPosti()%></td>
				<td><%=p.getDescrizione()%></td>
				
				
			</tr>
			

		
		</tbody>
		<thead>
			<tr>
			
			</tr>
			<%
			
		}%>
		</thead>

		</table>
		<center>
			<br><br>
					<form action="nuovaprenotazioneservlet" name="scheda" method="post">
						<input type="hidden" name="idristorante" value="<%=ris.getIDRistorante()%>"></input>
						<input type="hidden" name="whatsend" value="prenota"></input>
						<input type="submit" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent" value="prenota"/>
					</form>
					<br><br>
				</center>
		</div>
	</div>
	
	<% }else{%>
		Abbiamo riscontrato un problema, perfavore riprova pi? tardi...
	<%}%>

</body>
</html>