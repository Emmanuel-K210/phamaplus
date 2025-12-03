<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>PharmaPlus - Gestion de Pharmacie</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        .dashboard-card { transition: transform 0.2s; }
        .dashboard-card:hover { transform: translateY(-5px); }
        .stat-icon { font-size: 2.5rem; opacity: 0.8; }
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-shop"></i> PharmaPlus
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link text-white" href="${pageContext.request.contextPath}/products">
                    <i class="bi bi-box-arrow-in-right"></i> Se Connecter
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section p-5 mb-5">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h1 class="display-4 fw-bold">
                    <i class="bi bi-capsule-pill"></i> PharmaPlus
                </h1>
                <p class="lead">Système de gestion de pharmacie complet</p>
                <p>Gérez votre inventaire, vos ventes, vos clients et vos prescriptions médicales en un seul endroit.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-light btn-lg">
                    <i class="bi bi-play-circle"></i> Commencer
                </a>
            </div>
            <div class="col-md-4 text-center">
                <i class="bi bi-heart-pulse" style="font-size: 8rem; opacity: 0.7;"></i>
            </div>
        </div>
    </div>

    <!-- Dashboard Cards -->
    <div class="row g-4 mb-5">
        <div class="col-md-3">
            <div class="card dashboard-card border-primary">
                <div class="card-body text-center">
                    <div class="stat-icon text-primary mb-3">
                        <i class="bi bi-capsule"></i>
                    </div>
                    <h5 class="card-title">Produits</h5>
                    <p class="card-text">Gestion du catalogue de médicaments</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
                        <i class="bi bi-arrow-right"></i> Accéder
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card dashboard-card border-success">
                <div class="card-body text-center">
                    <div class="stat-icon text-success mb-3">
                        <i class="bi bi-box-seam"></i>
                    </div>
                    <h5 class="card-title">Inventaire</h5>
                    <p class="card-text">Gestion des stocks et lots</p>
                    <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-success">
                        <i class="bi bi-arrow-right"></i> Accéder
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card dashboard-card border-warning">
                <div class="card-body text-center">
                    <div class="stat-icon text-warning mb-3">
                        <i class="bi bi-cart"></i>
                    </div>
                    <h5 class="card-title">Ventes</h5>
                    <p class="card-text">Encaissement et facturation</p>
                    <a href="#" class="btn btn-outline-warning">
                        <i class="bi bi-arrow-right"></i> Accéder
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card dashboard-card border-info">
                <div class="card-body text-center">
                    <div class="stat-icon text-info mb-3">
                        <i class="bi bi-people"></i>
                    </div>
                    <h5 class="card-title">Clients</h5>
                    <p class="card-text">Gestion de la clientèle</p>
                    <a href="#" class="btn btn-outline-info">
                        <i class="bi bi-arrow-right"></i> Accéder
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Features -->
    <div class="row mb-5">
        <div class="col-md-12">
            <h3 class="mb-4">
                <i class="bi bi-stars"></i> Fonctionnalités Principales
            </h3>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="bi bi-shield-check text-primary"></i> Gestion des Ordonnances
                            </h5>
                            <p class="card-text">Suivez les prescriptions médicales, gérez les renouvellements et validez les ordonnances.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="bi bi-bell text-warning"></i> Alertes Automatiques
                            </h5>
                            <p class="card-text">Recevez des alertes pour les stocks bas, les produits expirés et les réapprovisionnements.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="bi bi-graph-up text-success"></i> Rapports Détaillés
                            </h5>
                            <p class="card-text">Générez des rapports de ventes, de profits et d'analyse des stocks.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-5 py-4 border-top">
        <div class="row">
            <div class="col-md-6">
                <h5><i class="bi bi-shop"></i> PharmaPlus</h5>
                <p class="text-muted">Système de gestion de pharmacie © 2024</p>
            </div>
            <div class="col-md-6 text-end">
                <small class="text-muted">Version 1.0 - Projet Académique</small>
            </div>
        </div>
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>