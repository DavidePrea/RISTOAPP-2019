<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form action = "/ristoapp.servlet/RistoAppServlet" name = "login" method ="POST">
	E-mail<input type = "text" name = "email"/><br>
	Password<input type = "text" name = "password"/><br>
	<input type = "submit"/>
</form>
</body>
</html>