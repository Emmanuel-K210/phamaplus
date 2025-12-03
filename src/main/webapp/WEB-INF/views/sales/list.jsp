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
                        <h3 class="mb-1">
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
                        <h3 class="mb-1">
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
                        <h3 class="mb-1">
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
                        <h3 class="mb-1">
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
                <form action="${pageContext.request.contextPath}/sales" method="get" class="row g-3">
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
                                                <c:when test="${sale.itemsCount > 0}">
                                                    ${sale.itemsCount} article(s)
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Détails non disponibles</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <strong class="text-success">
                                                <fmt:formatNumber value="${sale.totalAmount}" pattern="#,##0" /> FCFA
                                            </strong>
                                            <c:if test="${sale.discount > 0}">
                                                <br>
                                                <small class="text-danger">
                                                    -<fmt:formatNumber value="${sale.discount}" pattern="#,##0" /> FCFA
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="badge badge-modern bg-info">
                                                <c:choose>
                                                    <c:when test="${sale.paymentMethod == 'CASH'}">
                                                        <i class="bi bi-cash-coin me-1"></i>Espèces
                                                    </c:when>
                                                    <c:when test="${sale.paymentMethod == 'CARD'}">
                                                        <i class="bi bi-credit-card me-1"></i>Carte
                                                    </c:when>
                                                    <c:when test="${sale.paymentMethod == 'TRANSFER'}">
                                                        <i class="bi bi-bank me-1"></i>Virement
                                                    </c:when>
                                                    <c:when test="${sale.paymentMethod == 'MOBILE_MONEY'}">
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
                                                    ${sale.saleDate}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${sale.status == 'COMPLETED'}">
                                                    <span class="badge badge-modern bg-success">
                                                        <i class="bi bi-check-circle me-1"></i>Complétée
                                                    </span>
                                                </c:when>
                                                <c:when test="${sale.status == 'PENDING'}">
                                                    <span class="badge badge-modern bg-warning text-dark">
                                                        <i class="bi bi-clock me-1"></i>En attente
                                                    </span>
                                                </c:when>
                                                <c:when test="${sale.status == 'CANCELLED'}">
                                                    <span class="badge badge-modern bg-danger">
                                                        <i class="bi bi-x-circle me-1"></i>Annulée
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-modern bg-secondary">
                                                            ${sale.status}
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
                                                <a href="${pageContext.request.contextPath}/sales/invoice?id=${sale.saleId}"
                                                   class="btn btn-outline-primary" title="Facture">
                                                    <i class="bi bi-receipt"></i>
                                                </a>
                                                <c:if test="${sale.status == 'PENDING'}">
                                                    <a href="${pageContext.request.contextPath}/sales/edit?id=${sale.saleId}"
                                                       class="btn btn-outline-success" title="Modifier">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
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
    // Fonction pour imprimer une facture
    function printInvoice(saleId) {
        window.open('${pageContext.request.contextPath}/sales/invoice?id=' + saleId + '&print=true', '_blank');
    }

    // Fonction pour annuler une vente
    function cancelSale(saleId) {
        if (confirm('Êtes-vous sûr de vouloir annuler cette vente ?')) {
            window.location.href = '${pageContext.request.contextPath}/sales/cancel?id=' + saleId;
        }
    }

    // Fonction pour compléter une vente en attente
    function completeSale(saleId) {
        if (confirm('Marquer cette vente comme complétée ?')) {
            window.location.href = '${pageContext.request.contextPath}/sales/complete?id=' + saleId;
        }
    }
</script>