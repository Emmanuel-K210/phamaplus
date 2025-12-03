<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-people text-primary me-2"></i>Gestion des Clients
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-person me-1"></i>
                        <c:choose>
                            <c:when test="${not empty totalCustomers}">${totalCustomers}</c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                        clients enregistrés
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/customers?export=true" class="btn btn-modern btn-gradient-info">
                        <i class="bi bi-download me-2"></i>Exporter
                    </a>
                    <a href="${pageContext.request.contextPath}/customers/add" class="btn btn-modern btn-gradient-primary">
                        <i class="bi bi-plus-circle me-2"></i>Nouveau Client
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show modern-card mb-4">
            <i class="bi bi-check-circle-fill me-2"></i>${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show modern-card mb-4">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Statistiques -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1">
                            <c:choose>
                                <c:when test="${not empty totalCustomers}">${totalCustomers}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">Clients Totaux</p>
                    </div>
                    <i class="bi bi-people-fill stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/customers?filter=with_email" class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-1">
                                <c:choose>
                                    <c:when test="${not empty customersWithEmail}">${customersWithEmail}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h3>
                            <p class="mb-0 opacity-75">Avec Email</p>
                        </div>
                        <i class="bi bi-envelope-fill stat-icon"></i>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/customers?filter=with_allergies" class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-1">
                                <c:choose>
                                    <c:when test="${not empty customersWithAllergies}">${customersWithAllergies}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h3>
                            <p class="mb-0 opacity-75">Avec Allergies</p>
                        </div>
                        <i class="bi bi-exclamation-triangle-fill stat-icon"></i>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/customers?filter=with_prescriptions" class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-1">
                                <c:choose>
                                    <c:when test="${not empty customersWithPrescriptions}">${customersWithPrescriptions}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h3>
                            <p class="mb-0 opacity-75">Avec Ordonnances</p>
                        </div>
                        <i class="bi bi-file-medical-fill stat-icon"></i>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <!-- Recherche avancée -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="modern-card p-4">
                <form action="${pageContext.request.contextPath}/customers" method="get" class="row g-3">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                                <i class="bi bi-search"></i>
                            </span>
                            <input type="text" class="form-control modern-input border-start-0"
                                   name="search" placeholder="Nom, prénom ou téléphone..."
                                   value="${param.search}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" name="filter">
                            <option value="">Tous les clients</option>
                            <option value="with_email" ${param.filter == 'with_email' ? 'selected' : ''}>Avec email</option>
                            <option value="with_allergies" ${param.filter == 'with_allergies' ? 'selected' : ''}>Avec allergies</option>
                            <option value="with_prescriptions" ${param.filter == 'with_prescriptions' ? 'selected' : ''}>Avec ordonnances</option>
                            <option value="recent" ${param.filter == 'recent' ? 'selected' : ''}>Clients récents</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" name="birthdayMonth">
                            <option value="">Anniversaire par mois</option>
                            <option value="1" ${param.birthdayMonth == '1' ? 'selected' : ''}>Janvier</option>
                            <option value="2" ${param.birthdayMonth == '2' ? 'selected' : ''}>Février</option>
                            <option value="3" ${param.birthdayMonth == '3' ? 'selected' : ''}>Mars</option>
                            <option value="4" ${param.birthdayMonth == '4' ? 'selected' : ''}>Avril</option>
                            <option value="5" ${param.birthdayMonth == '5' ? 'selected' : ''}>Mai</option>
                            <option value="6" ${param.birthdayMonth == '6' ? 'selected' : ''}>Juin</option>
                            <option value="7" ${param.birthdayMonth == '7' ? 'selected' : ''}>Juillet</option>
                            <option value="8" ${param.birthdayMonth == '8' ? 'selected' : ''}>Août</option>
                            <option value="9" ${param.birthdayMonth == '9' ? 'selected' : ''}>Septembre</option>
                            <option value="10" ${param.birthdayMonth == '10' ? 'selected' : ''}>Octobre</option>
                            <option value="11" ${param.birthdayMonth == '11' ? 'selected' : ''}>Novembre</option>
                            <option value="12" ${param.birthdayMonth == '12' ? 'selected' : ''}>Décembre</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-modern btn-gradient-primary w-100">
                            <i class="bi bi-funnel me-2"></i>Filtrer
                        </button>
                    </div>
                </form>

                <!-- Options avancées -->
                <div class="row mt-3">
                    <div class="col-12">
                        <div class="d-flex justify-content-between">
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-sm btn-outline-info" onclick="showStatsModal()">
                                    <i class="bi bi-graph-up me-1"></i>Statistiques
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-warning" onclick="exportCustomers('csv')">
                                    <i class="bi bi-file-earmark-excel me-1"></i>CSV
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="exportCustomers('pdf')">
                                    <i class="bi bi-file-earmark-pdf me-1"></i>PDF
                                </button>
                            </div>
                            <div>
                                <c:if test="${not empty param.search or not empty param.filter or not empty param.birthdayMonth}">
                                    <a href="${pageContext.request.contextPath}/customers" class="btn btn-sm btn-outline-secondary">
                                        <i class="bi bi-x-circle me-1"></i>Effacer les filtres
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tableau des clients -->
    <div class="row">
        <div class="col-12">
            <div class="modern-card p-0">
                <div class="table-responsive">
                    <table class="table modern-table mb-0">
                        <thead>
                        <tr>
                            <th><i class="bi bi-hash me-2"></i>ID</th>
                            <th><i class="bi bi-person me-2"></i>Client</th>
                            <th><i class="bi bi-telephone me-2"></i>Contact</th>
                            <th><i class="bi bi-envelope me-2"></i>Email</th>
                            <th><i class="bi bi-calendar me-2"></i>Naissance</th>
                            <th><i class="bi bi-house me-2"></i>Adresse</th>
                            <th><i class="bi bi-exclamation-triangle me-2"></i>Allergies</th>
                            <th><i class="bi bi-clock me-2"></i>Inscrit le</th>
                            <th class="text-center"><i class="bi bi-gear me-2"></i>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty customers}">
                                <tr>
                                    <td colspan="9" class="text-center py-5">
                                        <i class="bi bi-people display-1 text-muted d-block mb-3"></i>
                                        <h5 class="text-muted">Aucun client trouvé</h5>
                                        <a href="${pageContext.request.contextPath}/customers/add"
                                           class="btn btn-modern btn-gradient-primary mt-3">
                                            <i class="bi bi-plus-circle me-2"></i>Ajouter votre premier client
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="customer" items="${customers}">
                                    <tr>
                                        <td><strong>#${customer.customerId}</strong></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                                                    <i class="bi bi-person-circle text-primary"></i>
                                                </div>
                                                <div>
                                                    <strong>${customer.firstName} ${customer.lastName}</strong>
                                                    <c:if test="${not empty customer.dateOfBirth}">
                                                        <br>
                                                        <small class="text-muted">
                                                            <fmt:formatNumber value="${customer.age}" pattern="0" /> ans
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty customer.phone}">
                                                    <i class="bi bi-telephone text-muted me-1"></i>
                                                    ${customer.phone}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty customer.email}">
                                                    <i class="bi bi-envelope text-muted me-1"></i>
                                                    <a href="mailto:${customer.email}" class="text-decoration-none">
                                                            ${customer.email}
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty customer.dateOfBirth}">
                                                    ${customer.dateOfBirth}
                                                    <br>
                                                    <small class="text-muted">
                                                        <fmt:formatNumber value="${customer.age}" pattern="0" /> ans
                                                    </small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Non renseignée</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="text-truncate" style="max-width: 150px;">
                                                <c:choose>
                                                    <c:when test="${not empty customer.address}">
                                                        <i class="bi bi-house text-muted me-1"></i>
                                                        ${customer.address}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty customer.allergies}">
                                                    <span class="badge badge-modern bg-warning text-dark"
                                                          data-bs-toggle="tooltip"
                                                          title="${customer.allergies}">
                                                        <i class="bi bi-exclamation-triangle me-1"></i>
                                                        Oui
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-modern bg-success">
                                                        <i class="bi bi-check-circle me-1"></i>
                                                        Non
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty customer.createdAt}">
                                                    <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy"/>
                                                    <br>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${customer.createdAt}" pattern="HH:mm"/>
                                                    </small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a href="${pageContext.request.contextPath}/sales/create?customerId=${customer.customerId}"
                                                   class="btn btn-outline-success" title="Nouvelle vente" data-bs-toggle="tooltip">
                                                    <i class="bi bi-cart-plus"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/prescriptions/create?customerId=${customer.customerId}"
                                                   class="btn btn-outline-info" title="Nouvelle ordonnance" data-bs-toggle="tooltip">
                                                    <i class="bi bi-file-medical"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/customers/edit?id=${customer.customerId}"
                                                   class="btn btn-outline-primary" title="Modifier" data-bs-toggle="tooltip">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <button type="button" class="btn btn-outline-danger"
                                                        onclick="confirmDelete(${customer.customerId}, '${customer.firstName} ${customer.lastName}')"
                                                        title="Supprimer" data-bs-toggle="tooltip">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination et informations -->
                <div class="p-4 border-top">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="mb-0 text-muted">
                                Affichage de <strong>${customers.size()}</strong> client(s)
                            </p>
                            <small class="text-muted">
                                <c:if test="${not empty param.search}">
                                    Recherche: "${param.search}" •
                                </c:if>
                                <c:if test="${not empty param.filter}">
                                    Filtre: ${param.filter} •
                                </c:if>
                                Dernière mise à jour:
                                <jsp:useBean id="now" class="java.util.Date"/>
                                <fmt:formatDate value="${now}" pattern="HH:mm:ss"/>
                            </small>
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <!-- Boutons d'action groupés -->
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printTable()">
                                    <i class="bi bi-printer"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="exportCustomers('csv')">
                                    <i class="bi bi-file-earmark-arrow-down"></i>
                                </button>
                            </div>

                            <!-- Pagination -->
                            <nav>
                                <ul class="pagination mb-0">
                                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${page - 1}&search=${param.search}&filter=${param.filter}&birthdayMonth=${param.birthdayMonth}">
                                            <i class="bi bi-chevron-left"></i>
                                        </a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <li class="page-item ${p == page ? 'active' : ''}">
                                            <a class="page-link" href="?page=${p}&search=${param.search}&filter=${param.filter}&birthdayMonth=${param.birthdayMonth}">
                                                    ${p}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${page == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${page + 1}&search=${param.search}&filter=${param.filter}&birthdayMonth=${param.birthdayMonth}">
                                            <i class="bi bi-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal pour les statistiques -->
<div class="modal fade" id="statsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-graph-up me-2"></i>Statistiques des Clients
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="modern-card p-3">
                            <h6 class="mb-3"><i class="bi bi-people me-2"></i>Répartition</h6>
                            <ul class="list-unstyled">
                                <li class="mb-2 d-flex justify-content-between">
                                    <span>Total clients:</span>
                                    <strong>${totalCustomers}</strong>
                                </li>
                                <li class="mb-2 d-flex justify-content-between">
                                    <span>Avec email:</span>
                                    <strong>${customersWithEmail}</strong>
                                </li>
                                <li class="mb-2 d-flex justify-content-between">
                                    <span>Avec allergies:</span>
                                    <strong>${customersWithAllergies}</strong>
                                </li>
                                <li class="mb-2 d-flex justify-content-between">
                                    <span>Avec adresse:</span>
                                    <strong>${customersWithAddress}</strong>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="modern-card p-3">
                            <h6 class="mb-3"><i class="bi bi-calendar me-2"></i>Métriques</h6>
                            <ul class="list-unstyled">
                                <li class="mb-2 d-flex justify-content-between">
                                    <span>Âge moyen:</span>
                                    <strong>${averageAge} ans</strong>
                                </li>
                                <li class="mb-2 d-flex justify-content-between">
                                    <span>Clients/mois:</span>
                                    <strong>${avgClientsPerMonth}</strong>
                                </li>
                                <li class="mb-2 d-flex justify-content-between">
                                    <span>Dernier client:</span>
                                    <strong>#${latestCustomerId}</strong>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <!-- Graphique simple -->
                <div class="mt-4">
                    <canvas id="statsChart" height="100"></canvas>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                <button type="button" class="btn btn-primary" onclick="exportStats()">
                    <i class="bi bi-download me-2"></i>Exporter les stats
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Initialiser les tooltips Bootstrap
    document.addEventListener('DOMContentLoaded', function() {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });

    // Confirmation de suppression
    function confirmDelete(customerId, customerName) {
        if (confirm('Êtes-vous sûr de vouloir supprimer le client "' + customerName + '" ?\n\nCette action est irréversible.')) {
            window.location.href = '${pageContext.request.contextPath}/customers/delete?id=' + customerId;
        }
    }

    // Exportation
    function exportCustomers(format) {
        let url = '${pageContext.request.contextPath}/customers/export?format=' + format;

        // Ajouter les paramètres de filtre
        const search = '${param.search}';
        const filter = '${param.filter}';
        const birthdayMonth = '${param.birthdayMonth}';

        if (search) url += '&search=' + encodeURIComponent(search);
        if (filter) url += '&filter=' + filter;
        if (birthdayMonth) url += '&birthdayMonth=' + birthdayMonth;

        window.location.href = url;
    }

    // Impression du tableau
    function printTable() {
        const printContent = document.querySelector('.modern-card').outerHTML;
        const originalContent = document.body.innerHTML;

        document.body.innerHTML = `
            <!DOCTYPE html>
            <html>
            <head>
                <title>Liste des Clients - PharmaPlus</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #f8f9fa; }
                    .header { text-align: center; margin-bottom: 20px; }
                    .footer { margin-top: 30px; font-size: 12px; color: #666; }
                </style>
            </head>
            <body>
                <div class="header">
                    <h2>Liste des Clients</h2>
                    <p>PharmaPlus - ${new Date().toLocaleDateString()}</p>
                </div>
                ${printContent}
                <div class="footer">
                    Document généré le ${new Date().toLocaleString()}
                </div>
            </body>
            </html>
        `;

        window.print();
        document.body.innerHTML = originalContent;
        location.reload();
    }

    // Modal de statistiques
    function showStatsModal() {
        const modal = new bootstrap.Modal(document.getElementById('statsModal'));
        modal.show();

        // Initialiser le graphique
        initStatsChart();
    }

    // Graphique des statistiques
    function initStatsChart() {
        const ctx = document.getElementById('statsChart').getContext('2d');

        // Données de démonstration
        const data = {
            labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun'],
            datasets: [{
                label: 'Nouveaux clients',
                data: [12, 19, 8, 15, 22, 18],
                borderColor: 'rgb(102, 126, 234)',
                backgroundColor: 'rgba(102, 126, 234, 0.2)',
                tension: 0.4,
                fill: true
            }]
        };

        new Chart(ctx, {
            type: 'line',
            data: data,
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'Évolution des inscriptions'
                    }
                }
            }
        });
    }

    // Exportation des statistiques
    function exportStats() {
        alert('Fonctionnalité d\'exportation des statistiques à implémenter');
    }

    // Recherche rapide
    let searchTimeout;
    document.querySelector('input[name="search"]').addEventListener('input', function(e) {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            if (e.target.value.length > 2 || e.target.value.length === 0) {
                e.target.form.submit();
            }
        }, 500);
    });

    // Auto-sélection du mois d'anniversaire actuel
    const currentMonth = new Date().getMonth() + 1;
    const birthdayMonthSelect = document.querySelector('select[name="birthdayMonth"]');
    if (birthdayMonthSelect && !birthdayMonthSelect.value) {
        // Optionnel: auto-sélectionner le mois courant
        // birthdayMonthSelect.value = currentMonth;
    }
</script>

<style>
    /* Styles supplémentaires */
    .stat-card {
        cursor: pointer;
        transition: transform 0.3s;
    }

    .stat-card:hover {
        transform: translateY(-5px);
    }

    .table-hover tbody tr:hover {
        background-color: rgba(102, 126, 234, 0.05);
    }

    .badge-modern {
        padding: 0.35rem 0.65rem;
        font-weight: 500;
        font-size: 0.75rem;
    }

    .btn-group-sm .btn {
        padding: 0.25rem 0.5rem;
    }

    /* Styles d'impression */
    @media print {
        .no-print {
            display: none !important;
        }
    }

</style>