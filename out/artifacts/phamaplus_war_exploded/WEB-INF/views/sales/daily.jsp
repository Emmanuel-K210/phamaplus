<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid py-4">
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="bi bi-calendar-day"></i> Ventes Quotidiennes</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard">Accueil</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/sales">Ventes</a></li>
                    <li class="breadcrumb-item active">Quotidiennes</li>
                </ol>
            </nav>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/sales/new" class="btn btn-success">
                <i class="bi bi-plus-circle"></i> Nouvelle Vente
            </a>
        </div>
    </div>

    <!-- Sélection de date -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/sales/daily" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label">Date</label>
                    <input type="date" name="date" class="form-control"
                           value="<fmt:formatDate value='${date}' pattern='yyyy-MM-dd'/>"
                           onchange="this.form.submit()">
                </div>
                <div class="col-md-8">
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-outline-secondary" onclick="changeDate(-1)">
                            <i class="bi bi-chevron-left"></i> Jour Précédent
                        </button>
                        <button type="button" class="btn btn-outline-primary" onclick="setToday()">
                            <i class="bi bi-calendar-check"></i> Aujourd'hui
                        </button>
                        <button type="button" class="btn btn-outline-secondary" onclick="changeDate(1)">
                            Jour Suivant <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- En-tête de la date sélectionnée -->
    <div class="alert alert-info mb-4">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h4 class="alert-heading mb-0">
                    <i class="bi bi-calendar3"></i>
                    <fmt:formatDate value="${date}" pattern="EEEE dd MMMM yyyy" />
                </h4>
            </div>
            <div class="col-md-4 text-end">
                <strong>${transactionCount}</strong> transaction(s) |
                <strong class="text-success">
                    <fmt:formatNumber value="${dailyRevenue}" pattern="#,##0"/> FCFA
                </strong>
            </div>
        </div>
    </div>

    <!-- Statistiques du jour -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card text-white bg-gradient-primary">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title">Chiffre d'Affaires</h6>
                            <h3>
                                <fmt:formatNumber value="${dailyRevenue}" pattern="#,##0"/> FCFA
                            </h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-currency-exchange" style="font-size: 2.5rem;"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-white bg-gradient-success">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title">Transactions</h6>
                            <h3>${transactionCount}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-receipt" style="font-size: 2.5rem;"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-white bg-gradient-warning">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title">Panier Moyen</h6>
                            <h3>
                                <c:choose>
                                    <c:when test="${transactionCount > 0}">
                                        <fmt:formatNumber value="${dailyRevenue / transactionCount}" pattern="#,##0"/> FCFA
                                    </c:when>
                                    <c:otherwise>0 FCFA</c:otherwise>
                                </c:choose>
                            </h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-cart" style="font-size: 2.5rem;"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card text-white bg-gradient-info">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-title">Meilleure Vente</h6>
                            <h3>
                                <c:set var="maxSale" value="0"/>
                                <c:forEach var="sale" items="${sales}">
                                    <c:if test="${sale.totalAmount > maxSale}">
                                        <c:set var="maxSale" value="${sale.totalAmount}"/>
                                    </c:if>
                                </c:forEach>
                                <fmt:formatNumber value="${maxSale}" pattern="#,##0"/> FCFA
                            </h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-trophy" style="font-size: 2.5rem;"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques -->
    <div class="row mb-4">
        <!-- Graphique horaire -->
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-clock-history"></i> Ventes par Heure</h5>
                </div>
                <div class="card-body">
                    <canvas id="hourlyChart" height="80"></canvas>
                </div>
            </div>
        </div>

        <!-- Répartition par mode de paiement -->
        <div class="col-md-4">
            <div class="card h-100">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-credit-card"></i> Modes de Paiement</h5>
                </div>
                <div class="card-body">
                    <canvas id="paymentChart"></canvas>
                    <div class="mt-3">
                        <c:set var="cashCount" value="0"/>
                        <c:set var="cardCount" value="0"/>
                        <c:set var="mobileCount" value="0"/>
                        <c:set var="insuranceCount" value="0"/>

                        <c:forEach var="sale" items="${sales}">
                            <c:choose>
                                <c:when test="${sale.paymentMethod eq 'cash'}">
                                    <c:set var="cashCount" value="${cashCount + 1}"/>
                                </c:when>
                                <c:when test="${sale.paymentMethod eq 'card'}">
                                    <c:set var="cardCount" value="${cardCount + 1}"/>
                                </c:when>
                                <c:when test="${sale.paymentMethod eq 'mobile'}">
                                    <c:set var="mobileCount" value="${mobileCount + 1}"/>
                                </c:when>
                                <c:when test="${sale.paymentMethod eq 'insurance'}">
                                    <c:set var="insuranceCount" value="${insuranceCount + 1}"/>
                                </c:when>
                            </c:choose>
                        </c:forEach>

                        <div class="d-flex justify-content-between mb-2">
                            <span><i class="bi bi-cash text-success"></i> Espèces:</span>
                            <strong>${cashCount}</strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span><i class="bi bi-credit-card text-primary"></i> Carte:</span>
                            <strong>${cardCount}</strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span><i class="bi bi-phone text-warning"></i> Mobile Money:</span>
                            <strong>${mobileCount}</strong>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span><i class="bi bi-shield-check text-info"></i> Assurance:</span>
                            <strong>${insuranceCount}</strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Liste des transactions -->
    <div class="card">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="bi bi-list-ul"></i> Transactions du Jour</h5>
                <div>
                    <button class="btn btn-sm btn-outline-primary" onclick="filterByPayment('all')">
                        Tous
                    </button>
                    <button class="btn btn-sm btn-outline-success" onclick="filterByPayment('cash')">
                        Espèces
                    </button>
                    <button class="btn btn-sm btn-outline-primary" onclick="filterByPayment('card')">
                        Carte
                    </button>
                    <button class="btn btn-sm btn-outline-warning" onclick="filterByPayment('mobile')">
                        Mobile
                    </button>
                </div>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="salesTable">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 10%;">ID</th>
                        <th style="width: 10%;">Heure</th>
                        <th style="width: 25%;">Client</th>
                        <th style="width: 15%;" class="text-end">Montant</th>
                        <th style="width: 15%;">Paiement</th>
                        <th style="width: 15%;">Servi par</th>
                        <th style="width: 10%;" class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="sale" items="${sales}">
                        <tr data-payment="${sale.paymentMethod}">
                            <td><strong>#${sale.saleId}</strong></td>
                            <td>
                                <strong><fmt:formatDate value="${sale.saleDate}" pattern="HH:mm"/></strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty sale.customerName}">
                                        <i class="bi bi-person"></i> ${sale.customerName}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">
                                            <i class="bi bi-person-x"></i> Client anonyme
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <strong class="text-primary">
                                    <fmt:formatNumber value="${sale.totalAmount}" pattern="#,##0"/> FCFA
                                </strong>
                            </td>
                            <td>
                                <span class="badge ${sale.paymentMethod eq 'cash' ? 'bg-success' :
                                                     sale.paymentMethod eq 'card' ? 'bg-primary' :
                                                     sale.paymentMethod eq 'mobile' ? 'bg-warning' :
                                                     sale.paymentMethod eq 'insurance' ? 'bg-info' : 'bg-secondary'}">
                                    <c:choose>
                                        <c:when test="${sale.paymentMethod eq 'cash'}">
                                            <i class="bi bi-cash"></i> Espèces
                                        </c:when>
                                        <c:when test="${sale.paymentMethod eq 'card'}">
                                            <i class="bi bi-credit-card"></i> Carte
                                        </c:when>
                                        <c:when test="${sale.paymentMethod eq 'mobile'}">
                                            <i class="bi bi-phone"></i> Mobile
                                        </c:when>
                                        <c:when test="${sale.paymentMethod eq 'insurance'}">
                                            <i class="bi bi-shield-check"></i> Assurance
                                        </c:when>
                                        <c:otherwise>Autre</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <small class="text-muted">
                                    <i class="bi bi-person-badge"></i> ${sale.servedBy}
                                </small>
                            </td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <a href="${pageContext.request.contextPath}/sales/view?id=${sale.saleId}"
                                       class="btn btn-outline-primary" title="Voir">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <button class="btn btn-outline-info"
                                            onclick="printReceipt(${sale.saleId})" title="Imprimer">
                                        <i class="bi bi-printer"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty sales}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-5">
                                <i class="bi bi-inbox" style="font-size: 3rem;"></i>
                                <p class="mt-3">Aucune vente pour cette journée</p>
                                <a href="${pageContext.request.contextPath}/sales/new" class="btn btn-primary mt-2">
                                    <i class="bi bi-plus-circle"></i> Créer une vente
                                </a>
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                    <tfoot class="table-light">
                    <tr>
                        <th colspan="3" class="text-end">TOTAL DU JOUR:</th>
                        <th class="text-end">
                            <strong class="text-success">
                                <fmt:formatNumber value="${dailyRevenue}" pattern="#,##0"/> FCFA
                            </strong>
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
    // Navigation entre les dates
    function changeDate(days) {
        const currentDate = new Date('<fmt:formatDate value="${date}" pattern="yyyy-MM-dd"/>');
        currentDate.setDate(currentDate.getDate() + days);
        const dateStr = currentDate.toISOString().split('T')[0];
        window.location.href = '${pageContext.request.contextPath}/sales/daily?date=' + dateStr;
    }

    function setToday() {
        const today = new Date().toISOString().split('T')[0];
        window.location.href = '${pageContext.request.contextPath}/sales/daily?date=' + today;
    }

    // Graphique par heure
    const hourlyData = new Array(24).fill(0);
    <c:forEach var="sale" items="${sales}">
    const hour = new Date('${sale.saleDate}').getHours();
    hourlyData[hour] += ${sale.totalAmount};
    </c:forEach>

    const hourlyCtx = document.getElementById('hourlyChart').getContext('2d');
    new Chart(hourlyCtx, {
        type: 'bar',
        data: {
            labels: Array.from({length: 24}, (_, i) => i + 'h'),
            datasets: [{
                label: 'Chiffre d\'Affaires (FCFA)',
                data: hourlyData,
                backgroundColor: 'rgba(13, 110, 253, 0.7)',
                borderColor: '#0d6efd',
                borderWidth: 1
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
    const paymentCtx = document.getElementById('paymentChart').getContext('2d');
    new Chart(paymentCtx, {
        type: 'doughnut',
        data: {
            labels: ['Espèces', 'Carte', 'Mobile Money', 'Assurance'],
            datasets: [{
                data: [${cashCount}, ${cardCount}, ${mobileCount}, ${insuranceCount}],
                backgroundColor: ['#198754', '#0d6efd', '#ffc107', '#0dcaf0']
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false }
            }
        }
    });

    // Filtrer par mode de paiement
    function filterByPayment(method) {
        const rows = document.querySelectorAll('#salesTable tbody tr[data-payment]');

        rows.forEach(row => {
            if (method === 'all' || row.dataset.payment === method) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Imprimer reçu
    function printReceipt(saleId) {
        window.open('${pageContext.request.contextPath}/sales/view?id=' + saleId + '&print=true',
            '_blank', 'width=800,height=600');
    }
</script>

<style>
    .stat-icon {
        opacity: 0.8;
    }
</style>