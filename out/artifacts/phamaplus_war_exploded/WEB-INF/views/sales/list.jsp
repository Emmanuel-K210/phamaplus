<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    // Récupérer la date du jour en format ISO
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String today = sdf.format(new java.util.Date());
%>
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
            <strong>Succès !</strong> ${fn:escapeXml(successMessage)}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show modern-card mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <strong>Erreur !</strong> ${fn:escapeXml(errorMessage)}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>


    <!-- Statistiques rapides -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <!-- CORRECTION : todaySales au lieu de todaySalesFormatted -->
                        <h3 class="mb-1" data-stat-value="${todaySalesValue != null ? todaySalesValue : 0}">
                            <c:choose>
                                <c:when test="${not empty todaySalesValue}">
                                    <fmt:formatNumber value="${todaySalesValue}" pattern="#,##0"/>FCFA
                                </c:when>
                                <c:otherwise>
                                    0 FCFA
                                </c:otherwise>
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
                        <!-- CORRECTION : monthSales au lieu de monthSalesFormatted -->
                        <h3 class="mb-1" data-stat-value="${monthSalesValue != null ? monthSalesValue : 0}">
                            <c:choose>
                                <c:when test="${not empty monthSalesValue}">
                                    <fmt:formatNumber value="${monthSalesValue}" pattern="#,##0"/>F CFA
                                </c:when>
                                <c:otherwise>
                                    0 FCFA
                                </c:otherwise>
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
                        <!-- OK : totalTransactions est correct -->
                        <h3 class="mb-1" data-stat-value="${totalTransactions != null ? totalTransactions : 0}">
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
                        <!-- CORRECTION : avgTicket au lieu de avgTicketFormatted -->
                        <h3 class="mb-1" data-stat-value="${avgTicketValue != null ? avgTicketValue : 0}">
                            <c:choose>
                                <c:when test="${not empty avgTicketValue}">
                                    <fmt:formatNumber value="${avgTicketValue}" pattern="#,##0"/>F CFA
                                </c:when>
                                <c:otherwise>
                                    0 FCFA
                                </c:otherwise>
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
                                   value="${fn:escapeXml(param.search)}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" name="status">
                            <option value="">Tous les statuts</option>
                            <option value="paid" ${param.status == 'paid' ? 'selected' : ''}>Payée</option>
                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>En attente</option>
                            <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Annulée</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="date" class="form-control modern-input" name="date"
                               value="${fn:escapeXml(param.date)}">
                    </div>
                    <div class="col-md-3">
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-modern btn-gradient-primary flex-grow-1">
                                <i class="bi bi-funnel me-2"></i>Filtrer
                            </button>

                           <!-- <a href="${pageContext.request.contextPath}/sales/export?format=pdf&search=${param.search}&status=${param.status}&date=${today}"
                               class="btn btn-outline-danger" title="Exporter PDF" onclick="exportToPDF(event)"
                               id="exportPDFBtn">
                                <i class="bi bi-file-earmark-pdf"></i>
                            </a>-->
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
                    <table class="table modern-table mb-0" aria-label="Liste des ventes" role="grid">
                        <caption class="visually-hidden">Tableau des ventes récentes</caption>
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
                                    <tr data-sale-id="${sale.saleId}" onclick="viewSale(${sale.saleId})" style="cursor: pointer;">
                                        <td><strong>#${sale.saleId}</strong></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                                                    <i class="bi bi-person text-primary"></i>
                                                </div>
                                                <div>
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${not empty sale.customerName and sale.customerName != ''}">
                                                                ${fn:escapeXml(sale.customerName)}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Client non enregistré
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                    <br>
                                                    <small class="text-muted">
                                                        <c:if test="${not empty sale.customerPhone and sale.customerPhone != ''}">
                                                            <i class="bi bi-phone"></i> ${fn:escapeXml(sale.customerPhone)}
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
                                                        ${fn:escapeXml(sale.paymentMethod)}
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
                                                <c:when test="${sale.paymentStatus == 'cancelled'}">
                                                    <span class="badge badge-modern bg-danger">
                                                        <i class="bi bi-x-circle me-1"></i>Annulée
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-modern bg-secondary">
                                                            ${fn:escapeXml(sale.paymentStatus)}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <a href="${pageContext.request.contextPath}/sales/view?id=${sale.saleId}"
                                                   class="btn btn-outline-primary">
                                                    <i class="bi bi-eye"></i> Voir
                                                </a>
                                                <!-- Impression thermique directe depuis la liste -->
                                                <a href="${pageContext.request.contextPath}/sales/thermal-ticket?id=${sale.saleId}"
                                                   class="btn btn-outline-success" target="_blank">
                                                    <i class="bi bi-receipt"></i>Ticket
                                                </a>
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
                <c:if test="${not empty sales and totalPages > 1}">
                    <div class="p-4 border-top">
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="mb-0 text-muted">
                                Affichage de <strong>${sales.size()}</strong> ventes sur <strong>${totalSales}</strong>
                            </p>
                            <nav aria-label="Navigation des pages">
                                <ul class="pagination mb-0">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&search=${fn:escapeXml(param.search)}&status=${fn:escapeXml(param.status)}&date=${fn:escapeXml(param.date)}"
                                               aria-label="Page précédente">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="page">
                                        <c:choose>
                                            <c:when test="${page == currentPage}">
                                                <li class="page-item active" aria-current="page">
                                                    <span class="page-link">${page}</span>
                                                </li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="page-item">
                                                    <a class="page-link" href="?page=${page}&search=${fn:escapeXml(param.search)}&status=${fn:escapeXml(param.status)}&date=${fn:escapeXml(param.date)}">
                                                            ${page}
                                                    </a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&search=${fn:escapeXml(param.search)}&status=${fn:escapeXml(param.status)}&date=${fn:escapeXml(param.date)}"
                                               aria-label="Page suivante">
                                                <span aria-hidden="true">&raquo;</span>
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

        const SalesManager = {
            isInitialized: false,
            contextPath: '${pageContext.request.contextPath}',

            init: function() {
                if (this.isInitialized) return;

                this.setupAlertAutoDismiss();
                this.initializeTooltips();
                this.setupFilterForm();
                this.setupKeyboardShortcuts();
                this.setupRowClick();

                this.isInitialized = true;
                console.log('SalesManager initialized');
            },

            printInvoice: function(saleId) {
                if (!saleId) {
                    console.error('Sale ID is required');
                    this.showAlert('Erreur', 'ID de vente manquant', 'error');
                    return;
                }

                const url = this.contextPath + '/sales/view?id=' + saleId + '&print=true';
                const printWindow = window.open(url, '_blank', 'width=800,height=600');

                if (!printWindow) {
                    this.showAlert('Attention', 'Veuillez autoriser les fenêtres pop-up pour imprimer la facture', 'warning');
                }
            },

            completeSale: function(saleId, event) {
                if (event) event.stopPropagation();

                if (!saleId) {
                    console.error('Sale ID is required');
                    return;
                }

                if (confirm('Êtes-vous sûr de vouloir marquer cette vente comme payée ?')) {
                    this.showLoading();
                    window.location.href = this.contextPath + '/sales/complete?id=' + saleId;
                }
            },

            viewSale: function(saleId) {
                if (saleId) {
                    window.location.href = this.contextPath + '/sales/view?id=' + saleId;
                }
            },

            showLoading: function() {
                this.hideLoading();

                const indicator = document.createElement('div');
                indicator.id = 'loadingIndicator';
                indicator.className = 'position-fixed top-50 start-50 translate-middle';
                indicator.style.zIndex = '9999';
                indicator.innerHTML = '<div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">' +
                    '<span class="visually-hidden">Chargement...</span></div>';
                document.body.appendChild(indicator);
            },

            hideLoading: function() {
                const indicator = document.getElementById('loadingIndicator');
                if (indicator && indicator.parentNode) {
                    indicator.parentNode.removeChild(indicator);
                }
            },

            showAlert: function(title, message, type) {
                const alertClass = type === 'error' ? 'alert-danger' :
                    type === 'warning' ? 'alert-warning' : 'alert-info';

                const alertDiv = document.createElement('div');
                alertDiv.className = `alert ${alertClass} alert-dismissible fade show`;
                alertDiv.innerHTML = `
                    <strong>${title}</strong> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;

                const container = document.querySelector('.container-fluid');
                if (container) {
                    container.insertBefore(alertDiv, container.firstChild);

                    setTimeout(() => {
                        if (alertDiv.parentNode) {
                            const bsAlert = new bootstrap.Alert(alertDiv);
                            bsAlert.close();
                        }
                    }, 5000);
                }
            },

            setupAlertAutoDismiss: function() {
                const alerts = document.querySelectorAll('.alert[data-auto-dismiss="true"]');

                alerts.forEach((alert) => {
                    setTimeout(() => {
                        if (alert && alert.parentNode && typeof bootstrap !== 'undefined') {
                            try {
                                const bsAlert = bootstrap.Alert.getInstance(alert) || new bootstrap.Alert(alert);
                                bsAlert.close();
                            } catch (e) {
                                console.error('Error dismissing alert:', e);
                            }
                        }
                    }, 5000);
                });
            },

            initializeTooltips: function() {
                if (typeof bootstrap === 'undefined') return;

                const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
                tooltipTriggerList.forEach((tooltipTriggerEl) => {
                    try {
                        new bootstrap.Tooltip(tooltipTriggerEl);
                    } catch (e) {
                        console.error('Error initializing tooltip:', e);
                    }
                });
            },

            setupFilterForm: function() {
                const filterForm = document.getElementById('filterForm');

                if (filterForm) {
                    filterForm.addEventListener('submit', function(e) {
                        const dateInput = this.querySelector('input[name="date"]');
                        if (dateInput && dateInput.value) {
                            const selectedDate = new Date(dateInput.value);
                            const today = new Date();
                            today.setHours(0, 0, 0, 0);

                            if (selectedDate > today) {
                                e.preventDefault();
                                alert('La date ne peut pas être dans le futur');
                                dateInput.focus();
                                return false;
                            }
                        }

                        const inputs = this.querySelectorAll('input, select');
                        inputs.forEach(function(input) {
                            if (!input.value || input.value.trim() === '') {
                                input.disabled = true;
                            }
                        });

                        return true;
                    });
                }
            },

            setupKeyboardShortcuts: function() {
                document.addEventListener('keydown', (e) => {
                    if ((e.ctrlKey || e.metaKey) && e.key === 'n') {
                        e.preventDefault();
                        window.location.href = this.contextPath + '/sales/create';
                    }

                    if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
                        e.preventDefault();
                        const searchInput = document.querySelector('input[name="search"]');
                        if (searchInput) {
                            searchInput.focus();
                            searchInput.select();
                        }
                    }

                    if (e.key === 'Escape') {
                        const searchInput = document.querySelector('input[name="search"]');
                        if (searchInput && document.activeElement === searchInput) {
                            searchInput.value = '';
                            searchInput.blur();
                        }
                    }
                });
            },

            setupRowClick: function() {
                const rows = document.querySelectorAll('tbody tr[data-sale-id]');
                rows.forEach(row => {
                    row.addEventListener('click', (e) => {
                        if (!e.target.closest('.btn-group')) {
                            const saleId = row.getAttribute('data-sale-id');
                            this.viewSale(saleId);
                        }
                    });
                });
            },

            exportToPDF: function(e) {
                e.preventDefault();
                const link = e.currentTarget;
                const url = link.href;

                this.showLoading();

                fetch(url)
                    .then(response => {
                        if (response.ok) {
                            return response.blob();
                        }
                        throw new Error('Export failed');
                    })
                    .then(blob => {
                        const downloadUrl = window.URL.createObjectURL(blob);
                        const a = document.createElement('a');
                        a.href = downloadUrl;

                        // Générer le nom de fichier avec la date du jour
                        const today = new Date();
                        const yearJs = today.getFullYear();
                        const monthJs = String(today.getMonth() + 1).padStart(2, '0');
                        const dayJs = String(today.getDate()).padStart(2, '0');
                        const filenameJs = `ventes_${yearJs}-${monthJs}-${dayJs}.pdf`;

                        a.download = filenameJs;
                        document.body.appendChild(a);
                        a.click();
                        window.URL.revokeObjectURL(downloadUrl);
                        document.body.removeChild(a);
                    })
                    .catch(error => {
                        console.error('Export error:', error);
                        this.showAlert('Erreur', 'Échec de l\'export PDF', 'error');
                    })
                    .finally(() => this.hideLoading());
            },

            refreshStats: function() {
                fetch(this.contextPath + '/sales/api/stats')
                    .then(response => response.json())
                    .catch(error => console.error('Stats refresh error:', error));
            },

            cleanup: function() {
                this.hideLoading();
                this.isInitialized = false;

                if (typeof bootstrap !== 'undefined') {
                    const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
                    tooltips.forEach((el) => {
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
            }
        };

        window.printInvoice = SalesManager.printInvoice.bind(SalesManager);
        window.completeSale = SalesManager.completeSale.bind(SalesManager);
        window.viewSale = SalesManager.viewSale.bind(SalesManager);
        window.exportToPDF = SalesManager.exportToPDF.bind(SalesManager);

        window.addEventListener('beforeunload', () => SalesManager.cleanup());
        window.addEventListener('pagehide', () => SalesManager.cleanup());

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => SalesManager.init());
        } else {
            SalesManager.init();
        }

        setInterval(() => SalesManager.refreshStats(), 30000);

    })();
</script>

<style>
    .stat-card {
        border-radius: 15px;
        padding: 1.5rem;
        color: white;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        min-height: 120px;
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
        background-color: white;
    }

    .modern-card:hover {
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    }

    .modern-input {
        border: 2px solid #e9ecef;
        border-radius: 8px;
        transition: all 0.3s ease;
        padding: 0.75rem 1rem;
    }

    .modern-input:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        outline: none;
    }

    .btn-modern {
        border-radius: 10px;
        font-weight: 600;
        padding: 0.75rem 1.5rem;
        transition: all 0.3s ease;
        border: none;
    }

    .btn-gradient-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        font-size: 0.875rem;
    }

    .modern-table {
        border-collapse: separate;
        border-spacing: 0;
        width: 100%;
    }

    .modern-table thead th {
        background-color: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
        padding: 1rem;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.85rem;
        letter-spacing: 0.5px;
        position: sticky;
        top: 0;
        z-index: 10;
    }

    .modern-table tbody tr {
        transition: all 0.3s ease;
    }

    .modern-table tbody tr:hover {
        background-color: #f8f9fa;
    }

    .modern-table tbody tr[data-sale-id]:hover {
        background-color: #f0f7ff;
        cursor: pointer;
    }

    .modern-table td {
        padding: 1rem;
        vertical-align: middle;
        border-bottom: 1px solid #f0f0f0;
    }

    #loadingIndicator {
        background-color: rgba(255, 255, 255, 0.95);
        padding: 2rem;
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
    }

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

    .btn-group-sm .btn {
        padding: 0.375rem 0.75rem;
        transition: all 0.2s ease;
        border-radius: 6px;
    }

    .btn-group-sm .btn:hover {
        transform: scale(1.1);
    }

    @media (max-width: 768px) {
        .stat-card {
            margin-bottom: 1rem;
            padding: 1rem;
        }

        .stat-icon {
            font-size: 2rem;
        }

        .modern-table {
            font-size: 0.875rem;
        }

        .modern-table td, .modern-table th {
            padding: 0.75rem 0.5rem;
        }

        .btn-group-sm .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }

        .btn-modern {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }
    }

    .pagination .page-link {
        border-radius: 8px;
        margin: 0 0.25rem;
        border: 1px solid #dee2e6;
        color: #667eea;
        transition: all 0.2s ease;
        padding: 0.5rem 0.75rem;
    }

    .pagination .page-link:hover {
        background-color: #667eea;
        color: white;
        transform: translateY(-2px);
        border-color: #667eea;
    }

    .pagination .page-item.active .page-link {
        background-color: #667eea;
        border-color: #667eea;
        color: white;
    }

    .input-group-text {
        background-color: transparent !important;
        border-right: none;
    }

    .input-group .form-control {
        border-left: none;
    }

    .input-group .form-control:focus {
        border-left: 2px solid #667eea;
    }

    @keyframes highlightChange {
        0% { background-color: #e7f4e4; }
        100% { background-color: transparent; }
    }

    .text-success {
        color: #28a745 !important;
    }

    .text-danger {
        color: #dc3545 !important;
    }

    .bg-success {
        background-color: #28a745 !important;
    }

    .bg-warning {
        background-color: #ffc107 !important;
    }

    .bg-danger {
        background-color: #dc3545 !important;
    }

    .bg-info {
        background-color: #17a2b8 !important;
    }
</style>