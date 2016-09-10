<%-- 
    Document   : logout
    Created on : 10-sep-2016, 3:04:49
    Author     : codix
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page: Logout</title>
    </head>
    <body>
        <%@ page session="true"%>

        User '<%=request.getRemoteUser()%>' has been logged out.
        <% session.invalidate(); %>

       <br/><br/>
       <p>Volver <a href="index.jsp" >aquí!</a></p> 
    </body>
</html>
