<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><c:out value="${pageTitle}"/> - PharmaPlus</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    .stat-card { transition: all 0.3s; border-radius: 10px; }
    .stat-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
    .stat-icon { font-size: 2.5rem; opacity: 0.8; }
    .quick-action { transition: all 0.2s; }
    .quick-action:hover { transform: scale(1.05); }
    .recent-sale { border-left: 4px solid #0d6efd; }
    .alert-card { border-left-width: 5px !important; }
    .bg-gradient-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
    .bg-gradient-success { background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); }
    .bg-gradient-warning { background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%); }
    .bg-gradient-danger { background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%); }
    .bg-gradient-info { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
    .bg-gradient-purple { background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%); }
  </style>
</head>
<body class="bg-light">

<!-- Navbar -->
<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<div class="container-fluid">
  <div class="row">
    <!-- Sidebar -->
    <div class="col-md-2">
      <jsp:include page="/WEB-INF/includes/sidebar.jsp"/>
    </div>

    <!-- Contenu principal -->
    <div class="col-md-10">
      <jsp:include page="${contentPage}"/>
    </div>
  </div>
</div>

<!-- Footer -->
<jsp:include page="/WEB-INF/includes/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  // Scripts communs à toutes les pages (ex: Chart.js, heure, animations)
</script>
</body>
</html>
