<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (request.getSession(false) != null && request.getSession().getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/home");
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
