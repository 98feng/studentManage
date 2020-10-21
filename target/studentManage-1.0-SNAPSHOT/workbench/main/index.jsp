<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
		<meta charset="UTF-8">
		<link rel="stylesheet" href="http://hovertree.com/texiao/css3/1/css/style.css" media="screen" type="text/css" />
	</head>
<body>

<h1 class='outlinedA'>${user.name}同学欢迎你！</h1>
<img src="image/home.png"/>

</body>
</html>