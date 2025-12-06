<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Désactiver le cache pour éviter les pages blanches --%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-cart-check text-primary me-2"></i>Gestion des Ventes
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-calendar me-1"></i>
                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd MMMM yyyy"/>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/sales/create" class="btn btn-modern btn-gradient-primary">
                    <i class="bi bi-plus-circle me-2"></i>Nouvelle Vente
                </a>
            </div>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show modern-card mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            <strong>Succès !</strong> ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show modern-card mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <strong>Erreur !</strong> ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Statistiques rapides -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1" data-stat-value="${todaySales}">
                            <c:choose>
                                <c:when test="${not empty todaySales}">
                                    <fmt:formatNumber value="${todaySales}" pattern="#,##0" /> FCFA
                                </c:when>
                                <c:otherwise>0 FCFA</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">Ventes Aujourd'hui</p>
                        <small class="opacity-75">
                            <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy"/>
                        </small>
                    </div>
                    <i class="bi bi-cash-coin stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1" data-stat-value="${monthSales}">
                            <c:choose>
                                <c:when test="${not empty monthSales}">
                                    <fmt:formatNumber value="${monthSales}" pattern="#,##0" /> FCFA
                                </c:when>
                                <c:otherwise>0 FCFA</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">Ce Mois</p>
                        <small class="opacity-75">
                            <jsp:useBean id="now" class="java.util.Date"/>
                            <fmt:formatDate value="${now}" pattern="MMMM yyyy"/>
                        </small>
                    </div>
                    <i class="bi bi-calendar-week stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1" data-stat-value="${totalTransactions}">
                            <c:choose>
                                <c:when test="${not empty totalTransactions}">${totalTransactions}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">Transactions</p>
                        <small class="opacity-75">Total</small>
                    </div>
                    <i class="bi bi-receipt stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1" data-stat-value="${avgTicket}">
                            <c:choose>
                                <c:when test="${not empty avgTicket}">
                                    <fmt:formatNumber value="${avgTicket}" pattern="#,##0" /> FCFA
                                </c:when>
                                <c:otherwise>0 FCFA</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">Ticket Moyen</p>
                        <small class="opacity-75">Par transaction</small>
                    </div>
                    <i class="bi bi-graph-up stat-icon"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Filtres de recherche -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="modern-card p-4">
                <form action="${pageContext.request.contextPath}/sales" method="get" class="row g-3" id="filterForm">
                    <div class="col-md-3">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                                <i class="bi bi-search"></i>
                            </span>
                            <input type="text" class="form-control modern-input border-start-0"
                                   name="search" placeholder="Rechercher une vente..."
                                   value="${param.search}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" name="status">
                            <option value="">Tous les statuts</option>
                            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Complétée</option>
                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>En attente</option>
                            <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Annulée</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="date" class="form-control modern-input" name="date"
                               value="${param.date}">
                    </div>
                    <div class="col-md-3">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-modern btn-gradient-primary flex-grow-1">
                                <i class="bi bi-funnel me-2"></i>Filtrer
                            </button>
                            <a href="${pageContext.request.contextPath}/sales/export?format=pdf&search=${param.search}&status=${param.status}&date=${param.date}"
                               class="btn btn-outline-danger" title="Exporter PDF">
                                <i class="bi bi-file-earmark-pdf"></i>
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Tableau des ventes -->
    <div class="row">
        <div class="col-12">
            <div class="modern-card p-0">
                <div class="table-responsive">
                    <table class="table modern-table mb-0">
                        <thead>
                        <tr>
                            <th><i class="bi bi-hash me-2"></i>N° Vente</th>
                            <th><i class="bi bi-person me-2"></i>Client</th>
                            <th><i class="bi bi-box me-2"></i>Produits</th>
                            <th><i class="bi bi-cash me-2"></i>Montant</th>
                            <th><i class="bi bi-credit-card me-2"></i>Paiement</th>
                            <th><i class="bi bi-calendar me-2"></i>Date</th>
                            <th><i class="bi bi-info-circle me-2"></i>Statut</th>
                            <th class="text-center"><i class="bi bi-gear me-2"></i>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty sales}">
                                <tr>
                                    <td colspan="8" class="text-center py-5">
                                        <i class="bi bi-cart display-1 text-muted d-block mb-3"></i>
                                        <h5 class="text-muted">Aucune vente trouvée</h5>
                                        <a href="${pageContext.request.contextPath}/sales/create" class="btn btn-modern btn-gradient-primary mt-3">
                                            <i class="bi bi-plus-circle me-2"></i>Créer votre première vente
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="sale" items="${sales}">
                                    <tr>
                                        <td><strong>#${sale.saleId}</strong></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                                                    <i class="bi bi-person text-primary"></i>
                                                </div>
                                                <div>
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${not empty sale.customerName}">
                                                                ${sale.customerName}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Client non enregistré
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                    <br>
                                                    <small class="text-muted">
                                                        <c:if test="${not empty sale.customerPhone}">
                                                            <i class="bi bi-phone"></i> ${sale.customerPhone}
                                                        </c:if>
                                                    </small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${sale.totalItems > 0}">
                                                    ${sale.totalItems} article(s)
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <strong class="text-success">
                                                <fmt:formatNumber value="${sale.totalAmount}" pattern="#,##0" /> FCFA
                                            </strong>
                                            <c:if test="${sale.discountAmount > 0}">
                                                <br>
                                                <small class="text-danger">
                                                    -<fmt:formatNumber value="${sale.discountAmount}" pattern="#,##0" /> FCFA
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="badge badge-modern bg-info">
                                                <c:choose>
                                                    <c:when test="${sale.paymentMethod == 'cash'}">
                                                        <i class="bi bi-cash-coin me-1"></i>Espèces
                                                    </c:when>
                                                    <c:when test="${sale.paymentMethod == 'card'}">
                                                        <i class="bi bi-credit-card me-1"></i>Carte
                                                    </c:when>
                                                    <c:when test="${sale.paymentMethod == 'transfer'}">
                                                        <i class="bi bi-bank me-1"></i>Virement
                                                    </c:when>
                                                    <c:when test="${sale.paymentMethod == 'mobile_payment'}">
                                                        <i class="bi bi-phone me-1"></i>Mobile Money
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${sale.paymentMethod}
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty sale.saleDate}">
                                                    <fmt:formatDate value="${sale.saleDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${sale.paymentStatus == 'paid'}">
                                                    <span class="badge badge-modern bg-success">
                                                        <i class="bi bi-check-circle me-1"></i>Payée
                                                    </span>
                                                </c:when>
                                                <c:when test="${sale.paymentStatus == 'pending'}">
                                                    <span class="badge badge-modern bg-warning text-dark">
                                                        <i class="bi bi-clock me-1"></i>En attente
                                                    </span>
                                                </c:when>
                                                <c:when test="${sale.paymentStatus == 'refunded'}">
                                                    <span class="badge badge-modern bg-danger">
                                                        <i class="bi bi-x-circle me-1"></i>Remboursée
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-modern bg-secondary">
                                                            ${sale.paymentStatus}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a href="${pageContext.request.contextPath}/sales/view?id=${sale.saleId}"
                                                   class="btn btn-outline-info" title="Voir détails">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <button type="button" onclick="printInvoice(${sale.saleId})"
                                                        class="btn btn-outline-primary" title="Imprimer">
                                                    <i class="bi bi-printer"></i>
                                                </button>
                                                <c:if test="${sale.paymentStatus == 'pending'}">
                                                    <button type="button" onclick="completeSale(${sale.saleId})"
                                                            class="btn btn-outline-success" title="Marquer comme payée">
                                                        <i class="bi bi-check-circle"></i>
                                                    </button>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${not empty sales and not empty totalPages and totalPages > 1}">
                    <div class="p-4 border-top">
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="mb-0 text-muted">
                                Affichage de <strong>${sales.size()}</strong> ventes
                            </p>
                            <nav>
                                <ul class="pagination mb-0">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&status=${param.status}&date=${param.date}">
                                                Précédent
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="page">
                                        <c:choose>
                                            <c:when test="${page == currentPage}">
                                                <li class="page-item active">
                                                    <span class="page-link">${page}</span>
                                                </li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="page-item">
                                                    <a class="page-link" href="?page=${page}&search=${param.search}&status=${param.status}&date=${param.date}">
                                                            ${page}
                                                    </a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&status=${param.status}&date=${param.date}">
                                                Suivant
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    (function() {
        'use strict';

        // Variable globale pour suivre l'état
        let isInitialized = false;

        // ============================================
        // FONCTIONS MÉTIER
        // ============================================

        function printInvoice(saleId) {
            if (!saleId) {
                console.error('Sale ID is required');
                return;
            }

            const contextPath = '${pageContext.request.contextPath}';
            const url = contextPath + '/sales/view?id=' + saleId + '&print=true';
            const printWindow = window.open(url, '_blank', 'width=800,height=600');

            if (!printWindow) {
                alert('Veuillez autoriser les fenêtres pop-up pour imprimer la facture');
            }
        }

        function completeSale(saleId) {
            if (!saleId) {
                console.error('Sale ID is required');
                return;
            }

            if (confirm('Marquer cette vente comme payée ?')) {
                showLoadingIndicator();
                const contextPath = '${pageContext.request.contextPath}';
                window.location.href = contextPath + '/sales/complete?id=' + saleId;
            }
        }

        function showLoadingIndicator() {
            // Éviter les doublons
            hideLoadingIndicator();

            const indicator = document.createElement('div');
            indicator.id = 'loadingIndicator';
            indicator.className = 'position-fixed top-50 start-50 translate-middle';
            indicator.style.zIndex = '9999';
            indicator.innerHTML = '<div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">' +
                '<span class="visually-hidden">Chargement...</span></div>';
            document.body.appendChild(indicator);
        }

        function hideLoadingIndicator() {
            const indicator = document.getElementById('loadingIndicator');
            if (indicator && indicator.parentNode) {
                indicator.parentNode.removeChild(indicator);
            }
        }

        function setupAlertAutoDismiss() {
            const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');

            alerts.forEach(function(alert) {
                setTimeout(function() {
                    if (alert && alert.parentNode && typeof bootstrap !== 'undefined') {
                        try {
                            const bsAlert = new bootstrap.Alert(alert);
                            bsAlert.close();
                        } catch (e) {
                            console.error('Error dismissing alert:', e);
                        }
                    }
                }, 5000);
            });
        }

        function initializeTooltips() {
            if (typeof bootstrap === 'undefined') return;

            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
            tooltipTriggerList.forEach(function(tooltipTriggerEl) {
                try {
                    new bootstrap.Tooltip(tooltipTriggerEl);
                } catch (e) {
                    console.error('Error initializing tooltip:', e);
                }
            });
        }

        function setupFilterForm() {
            const filterForm = document.getElementById('filterForm');

            if (filterForm) {
                filterForm.addEventListener('submit', function() {
                    const inputs = this.querySelectorAll('input, select');
                    inputs.forEach(function(input) {
                        if (!input.value || input.value.trim() === '') {
                            input.disabled = true;
                        }
                    });
                });
            }
        }

        function setupKeyboardShortcuts() {
            document.addEventListener('keydown', function(e) {
                // Ctrl+N : Nouvelle vente
                if ((e.ctrlKey || e.metaKey) && e.key === 'n') {
                    e.preventDefault();
                    const contextPath = '${pageContext.request.contextPath}';
                    window.location.href = contextPath + '/sales/create';
                }

                // Ctrl+F : Focus sur recherche
                if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
                    e.preventDefault();
                    const searchInput = document.querySelector('input[name="search"]');
                    if (searchInput) {
                        searchInput.focus();
                        searchInput.select();
                    }
                }
            });
        }

        function animateStats() {
            const statCards = document.querySelectorAll('.stat-card h3[data-stat-value]');

            statCards.forEach(function(stat) {
                const value = stat.getAttribute('data-stat-value');
                if (value && !isNaN(parseFloat(value))) {
                    const finalValue = parseFloat(value);
                    if (finalValue > 0) {
                        animateValue(stat, 0, finalValue, 1000);
                    }
                }
            });
        }

        function animateValue(element, start, end, duration) {
            const startTimestamp = Date.now();

            function step() {
                const now = Date.now();
                const progress = Math.min((now - startTimestamp) / duration, 1);
                const currentValue = Math.floor(progress * (end - start) + start);

                const formattedValue = new Intl.NumberFormat('fr-FR').format(currentValue);
                const text = element.textContent;
                const newText = text.replace(/[\d,]+/, formattedValue);
                element.textContent = newText;

                if (progress < 1) {
                    requestAnimationFrame(step);
                }
            }

            requestAnimationFrame(step);
        }

        // ============================================
        // NETTOYAGE
        // ============================================

        function cleanup() {
            hideLoadingIndicator();

            // Nettoyer les tooltips
            if (typeof bootstrap !== 'undefined') {
                const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
                tooltips.forEach(function(el) {
                    try {
                        const tooltip = bootstrap.Tooltip.getInstance(el);
                        if (tooltip) {
                            tooltip.dispose();
                        }
                    } catch (e) {
                        console.error('Error disposing tooltip:', e);
                    }
                });
            }

            isInitialized = false;
        }

        // ============================================
        // INITIALISATION
        // ============================================

        function initialize() {
            // Éviter la double initialisation
            if (isInitialized) {
                console.log('Already initialized, skipping...');
                return;
            }

            console.log('Initializing sales list page...');

            try {
                // Marquer comme initialisé
                isInitialized = true;

                // Nettoyer d'abord
                cleanup();

                // Initialiser les fonctionnalités
                setupAlertAutoDismiss();
                initializeTooltips();
                setupFilterForm();
                setupKeyboardShortcuts();

                // Animer les stats avec un délai
                setTimeout(animateStats, 100);

                // Masquer l'indicateur de chargement
                hideLoadingIndicator();

                console.log('Sales list page initialized successfully');
            } catch (e) {
                console.error('Error during initialization:', e);
                isInitialized = false;
            }
        }

        // ============================================
        // EXPOSER LES FONCTIONS NÉCESSAIRES
        // ============================================

        window.printInvoice = printInvoice;
        window.completeSale = completeSale;

        // ============================================
        // LANCEMENT
        // ============================================

        // Nettoyer au déchargement
        window.addEventListener('beforeunload', cleanup);
        window.addEventListener('pagehide', cleanup);

        // Initialiser au chargement du DOM
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initialize);
        } else {
            // DOM déjà chargé
            initialize();
        }

    })();
</script>

<style>
    /* Styles supplémentaires pour améliorer l'UX */

    .stat-card {
        border-radius: 15px;
        padding: 1.5rem;
        color: white;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
    }

    .stat-icon {
        font-size: 3rem;
        opacity: 0.3;
    }

    .modern-card {
        border-radius: 15px;
        border: 1px solid #e9ecef;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        transition: box-shadow 0.3s ease;
    }

    .modern-card:hover {
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    }

    .modern-input {
        border: 2px solid #e9ecef;
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .modern-input:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .btn-modern {
        border-radius: 10px;
        font-weight: 600;
        padding: 0.5rem 1.5rem;
        transition: all 0.3s ease;
    }

    .btn-gradient-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        color: white;
    }

    .btn-gradient-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        color: white;
    }

    .badge-modern {
        padding: 0.5rem 0.75rem;
        border-radius: 8px;
        font-weight: 500;
    }

    .modern-table {
        border-collapse: separate;
        border-spacing: 0;
    }

    .modern-table thead th {
        background-color: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
        padding: 1rem;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.85rem;
        letter-spacing: 0.5px;
    }

    .modern-table tbody tr {
        transition: all 0.3s ease;
    }

    .modern-table tbody tr:hover {
        background-color: #f8f9fa;
    }

    .modern-table td {
        padding: 1rem;
        vertical-align: middle;
        border-bottom: 1px solid #f0f0f0;
    }

    /* Animation de chargement */
    #loadingIndicator {
        background-color: rgba(255, 255, 255, 0.95);
        padding: 2rem;
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
    }

    /* Animation d'entrée pour les alertes */
    .alert {
        animation: slideInDown 0.3s ease-out;
    }

    @keyframes slideInDown {
        from {
            transform: translateY(-100%);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }

    /* Style pour les boutons d'action */
    .btn-group-sm .btn {
        padding: 0.375rem 0.75rem;
        transition: all 0.2s ease;
    }

    .btn-group-sm .btn:hover {
        transform: scale(1.1);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .stat-card {
            margin-bottom: 1rem;
        }

        .modern-table {
            font-size: 0.875rem;
        }

        .modern-table td {
            padding: 0.75rem 0.5rem;
        }
    }

    /* Animation pour les statistiques */
    .stat-card h3 {
        transition: color 0.3s ease;
    }

    .stat-card:hover h3 {
        color: rgba(255, 255, 255, 0.9);
    }

    /* Style pour les badges de statut */
    .badge-modern {
        transition: all 0.2s ease;
    }

    .badge-modern:hover {
        transform: scale(1.05);
    }

    /* Amélioration de la pagination */
    .pagination .page-link {
        border-radius: 8px;
        margin: 0 0.25rem;
        border: 1px solid #dee2e6;
        color: #667eea;
        transition: all 0.2s ease;
    }

    .pagination .page-link:hover {
        background-color: #667eea;
        color: white;
        transform: translateY(-2px);
    }

    .pagination .page-item.active .page-link {
        background-color: #667eea;
        border-color: #667eea;
    }

    /* Style pour le formulaire de recherche */
    .input-group-text {
        background-color: transparent !important;
    }

    .form-control:focus + .input-group-text,
    .input-group-text + .form-control:focus {
        border-color: #667eea;
    }
</style>