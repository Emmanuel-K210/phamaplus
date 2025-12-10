<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid py-4">
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="bi bi-file-bar-graph"></i> Rapport des Ventes</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard">Accueil</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/sales">Ventes</a></li>
                    <li class="breadcrumb-item active">Rapport</li>
                </ol>
            </nav>
        </div>
        <div>
            <button onclick="exportToExcel()" class="btn btn-success">
                <i class="bi bi-file-excel"></i> Export Excel
            </button>
            <button onclick="window.print()" class="btn btn-primary">
                <i class="bi bi-printer"></i> Imprimer
            </button>
        </div>
    </div>

    <!-- Filtre de période -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/sales/report" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Date de début</label>
                    <input type="date" name="startDate" class="form-control"
                           value="<fmt:formatDate value='${startDate}' pattern='yyyy-MM-dd'/>" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Date de fin</label>
                    <input type="date" name="endDate" class="form-control"
                           value="<fmt:formatDate value='${endDate}' pattern='yyyy-MM-dd'/>" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Période rapide</label>
                    <select class="form-select" id="quickPeriod" onchange="setQuickPeriod()">
                        <option value="">Personnalisée</option>
                        <option value="today">Aujourd'hui</option>
                        <option value="yesterday">Hier</option>
                        <option value="week">Cette semaine</option>
                        <option value="month">Ce mois</option>
                        <option value="lastMonth">Mois dernier</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">&nbsp;</label>
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-search"></i> Générer Rapport
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Statistiques globales -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card text-white bg-gradient-primary">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Chiffre d'Affaires</h6>
                            <h3>
                                <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> FCFA
                            </h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-currency-exchange"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-white bg-gradient-success">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Transactions</h6>
                            <h3>${fn:length(sales)}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-receipt"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-white bg-gradient-warning">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Articles Vendus</h6>
                            <h3>${totalItems}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-basket"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-white bg-gradient-info">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h6 class="card-title">Panier Moyen</h6>
                            <h3>
                                <c:choose>
                                    <c:when test="${fn:length(sales) > 0}">
                                        <fmt:formatNumber value="${totalRevenue / fn:length(sales)}" pattern="#,##0"/> FCFA
                                    </c:when>
                                    <c:otherwise>0 FCFA</c:otherwise>
                                </c:choose>
                            </h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-cart"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <!-- Graphique d'évolution -->
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-graph-up"></i> Évolution des Ventes</h5>
                </div>
                <div class="card-body">
                    <canvas id="salesTrendChart" height="100"></canvas>
                </div>
            </div>
        </div>

        <!-- Répartition par mode de paiement -->
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-pie-chart"></i> Modes de Paiement</h5>
                </div>
                <div class="card-body">
                    <canvas id="paymentMethodChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Top Produits -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-trophy"></i> Top 10 Produits les Plus Vendus</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 5%;">#</th>
                                <th style="width: 45%;">Produit</th>
                                <th style="width: 20%;" class="text-center">Quantité</th>
                                <th style="width: 30%;" class="text-end">CA Généré</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="product" items="${topProducts}" varStatus="status">
                                <tr>
                                    <td class="text-center">
                                        <span class="badge ${status.index < 3 ? 'bg-warning' : 'bg-secondary'}">
                                                ${status.index + 1}
                                        </span>
                                    </td>
                                    <td>
                                        <strong>${product[1]}</strong>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-info">${product[2]} unités</span>
                                    </td>
                                    <td class="text-end">
                                        <strong class="text-success">
                                            <fmt:formatNumber value="${product[3]}" pattern="#,##0"/> FCFA
                                        </strong>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty topProducts}">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-4">
                                        Aucun produit vendu pour cette période
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Analyse par période -->
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-calendar3"></i> Analyse par Jour</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-sm table-hover mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>Date</th>
                                <th class="text-center">Ventes</th>
                                <th class="text-end">Chiffre d'Affaires</th>
                                <th class="text-end">Évolution</th>
                            </tr>
                            </thead>
                            <tbody id="dailyAnalysis">
                            <!-- Généré dynamiquement depuis les données sales -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Liste détaillée des ventes -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-list-ul"></i> Liste Détaillée des Ventes</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0" id="salesTable">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>Client</th>
                        <th class="text-end">Montant</th>
                        <th>Paiement</th>
                        <th>Servi par</th>
                        <th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="sale" items="${sales}">
                        <tr>
                            <td><strong>#${sale.saleId}</strong></td>
                            <td>
                                <fmt:formatDate value="${sale.saleDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty sale.customerName}">
                                        ${sale.customerName}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Client anonyme</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <strong>
                                    <fmt:formatNumber value="${sale.totalAmount}" pattern="#,##0"/> FCFA
                                </strong>
                            </td>
                            <td>
                                <span class="badge ${sale.paymentMethod eq 'cash' ? 'bg-success' :
                                                     sale.paymentMethod eq 'card' ? 'bg-primary' :
                                                     sale.paymentMethod eq 'mobile' ? 'bg-warning' :
                                                     sale.paymentMethod eq 'insurance' ? 'bg-info' : 'bg-secondary'}">
                                    <c:choose>
                                        <c:when test="${sale.paymentMethod eq 'cash'}">Espèces</c:when>
                                        <c:when test="${sale.paymentMethod eq 'card'}">Carte</c:when>
                                        <c:when test="${sale.paymentMethod eq 'mobile'}">Mobile</c:when>
                                        <c:when test="${sale.paymentMethod eq 'insurance'}">Assurance</c:when>
                                        <c:otherwise>Autre</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>${sale.servedBy}</td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/sales/view?id=${sale.saleId}"
                                   class="btn btn-sm btn-outline-primary" target="_blank">
                                    <i class="bi bi-eye"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty sales}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                Aucune vente pour cette période
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                    <tfoot class="table-light">
                    <tr>
                        <th colspan="3" class="text-end">TOTAL:</th>
                        <th class="text-end">
                            <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> FCFA
                        </th>
                        <th colspan="3"></th>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    // Définir période rapide
    function setQuickPeriod() {
        const period = document.getElementById('quickPeriod').value;
        const today = new Date();
        let startDate, endDate = today;

        switch(period) {
            case 'today':
                startDate = today;
                break;
            case 'yesterday':
                startDate = new Date(today.setDate(today.getDate() - 1));
                endDate = startDate;
                break;
            case 'week':
                startDate = new Date(today.setDate(today.getDate() - 7));
                break;
            case 'month':
                startDate = new Date(today.getFullYear(), today.getMonth(), 1);
                break;
            case 'lastMonth':
                startDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
                endDate = new Date(today.getFullYear(), today.getMonth(), 0);
                break;
            default:
                return;
        }

        document.querySelector('[name="startDate"]').valueAsDate = startDate;
        document.querySelector('[name="endDate"]').valueAsDate = endDate;
    }

    // Graphique d'évolution des ventes
    const salesTrendCtx = document.getElementById('salesTrendChart').getContext('2d');
    new Chart(salesTrendCtx, {
        type: 'line',
        data: {
            labels: ${salesDatesJSON}, // À passer depuis le servlet
            datasets: [{
                label: 'Chiffre d\'Affaires (FCFA)',
                data: ${salesValuesJSON}, // À passer depuis le servlet
                borderColor: '#0d6efd',
                backgroundColor: 'rgba(13, 110, 253, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.parsed.y.toLocaleString() + ' FCFA';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value.toLocaleString() + ' FCFA';
                        }
                    }
                }
            }
        }
    });

    // Graphique modes de paiement
    const paymentCtx = document.getElementById('paymentMethodChart').getContext('2d');
    new Chart(paymentCtx, {
        type: 'doughnut',
        data: {
            labels: ['Espèces', 'Carte', 'Mobile Money', 'Assurance'],
            datasets: [{
                data: ${paymentMethodData}, // À passer depuis le servlet
                backgroundColor: ['#198754', '#0d6efd', '#ffc107', '#0dcaf0']
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });

    // Export Excel
    function exportToExcel() {
        alert('Export Excel en cours de développement');
        // À implémenter avec une librairie comme xlsx
    }

    // Impression
    window.onbeforeprint = function() {
        document.querySelectorAll('.no-print').forEach(el => el.style.display = 'none');
    };

    window.onafterprint = function() {
        document.querySelectorAll('.no-print').forEach(el => el.style.display = '');
    };
</script>

<style>
    @media print {
        .no-print, .btn, nav, .card-header .btn {
            display: none !important;
        }

        .card {
            break-inside: avoid;
            page-break-inside: avoid;
        }
    }
</style>