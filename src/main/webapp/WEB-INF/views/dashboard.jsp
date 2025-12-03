<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - PharmaPlus</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .stat-card { transition: all 0.3s; border-radius: 10px; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .stat-icon { font-size: 2.5rem; opacity: 0.8; }
        .chart-container { height: 250px; position: relative; }
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
<div class="container-fluid">
    <!-- Top Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-gradient-primary mb-4 shadow">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-speedometer2 me-2"></i> PharmaPlus Dashboard
            </a>
            <div class="navbar-nav ms-auto">
                <div class="d-flex align-items-center text-white">
                    <div class="me-3 text-end">
                        <div class="small">Bonjour, <strong>Pharmacien</strong></div>
                        <div class="small">${java.time.LocalDate.now()}</div>
                    </div>
                    <div class="dropdown">
                        <a href="#" class="text-white dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle fs-4"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#">
                                <i class="bi bi-person"></i> Mon profil
                            </a></li>
                            <li><a class="dropdown-item" href="#">
                                <i class="bi bi-gear"></i> Paramètres
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="#">
                                <i class="bi bi-box-arrow-right"></i> Déconnexion
                            </a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="row">
        <!-- Sidebar rapide -->
        <div class="col-md-2">
            <div class="card mb-4">
                <div class="card-body">
                    <h6 class="card-title text-muted mb-3">
                        <i class="bi bi-lightning"></i> Accès Rapide
                    </h6>
                    <div class="list-group list-group-flush">
                        <a href="${pageContext.request.contextPath}/sales/new"
                           class="list-group-item list-group-item-action border-0 py-2 quick-action">
                            <i class="bi bi-cart-plus text-success me-2"></i> Nouvelle Vente
                        </a>
                        <a href="${pageContext.request.contextPath}/inventory/add"
                           class="list-group-item list-group-item-action border-0 py-2 quick-action">
                            <i class="bi bi-box-arrow-in-down text-primary me-2"></i> Réapprovisionner
                        </a>
                        <a href="${pageContext.request.contextPath}/products/add"
                           class="list-group-item list-group-item-action border-0 py-2 quick-action">
                            <i class="bi bi-plus-circle text-warning me-2"></i> Nouveau Produit
                        </a>
                        <a href="${pageContext.request.contextPath}/sales/report"
                           class="list-group-item list-group-item-action border-0 py-2 quick-action">
                            <i class="bi bi-graph-up text-info me-2"></i> Rapports
                        </a>
                    </div>
                </div>
            </div>

            <!-- Alertes urgentes -->
            <div class="card border-danger alert-card">
                <div class="card-body">
                    <h6 class="card-title text-danger">
                        <i class="bi bi-bell"></i> Alertes
                    </h6>
                    <div class="list-group list-group-flush">
                        <c:if test="${expiredProducts > 0}">
                            <a href="${pageContext.request.contextPath}/inventory/expired"
                               class="list-group-item list-group-item-action border-0 py-2 text-danger">
                                <i class="bi bi-exclamation-triangle"></i>
                                    ${expiredProducts} produit(s) expiré(s)
                            </a>
                        </c:if>
                        <c:if test="${lowStockProducts > 0}">
                            <a href="${pageContext.request.contextPath}/products?filter=lowstock"
                               class="list-group-item list-group-item-action border-0 py-2 text-warning">
                                <i class="bi bi-exclamation-circle"></i>
                                    ${lowStockProducts} produit(s) en rupture
                            </a>
                        </c:if>
                        <c:if test="${expiringSoon > 0}">
                            <a href="${pageContext.request.contextPath}/inventory/expiring?days=30"
                               class="list-group-item list-group-item-action border-0 py-2 text-info">
                                <i class="bi bi-clock-history"></i>
                                    ${expiringSoon} expire(nt) bientôt
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Contenu principal -->
        <div class="col-md-10">
            <!-- Statistiques principales -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stat-card text-white bg-gradient-primary">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6 class="card-title">Chiffre d'Affaires</h6>
                                    <h2 class="card-text">${todaySummary.revenue} €</h2>
                                    <p class="card-text small">
                                        <i class="bi bi-calendar-check"></i> Aujourd'hui
                                    </p>
                                </div>
                                <div class="stat-icon">
                                    <i class="bi bi-currency-euro"></i>
                                </div>
                            </div>
                            <div class="progress bg-white bg-opacity-25" style="height: 5px;">
                                <div class="progress-bar bg-white" style="width: 75%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card text-white bg-gradient-success">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6 class="card-title">Transactions</h6>
                                    <h2 class="card-text">${todaySummary.transactions}</h2>
                                    <p class="card-text small">
                                        <i class="bi bi-receipt"></i> Aujourd'hui
                                    </p>
                                </div>
                                <div class="stat-icon">
                                    <i class="bi bi-cart-check"></i>
                                </div>
                            </div>
                            <div class="progress bg-white bg-opacity-25" style="height: 5px;">
                                <div class="progress-bar bg-white" style="width: 60%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card text-white bg-gradient-warning">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6 class="card-title">Produits en Stock</h6>
                                    <h2 class="card-text">${totalProducts}</h2>
                                    <p class="card-text small">
                                        <i class="bi bi-capsule"></i> Actifs
                                    </p>
                                </div>
                                <div class="stat-icon">
                                    <i class="bi bi-box-seam"></i>
                                </div>
                            </div>
                            <div class="progress bg-white bg-opacity-25" style="height: 5px;">
                                <div class="progress-bar bg-white" style="width: 85%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card text-white bg-gradient-info">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h6 class="card-title">Valeur Inventaire</h6>
                                    <h2 class="card-text">${inventoryValue} €</h2>
                                    <p class="card-text small">
                                        <i class="bi bi-gem"></i> Valeur estimée
                                    </p>
                                </div>
                                <div class="stat-icon">
                                    <i class="bi bi-graph-up-arrow"></i>
                                </div>
                            </div>
                            <div class="progress bg-white bg-opacity-25" style="height: 5px;">
                                <div class="progress-bar bg-white" style="width: 90%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Deuxième ligne de stats -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stat-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title text-muted">Produits Vendus</h6>
                                    <h4 class="card-text">${todaySummary.itemsSold}</h4>
                                </div>
                                <div class="stat-icon text-success">
                                    <i class="bi bi-basket"></i>
                                </div>
                            </div>
                            <small class="text-muted">
                                <i class="bi bi-arrow-up text-success"></i> 12% vs hier
                            </small>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title text-muted">Panier Moyen</h6>
                                    <h4 class="card-text">
                                        <c:choose>
                                            <c:when test="${todaySummary.transactions > 0}">
                                                ${String.format("%.2f", todaySummary.revenue / todaySummary.transactions)} €
                                            </c:when>
                                            <c:otherwise>0.00 €</c:otherwise>
                                        </c:choose>
                                    </h4>
                                </div>
                                <div class="stat-icon text-primary">
                                    <i class="bi bi-cart"></i>
                                </div>
                            </div>
                            <small class="text-muted">
                                <i class="bi bi-arrow-up text-success"></i> 5.3% vs hier
                            </small>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title text-muted">CA Mensuel</h6>
                                    <h4 class="card-text">${monthlyRevenue} €</h4>
                                </div>
                                <div class="stat-icon text-warning">
                                    <i class="bi bi-calendar-month"></i>
                                </div>
                            </div>
                            <small class="text-muted">
                                <i class="bi bi-arrow-up text-success"></i> 8.2% vs mois dernier
                            </small>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card stat-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="card-title text-muted">Clients du Jour</h6>
                                    <h4 class="card-text">
                                        <!-- À calculer dans le service -->
                                        42
                                    </h4>
                                </div>
                                <div class="stat-icon text-info">
                                    <i class="bi bi-people"></i>
                                </div>
                            </div>
                            <small class="text-muted">
                                <i class="bi bi-arrow-up text-success"></i> 3 nouveaux
                            </small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Graphiques et Top Produits -->
            <div class="row mb-4">
                <!-- Graphique des ventes -->
                <div class="col-md-8">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-bar-chart"></i> Performance des Ventes (7 jours)
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <!-- Placeholder pour Chart.js -->
                                <div class="text-center py-4">
                                    <canvas id="salesChart" width="400" height="200"></canvas>
                                </div>
                            </div>
                            <div class="row text-center mt-3">
                                <div class="col">
                                    <div class="p-2 border rounded bg-light">
                                        <small class="text-muted">Meilleur jour</small><br>
                                        <strong>Samedi</strong><br>
                                        <span class="text-success">890€</span>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="p-2 border rounded bg-light">
                                        <small class="text-muted">Moyenne quotidienne</small><br>
                                        <strong>585€</strong><br>
                                        <span class="text-info">+12%</span>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="p-2 border rounded bg-light">
                                        <small class="text-muted">Objectif mensuel</small><br>
                                        <strong>15,000€</strong><br>
                                        <span class="text-warning">68%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Top produits -->
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-trophy"></i> Top 5 Produits
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="list-group list-group-flush">
                                <c:forEach var="product" items="${topProducts}" varStatus="status">
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="d-flex align-items-center">
                                                    <span class="badge bg-primary me-2">#${status.index + 1}</span>
                                                    <strong>${product[1]}</strong>
                                                </div>
                                                <small class="text-muted">${product[2]} unités vendues</small>
                                            </div>
                                            <div class="text-end">
                                                <strong>${String.format("%.2f", product[3])} €</strong><br>
                                                <small class="text-success">
                                                    <i class="bi bi-arrow-up"></i> 15%
                                                </small>
                                            </div>
                                        </div>
                                        <div class="progress mt-2" style="height: 5px;">
                                            <div class="progress-bar bg-success"
                                                 style="width: ${100 - (status.index * 15)}%">
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty topProducts}">
                                    <div class="text-center py-4 text-muted">
                                        <i class="bi bi-bar-chart" style="font-size: 2rem;"></i>
                                        <p class="mt-2">Aucune donnée de vente</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ventes récentes et notifications -->
            <div class="row">
                <!-- Ventes récentes -->
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="bi bi-clock-history"></i> Ventes Récentes
                                </h5>
                                <a href="${pageContext.request.contextPath}/sales" class="btn btn-sm btn-outline-primary">
                                    Voir tout <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Heure</th>
                                        <th>Client</th>
                                        <th>Montant</th>
                                        <th>Paiement</th>
                                        <th>Status</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="sale" items="${recentSales}">
                                        <tr class="recent-sale">
                                            <td><strong>#${sale.saleId}</strong></td>
                                            <td>${sale.saleDate.toLocalTime().withNano(0)}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty sale.customerName}">
                                                        ${sale.customerName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <strong>${sale.totalAmount} €</strong>
                                            </td>
                                            <td>
                                                        <span class="badge
                                                            ${'cash' eq sale.paymentMethod ? 'bg-success' :
                                                              'card' eq sale.paymentMethod ? 'bg-primary' :
                                                              'insurance' eq sale.paymentMethod ? 'bg-purple' : 'bg-secondary'}">
                                                            <c:choose>
                                                                <c:when test="${'cash' eq sale.paymentMethod}">Espèces</c:when>
                                                                <c:when test="${'card' eq sale.paymentMethod}">Carte</c:when>
                                                                <c:when test="${'insurance' eq sale.paymentMethod}">Assurance</c:when>
                                                            </c:choose>
                                                        </span>
                                            </td>
                                            <td>
                                                        <span class="badge bg-success">
                                                            <i class="bi bi-check-circle"></i> Payé
                                                        </span>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty recentSales}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
                                                <i class="bi bi-cart" style="font-size: 2rem;"></i>
                                                <p class="mt-2">Aucune vente récente</p>
                                            </td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Notifications et activités -->
                <div class="col-md-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-bell"></i> Activités Récentes
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="timeline">
                                <div class="timeline-item mb-3">
                                    <div class="timeline-marker bg-success"></div>
                                    <div class="timeline-content">
                                        <small class="text-muted">Il y a 5 min</small>
                                        <p class="mb-0">Nouvelle vente #1042 pour 45.60€</p>
                                    </div>
                                </div>
                                <div class="timeline-item mb-3">
                                    <div class="timeline-marker bg-primary"></div>
                                    <div class="timeline-content">
                                        <small class="text-muted">Il y a 1h</small>
                                        <p class="mb-0">Réapprovisionnement: Paracetamol (200 unités)</p>
                                    </div>
                                </div>
                                <div class="timeline-item mb-3">
                                    <div class="timeline-marker bg-warning"></div>
                                    <div class="timeline-content">
                                        <small class="text-muted">Il y a 2h</small>
                                        <p class="mb-0">Alerte: Amoxicillin en stock faible</p>
                                    </div>
                                </div>
                                <div class="timeline-item mb-3">
                                    <div class="timeline-marker bg-info"></div>
                                    <div class="timeline-content">
                                        <small class="text-muted">Il y a 3h</small>
                                        <p class="mb-0">Nouveau client enregistré: Marie Dupont</p>
                                    </div>
                                </div>
                                <div class="timeline-item">
                                    <div class="timeline-marker bg-danger"></div>
                                    <div class="timeline-content">
                                        <small class="text-muted">Il y a 5h</small>
                                        <p class="mb-0">3 produits ont expiré aujourd'hui</p>
                                    </div>
                                </div>
                            </div>

                            <style>
                                .timeline { position: relative; }
                                .timeline-item { position: relative; padding-left: 30px; }
                                .timeline-marker {
                                    position: absolute;
                                    left: 0;
                                    top: 5px;
                                    width: 12px;
                                    height: 12px;
                                    border-radius: 50%;
                                }
                                .timeline-content { margin-left: 10px; }
                            </style>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pied de page du dashboard -->
            <footer class="mt-4 pt-3 border-top text-muted small">
                <div class="row">
                    <div class="col-md-6">
                        <i class="bi bi-shop"></i> <strong>PharmaPlus</strong> - Système de Gestion de Pharmacie<br>
                        <small>Version 1.0 | Dernière mise à jour: Aujourd'hui, 14:30</small>
                    </div>
                    <div class="col-md-6 text-end">
                        <small>
                            <i class="bi bi-server"></i> Serveur: PostgreSQL 15<br>
                            <i class="bi bi-cpu"></i> Performance: <span class="text-success">Optimale</span>
                        </small>
                    </div>
                </div>
            </footer>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Graphique des ventes avec Chart.js
    const ctx = document.getElementById('salesChart').getContext('2d');
    const salesChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
            datasets: [{
                label: 'Chiffre d\'Affaires (€)',
                data: [450, 520, 480, 610, 720, 890, 320],
                borderColor: '#0d6efd',
                backgroundColor: 'rgba(13, 110, 253, 0.1)',
                borderWidth: 2,
                fill: true,
                tension: 0.3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0,0,0,0.05)'
                    }
                },
                x: {
                    grid: {
                        display: false
                    }
                }
            }
        }
    });

    // Mettre à jour l'heure en temps réel
    function updateTime() {
        const now = new Date();
        const timeStr = now.toLocaleTimeString('fr-FR', {
            hour: '2-digit',
            minute: '2-digit'
        });
        const dateStr = now.toLocaleDateString('fr-FR', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });

        // Met à jour l'affichage si les éléments existent
        const timeElement = document.querySelector('.navbar .small:last-child');
        if (timeElement) {
            timeElement.innerHTML = `${dateStr}<br>${timeStr}`;
        }
    }

    // Mettre à jour l'heure toutes les minutes
    setInterval(updateTime, 60000);
    updateTime(); // Initial call

    // Animation pour les cartes de statistiques
    document.querySelectorAll('.stat-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.boxShadow = '0 15px 30px rgba(0,0,0,0.15)';
        });
        card.addEventListener('mouseleave', function() {
            this.style.boxShadow = '0 10px 20px rgba(0,0,0,0.1)';
        });
    });

    // Auto-refresh du dashboard toutes les 5 minutes
    setInterval(() => {
        // Pour un vrai projet, on ferait un appel AJAX
        console.log('Dashboard refresh nécessaire');
    }, 300000); // 5 minutes
</script>
</body>
</html>