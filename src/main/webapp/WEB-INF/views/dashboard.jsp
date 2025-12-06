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
                        <i class="bi bi-speedometer2 text-primary me-2"></i>
                        Bonjour, <c:out value="${sessionScope.fullName}"/> 👋
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-calendar3 me-2"></i>
                        <jsp:useBean id="now" class="java.util.Date"/>
                        <fmt:formatDate value="${now}" pattern="EEEE dd MMMM yyyy"/>
                    </p>
                </div>
                <div>
                    <a class="btn btn-modern btn-gradient-primary" href="${pageContext.request.contextPath}/sales/new">
                        <i class="bi bi-plus-circle me-2"></i>Nouvelle Vente
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Cartes statistiques principales -->
    <div class="row g-4 mb-4">
        <!-- Ventes Aujourd'hui -->
        <div class="col-xl-3 col-md-6">
            <div class="stat-card" style="background: var(--primary-gradient);">
                <div class="position-relative">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="mb-1 opacity-75">Ventes Aujourd'hui</p>
                            <h2 class="mb-0 fcfa-amount">
                                <c:choose>
                                    <c:when test="${not empty todaySummary.revenue}">
                                        <fmt:formatNumber value="${todaySummary.revenue}" pattern="#,##0.00"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="mt-2">
                                <span class="badge bg-white bg-opacity-25">
                                    <c:choose>
                                        <c:when test="${not empty todaySummary.transactions and todaySummary.transactions > 0}">
                                            <i class="bi bi-arrow-up me-1"></i>
                                            <c:out value="${todaySummary.transactions}"/> ventes
                                        </c:when>
                                        <c:otherwise>Aucune vente</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Produits en Stock -->
        <div class="col-xl-3 col-md-6">
            <div class="stat-card" style="background: var(--success-gradient);">
                <div class="position-relative">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="mb-1 opacity-75">Produits en Stock</p>
                            <h2 class="mb-0">
                                <c:choose>
                                    <c:when test="${not empty totalProducts}">
                                        <c:out value="${totalProducts}"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="mt-2">
                                <span class="badge bg-white bg-opacity-25">
                                    <c:choose>
                                        <c:when test="${not empty lowStockProducts and lowStockProducts == 0}">
                                            <i class="bi bi-check-circle me-1"></i>Normal
                                        </c:when>
                                        <c:when test="${not empty lowStockProducts and lowStockProducts > 0}">
                                            <i class="bi bi-exclamation-triangle me-1"></i>
                                            <c:out value="${lowStockProducts}"/> faible
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-check-circle me-1"></i>Normal
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-boxes"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Valeur Inventaire -->
        <div class="col-xl-3 col-md-6">
            <div class="stat-card" style="background: var(--warning-gradient);">
                <div class="position-relative">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="mb-1 opacity-75">Valeur Inventaire</p>
                            <h2 class="mb-0 fcfa-amount">
                                <c:choose>
                                    <c:when test="${not empty inventoryValue}">
                                        <fmt:formatNumber value="${inventoryValue}" pattern="#,##0"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="mt-2">
                                <span class="badge bg-white bg-opacity-25">
                                    <i class="bi bi-shield-check me-1"></i>Stock
                                </span>
                            </div>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-bar-chart"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Clients Actifs -->
        <div class="col-xl-3 col-md-6">
            <div class="stat-card" style="background: var(--info-gradient);">
                <div class="position-relative">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <p class="mb-1 opacity-75">Clients Actifs</p>
                            <h2 class="mb-0">
                                <c:choose>
                                    <c:when test="${not empty activeCustomers}">
                                        <c:out value="${activeCustomers}"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="mt-2">
                                <span class="badge bg-white bg-opacity-25">
                                    <c:choose>
                                        <c:when test="${not empty activeCustomers and activeCustomers > 0}">
                                            <i class="bi bi-arrow-up me-1"></i>Actif
                                        </c:when>
                                        <c:otherwise>Aucun client</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-people"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Alertes et Actions -->
    <div class="row g-4 mb-4">
        <!-- Alertes -->
        <div class="col-lg-4">
            <div class="modern-card p-4">
                <h5 class="mb-4">
                    <i class="bi bi-bell text-danger me-2"></i>
                    Alertes
                </h5>

                <c:if test="${not empty expiredProducts and expiredProducts > 0}">
                    <div class="alert alert-danger alert-card d-flex align-items-start mb-3">
                        <i class="bi bi-exclamation-triangle-fill fs-4 me-3"></i>
                        <div>
                            <strong><c:out value="${expiredProducts}"/> produits expirés</strong>
                            <p class="mb-0 small">Action requise immédiatement</p>
                            <a href="${pageContext.request.contextPath}/inventory?filter=expired"
                               class="btn btn-sm btn-danger mt-2">Voir détails</a>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty expiringSoon and expiringSoon > 0}">
                    <div class="alert alert-warning alert-card d-flex align-items-start mb-3">
                        <i class="bi bi-clock-fill fs-4 me-3"></i>
                        <div>
                            <strong><c:out value="${expiringSoon}"/> produits expirent bientôt</strong>
                            <p class="mb-0 small">Dans les 30 prochains jours</p>
                            <a href="${pageContext.request.contextPath}/inventory?filter=expiring"
                               class="btn btn-sm btn-warning mt-2">Voir détails</a>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty lowStockProducts and lowStockProducts > 0}">
                    <div class="alert alert-info alert-card d-flex align-items-start mb-0">
                        <i class="bi bi-info-circle-fill fs-4 me-3"></i>
                        <div>
                            <strong><c:out value="${lowStockProducts}"/> produits en stock faible</strong>
                            <p class="mb-0 small">Réapprovisionnement recommandé</p>
                            <a href="${pageContext.request.contextPath}/products?filter=lowstock"
                               class="btn btn-sm btn-info mt-2">Voir détails</a>
                        </div>
                    </div>
                </c:if>

                <c:if test="${(empty expiredProducts or expiredProducts == 0) and
                              (empty expiringSoon or expiringSoon == 0) and
                              (empty lowStockProducts or lowStockProducts == 0)}">
                    <div class="alert alert-success alert-card">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        Aucune alerte pour le moment
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Actions rapides -->
        <div class="col-lg-8">
            <div class="modern-card p-4 h-100">
                <h5 class="mb-4">
                    <i class="bi bi-lightning-charge text-warning me-2"></i>
                    Actions Rapides
                </h5>

                <div class="row g-3">
                    <div class="col-md-6">
                        <a href="${pageContext.request.contextPath}/products/add"
                           class="btn btn-modern btn-gradient-primary w-100 text-start quick-action">
                            <i class="bi bi-plus-circle me-2"></i>Ajouter un Produit
                        </a>
                    </div>
                    <div class="col-md-6">
                        <a href="${pageContext.request.contextPath}/inventory/add"
                           class="btn btn-modern btn-gradient-success w-100 text-start quick-action">
                            <i class="bi bi-box-seam me-2"></i>Nouveau Lot
                        </a>
                    </div>
                    <div class="col-md-6">
                        <a href="${pageContext.request.contextPath}/sales/new"
                           class="btn btn-modern btn-gradient-info w-100 text-start quick-action">
                            <i class="bi bi-cart-plus me-2"></i>Nouvelle Vente
                        </a>
                    </div>
                    <div class="col-md-6">
                        <a href="${pageContext.request.contextPath}/reports"
                           class="btn btn-modern btn-outline-primary w-100 text-start quick-action">
                            <i class="bi bi-file-earmark-text me-2"></i>Générer Rapport
                        </a>
                    </div>
                </div>

                <!-- Revenu mensuel -->
                <div class="mt-4 pt-4 border-top">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="mb-1 text-muted">Revenu du mois</p>
                            <h3 class="mb-0 text-success fcfa-amount">
                                <c:choose>
                                    <c:when test="${not empty monthlyRevenue}">
                                        <fmt:formatNumber value="${monthlyRevenue}" pattern="#,##0"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h3>
                        </div>
                        <div class="text-end">
                            <p class="mb-1 text-muted">Tendance</p>
                            <span class="badge bg-success bg-opacity-25 text-success">
                                <i class="bi bi-arrow-up me-1"></i>Mensuel
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Produits populaires et Ventes récentes -->
    <div class="row g-4">
        <!-- Top produits -->
        <div class="col-lg-6">
            <div class="modern-card p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="mb-0">
                        <i class="bi bi-trophy text-warning me-2"></i>
                        Produits Populaires
                    </h5>
                    <a href="${pageContext.request.contextPath}/reports?type=top-products"
                       class="text-decoration-none small">Voir tout <i class="bi bi-arrow-right"></i></a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Produit</th>
                            <th>Ventes</th>
                            <th>Revenus</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${not empty topProducts}">
                            <c:forEach var="product" items="${topProducts}" varStatus="status">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="me-3">
                                                <div class="bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center"
                                                     style="width: 35px; height: 35px;">
                                                    <strong>${status.index + 1}</strong>
                                                </div>
                                            </div>
                                            <div>
                                                <strong>${product[0]}</strong><br>
                                                <small class="text-muted">${product[1]}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty product[2]}">
                                                <strong>${product[2]}</strong> unités
                                            </c:when>
                                            <c:otherwise>0 unités</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-success fcfa-amount">
                                        <c:choose>
                                            <c:when test="${not empty product[3]}">
                                                ${product[3]}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>

                        <c:if test="${empty topProducts}">
                            <tr>
                                <td colspan="3" class="text-center text-muted py-3">
                                    <i class="bi bi-info-circle me-2"></i>
                                    Aucune donnée de vente disponible
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Ventes récentes -->
        <div class="col-lg-6">
            <div class="modern-card p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="mb-0">
                        <i class="bi bi-clock-history text-info me-2"></i>
                        Ventes Récentes
                    </h5>
                    <a href="${pageContext.request.contextPath}/sales"
                       class="text-decoration-none small">Voir toutes <i class="bi bi-arrow-right"></i></a>
                </div>

                <div class="table-responsive">
                    <table class="table modern-table mb-0">
                        <thead>
                        <tr>
                            <th>N° Vente</th>
                            <th>Client</th>
                            <th>Montant</th>
                            <th>Heure</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${not empty recentSales}">
                            <c:forEach var="sale" items="${recentSales}">
                                <tr>
                                    <td>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty sale.reference}">
                                                    #${sale.reference}
                                                </c:when>
                                                <c:otherwise>
                                                    #N/A
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty sale.customerName}">
                                                ${sale.customerName}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Client occasionnel</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-success fcfa-amount">
                                        <c:choose>
                                            <c:when test="${not empty sale.totalAmount}">
                                                ${sale.totalAmount}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty sale.saleDate}">
                                                <fmt:parseDate value="${sale.saleDate}" pattern="yyyy-MM-dd'T'HH:mm"
                                                               var="parsedDate" type="both"/>
                                                <fmt:formatDate value="${parsedDate}" pattern="HH:mm"/>
                                            </c:when>
                                            <c:otherwise>--:--</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>

                        <c:if test="${empty recentSales}">
                            <tr>
                                <td colspan="4" class="text-center text-muted py-3">
                                    <i class="bi bi-cart me-2"></i>
                                    Aucune vente récente
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Script pour les montants F CFA -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Formater tous les montants F CFA
        document.querySelectorAll('.fcfa-amount').forEach(function (element) {
            const text = element.textContent.trim();
            // Extraire le nombre du texte
            const match = text.match(/[\d,.]+/);
            const amount = match ? parseFloat(match[0].replace(/,/g, '')) : 0;

            if (!isNaN(amount) && amount > 0) {
                element.textContent = new Intl.NumberFormat('fr-FR').format(amount) + ' F CFA';
                element.classList.add('currency-fcfa');
            } else {
                element.textContent = '0 F CFA';
            }
        });
    });
</script>