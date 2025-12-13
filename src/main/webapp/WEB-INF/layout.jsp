<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><c:out value="${pageTitle}"/> - PharmaPlus</title>
  <link href="${pageContext.request.contextPath}/static/bootstrap-5.0.2-dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/icons/bootstrap-icons-1.13.1/bootstrap-icons.css" rel="stylesheet">
  <!-- Utiliser le CDN -->
  <!--<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.css">-->
  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #0d6efd 0%, #38ef7d 100%);
      --success-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --warning-gradient: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);
      --danger-gradient: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
      --info-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      --sidebar-width: 260px;
      --navbar-height: 70px;
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
    }

    /* Navbar Moderne */
    .modern-navbar {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(10px);
      box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
      border-bottom: 1px solid rgba(255, 255, 255, 0.3);
      height: var(--navbar-height);
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 1000;
    }

    .navbar-brand {
      font-weight: 700;
      font-size: 1.5rem;
      background: var(--primary-gradient);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .navbar-search {
      position: relative;
      max-width: 500px;
    }

    div.mt-2>span.badge{
      color:#0c4128 !important;
      font-weight: bold !important;
    }

    div.text-end>span.badge
    ,div.info-value>span.badge
    ,span.status-badge{
      color:#ffffff !important;
      font-weight: bold !important;
    }

    .navbar-search input {
      border-radius: 50px;
      padding: 0.6rem 1.2rem 0.6rem 3rem;
      border: none;
      background: rgba(102, 126, 234, 0.1);
      transition: all 0.3s;
    }

    .navbar-search input:focus {
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
      background: white;
    }

    .navbar-search i {
      position: absolute;
      left: 1rem;
      top: 50%;
      transform: translateY(-50%);
      color: #667eea;
    }

    .user-menu {
      display: flex;
      align-items: center;
      gap: 1rem;
    }

    .user-avatar {
      border-radius: 50%;
      font-size: 2rem;
      width: 45px;
      height: 45px;
      margin: 10px;
      background: var(--primary-gradient);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: 600;
      cursor: pointer;
      transition: transform 0.3s;
    }

    .user-avatar:hover {
      transform: scale(1.1);
    }

    /* Sidebar Moderne */
    .modern-sidebar {
      position: fixed;
      left: 0;
      top: var(--navbar-height);
      width: var(--sidebar-width);
      height: calc(100vh - var(--navbar-height));
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(10px);
      box-shadow: 4px 0 30px rgba(0, 0, 0, 0.1);
      padding: 2rem 0;
      overflow-y: auto;
      transition: all 0.3s;
    }

    .modern-sidebar::-webkit-scrollbar {
      width: 6px;
    }

    .modern-sidebar::-webkit-scrollbar-track {
      background: transparent;
    }

    .modern-sidebar::-webkit-scrollbar-thumb {
      background: rgba(102, 126, 234, 0.3);
      border-radius: 10px;
    }

    .sidebar-menu {
      list-style: none;
      padding: 0;
    }

    .sidebar-item {
      margin: 0.5rem 1rem;
    }

    .sidebar-link {
      display: flex;
      align-items: center;
      padding: 1rem 1.2rem;
      color: #6c757d;
      text-decoration: none;
      border-radius: 12px;
      transition: all 0.3s;
      position: relative;
      overflow: hidden;
    }

    .sidebar-link::before {
      content: '';
      position: absolute;
      left: 0;
      top: 0;
      height: 100%;
      width: 0;
      background: var(--primary-gradient);
      transition: width 0.3s;
      z-index: -1;
    }

    .sidebar-link:hover::before,
    .sidebar-link.active::before {
      width: 100%;
    }

    .sidebar-link:hover,
    .sidebar-link.active {
      color: white;
      transform: translateX(5px);
    }

    .sidebar-link i {
      font-size: 1.2rem;
      margin-right: 1rem;
      width: 25px;
    }

    /* Contenu Principal */
    .main-content {
      margin-left: var(--sidebar-width);
      margin-top: var(--navbar-height);
      padding: 2rem;
      min-height: calc(100vh - var(--navbar-height));
    }

    /* Cards Modernes */
    .modern-card {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(10px);
      border-radius: 20px;
      border: none;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
      transition: all 0.3s;
      overflow: hidden;
    }

    .modern-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 50px rgba(0, 0, 0, 0.15);
    }

    .stat-card {
      position: relative;
      padding: 2rem;
      border-radius: 20px;
      color: white;
      overflow: hidden;
    }

    .stat-card::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 200%;
      height: 200%;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
      transition: all 0.5s;
    }

    .stat-card:hover::before {
      top: -60%;
      right: -60%;
    }

    .stat-icon {
      font-size: 3rem;
      opacity: 0.9;
    }

    /* Boutons Modernes */
    .btn-modern {
      padding: 0.8rem 2rem;
      border-radius: 50px;
      border: none;
      font-weight: 600;
      transition: all 0.3s;
      position: relative;
      overflow: hidden;
    }

    .btn-modern::before {
      content: '';
      position: absolute;
      top: 50%;
      left: 50%;
      width: 0;
      height: 0;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.3);
      transform: translate(-50%, -50%);
      transition: width 0.6s, height 0.6s;
    }

    .btn-modern:hover::before {
      width: 300px;
      height: 300px;
    }

    .btn-gradient-primary {
      background: var(--primary-gradient);
      color: white;
    }

    .btn-gradient-success {
      background: var(--success-gradient);
      color: white;
    }

    .btn-gradient-danger {
      background: var(--danger-gradient);
      color: white;
    }

    /* Tables Modernes */
    .modern-table {
      background: white;
      border-radius: 15px;
      overflow: hidden;
    }

    .modern-table thead {
      background: var(--primary-gradient);
      color: white;
    }

    .modern-table th {
      font-weight: 600;
      padding: 1.2rem;
      border: none;
    }

    .modern-table td {
      padding: 1rem 1.2rem;
      border-bottom: 1px solid rgba(0, 0, 0, 0.05);
      vertical-align: middle;
    }

    .modern-table tbody tr {
      transition: all 0.3s;
    }

    .modern-table tbody tr:hover {
      background: rgba(102, 126, 234, 0.05);
      transform: scale(1.01);
    }

    /* Badges Modernes */
    .badge-modern {
      padding: 0.5rem 1rem;
      border-radius: 50px;
      font-weight: 600;
      font-size: 0.85rem;
    }

    /* Animations */
    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .fade-in-up {
      animation: fadeInUp 0.6s ease-out;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .modern-sidebar {
        transform: translateX(-100%);
      }

      .main-content {
        margin-left: 0;
      }

      .sidebar-toggle {
        display: block !important;
      }
    }

    /* Footer */
    .modern-footer {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(10px);
      padding: 2rem 0;
      margin-left: var(--sidebar-width);
      margin-top: 3rem;
      border-top: 1px solid rgba(0, 0, 0, 0.1);
    }

    /* Formulaires Modernes */
    .modern-input {
      border-radius: 12px;
      padding: 0.8rem 1.2rem;
      border: 2px solid rgba(102, 126, 234, 0.2);
      transition: all 0.3s;
    }

    .modern-input:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    }

    .form-label {
      font-weight: 600;
      color: #495057;
      margin-bottom: 0.5rem;
    }
  </style>
</head>
<body>

<!-- Navbar -->
<nav class="modern-navbar">
  <div class="container-fluid px-4">
    <div class="d-flex align-items-center justify-content-between w-100">
      <div class="d-flex align-items-center gap-3">
        <button class="btn btn-link sidebar-toggle d-none" onclick="toggleSidebar()">
          <i class="bi bi-list fs-3"></i>
        </button>
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
          <i class="bi bi-capsule-pill"></i> PharmaPlus
        </a>
      </div>

      <!--<div class="navbar-search flex-grow-1 mx-5">
        <i class="bi bi-search"></i>
        <input type="text" class="form-control" placeholder="Rechercher un produit, client...">
      </div>-->

      <div class="user-menu">
       <!-- <button class="btn btn-link position-relative">
          <i class="bi bi-bell fs-4 text-muted"></i>
          <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">3</span>
        </button>-->
        <div class="dropdown">
          <div class="user-avatar" data-bs-toggle="dropdown">
            <c:choose>
              <c:when test="${not empty sessionScope.fullName}">
                ${sessionScope.fullName.substring(0,1)}
              </c:when>
              <c:otherwise>U</c:otherwise>
            </c:choose>
          </div>
          <ul class="dropdown-menu dropdown-menu-end">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
              <i class="bi bi-person me-2"></i>Profil
            </a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/change-password">
              <i class="bi bi-key me-2"></i>Changer mot de passe
            </a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
              <i class="bi bi-box-arrow-right me-2"></i>Déconnexion
            </a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</nav>

<!-- Sidebar -->
<aside class="modern-sidebar">
  <ul class="sidebar-menu">
    <li class="sidebar-item">
      <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-link ${pageActive eq 'dashboard' ? 'active' : ''}">
        <i class="bi bi-speedometer2"></i>
        <span>Dashboard</span>
      </a>
    </li>
    <c:if test="${sessionScope.role eq 'ADMIN' or sessionScope.role eq 'PHARMACIST'}">
      <li class="sidebar-item">
        <a href="${pageContext.request.contextPath}/products" class="sidebar-link ${pageActive eq 'products' ? 'active' : ''}">
          <i class="bi bi-box-seam"></i>
          <span>Produits</span>
        </a>
      </li>
    </c:if>

    <!-- Inventaire (Admin et Pharmacien seulement) -->
    <c:if test="${sessionScope.role eq 'ADMIN' or sessionScope.role eq 'PHARMACIST'}">
      <li class="sidebar-item">
        <a href="${pageContext.request.contextPath}/inventory" class="sidebar-link ${pageActive eq 'inventory' ? 'active' : ''}">
          <i class="bi bi-boxes"></i>
          <span>Inventaire</span>
        </a>
      </li>
    </c:if>

    <li class="sidebar-item">
      <a href="${pageContext.request.contextPath}/customers" class="sidebar-link ${pageActive eq 'customers' ? 'active' : ''}">
        <i class="bi bi-people"></i>
        <span>Clients</span>
      </a>
    </li>
    <c:if test="${sessionScope.role eq 'ADMIN' or sessionScope.role eq 'PHARMACIST'}">
      <li class="sidebar-item">
        <a href="${pageContext.request.contextPath}/suppliers" class="sidebar-link ${pageActive eq 'suppliers' ? 'active' : ''}">
          <i class="bi bi-truck"></i>
          <span>Fournisseurs</span>
        </a>
      </li>
    </c:if>

    <li class="sidebar-item">
      <a class="sidebar-link ${pageActive eq 'sales' ? 'active' : ''}" href="${pageContext.request.contextPath}/sales">
        <i class="bi bi-cart"></i>Ventes
      </a>
    </li>

    <!-- Module Centre de Santé -->
    <li class="sidebar-item">
      <a class="sidebar-link ${pageActive eq 'medical' ? 'active' : ''}" href="${pageContext.request.contextPath}/medical-receipts">
        <i class="bi bi-file-medical"></i>Reçus Médicaux
      </a>
    </li>
    <!--
    <li class="sidebar-item">
      <a class="sidebar-link ${pageActive eq 'service_medical' ? 'active' : ''}" href="${pageContext.request.contextPath}/medical-receipts/services/manage">
        <i class="bi bi-tags"></i>
        <span>Services Médicaux</span>
      </a>
    </li>-->

    <c:if test="${sessionScope.role eq 'ADMIN'}">
      <li class="sidebar-item">
        <a href="${pageContext.request.contextPath}/users"
           class="sidebar-link ${pageActive eq 'users' ? 'active' : ''}">
          <i class="bi bi-people"></i>
          <span>Gestion Utilisateurs</span>
        </a>
      </li>
    </c:if>
   <!-- <li class="sidebar-item">
      <a href="${pageContext.request.contextPath}/reports" class="sidebar-link">
        <i class="bi bi-graph-up"></i>
        <span>Rapports</span>
      </a>
    </li>-->
   <!-- <li class="sidebar-item mt-4">
      <a href="${pageContext.request.contextPath}/settings" class="sidebar-link">
        <i class="bi bi-gear"></i>
        <span>Paramètres</span>
      </a>
    </li>-->
  </ul>
</aside>

<!-- Contenu Principal -->
<main class="main-content">
  <jsp:include page="${contentPage}"/>
</main>

<!-- Footer -->
<footer class="modern-footer text-center">
  <div class="container">
    <p class="mb-0 text-muted">© 2025 oneMaster - Gestion Pharmaceutique Moderne</p>
  </div>
</footer>
<script src="${pageContext.request.contextPath}/static/bootstrap-5.0.2-dist/js/bootstrap.bundle.min.js" defer></script>
<script>
  function toggleSidebar() {
    document.querySelector('.modern-sidebar').classList.toggle('show');
  }

  // Animation au chargement
  document.addEventListener('DOMContentLoaded', function() {
    const cards = document.querySelectorAll('.modern-card, .stat-card');
    cards.forEach((card, index) => {
      setTimeout(() => {
        card.classList.add('fade-in-up');
      }, index * 100);
    });
  });
</script>
</body>
</html>