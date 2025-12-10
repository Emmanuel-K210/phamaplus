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
                        <i class="bi bi-boxes text-primary me-2"></i>Gestion d'Inventaire
                    </h2>
                    <p class="text-muted mb-0">
                        <c:choose>
                            <c:when test="${not empty title}">
                                ${title}
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-layers me-1"></i>
                                <c:choose>
                                    <c:when test="${not empty totalItems}">${totalItems}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                                lots en inventaire
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/inventory/add" class="btn btn-modern btn-gradient-primary">
                    <i class="bi bi-plus-circle me-2"></i>Nouveau Lot
                </a>
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

    <!-- Filtres rapides -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/inventory" class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-1">
                                <c:choose>
                                    <c:when test="${not empty totalItems}">${totalItems}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h4>
                            <p class="mb-0 opacity-75">Tous les Lots</p>
                        </div>
                        <i class="bi bi-boxes stat-icon"></i>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/inventory?filter=expiring" class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-1">
                                <c:choose>
                                    <c:when test="${not empty expiringCount}">${expiringCount}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h4>
                            <p class="mb-0 opacity-75">Expire bientôt</p>
                        </div>
                        <i class="bi bi-calendar-x stat-icon"></i>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/inventory?filter=expired" class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-1">
                                <c:choose>
                                    <c:when test="${not empty expiredCount}">${expiredCount}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h4>
                            <p class="mb-0 opacity-75">Expirés</p>
                        </div>
                        <i class="bi bi-ban stat-icon"></i>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="${pageContext.request.contextPath}/inventory?filter=lowstock" class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-1">
                                <c:choose>
                                    <c:when test="${not empty lowStockCount}">${lowStockCount}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h4>
                            <p class="mb-0 opacity-75">Stock Faible</p>
                        </div>
                        <i class="bi bi-arrow-down-circle stat-icon"></i>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <!-- Barre de recherche et filtres -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="modern-card p-4">
                <form action="${pageContext.request.contextPath}/inventory" method="get" class="row g-3">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                                <i class="bi bi-search"></i>
                            </span>
                            <input type="text" class="form-control modern-input border-start-0"
                                   name="search" placeholder="Rechercher par produit ou n° lot..."
                                   value="${param.search}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" name="status">
                            <option value="">Tous les statuts</option>
                            <option value="normal" ${param.status == 'normal' ? 'selected' : ''}>Stock normal</option>
                            <option value="low" ${param.status == 'low' ? 'selected' : ''}>Stock faible</option>
                            <option value="expiring" ${param.status == 'expiring' ? 'selected' : ''}>Expire bientôt</option>
                            <option value="expired" ${param.status == 'expired' ? 'selected' : ''}>Expiré</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" name="product">
                            <option value="">Tous les produits</option>
                            <!-- Vous devez charger la liste des produits depuis votre Servlet -->
                            <c:forEach var="product" items="${products}">
                                <option value="${product.productId}" ${param.product == product.productId ? 'selected' : ''}>
                                        ${product.productName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-modern btn-gradient-primary w-100">
                            <i class="bi bi-funnel me-2"></i>Filtrer
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Tableau d'inventaire -->
    <div class="row">
        <div class="col-12">
            <div class="modern-card p-0">
                <div class="table-responsive">
                    <table class="table modern-table mb-0">
                        <thead>
                        <tr>
                            <th><i class="bi bi-hash me-2"></i>ID</th>
                            <th><i class="bi bi-box me-2"></i>Produit</th>
                            <th><i class="bi bi-upc me-2"></i>N° Lot</th>
                            <th><i class="bi bi-boxes me-2"></i>Quantité</th>
                            <th><i class="bi bi-calendar-event me-2"></i>Fabrication</th>
                            <th><i class="bi bi-calendar-x me-2"></i>Expiration</th>
                            <th><i class="bi bi-geo-alt me-2"></i>Emplacement</th>
                            <th><i class="bi bi-info-circle me-2"></i>Statut</th>
                            <th class="text-center"><i class="bi bi-gear me-2"></i>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty inventoryList}">
                                <tr>
                                    <td colspan="9" class="text-center py-5">
                                        <i class="bi bi-inbox display-1 text-muted d-block mb-3"></i>
                                        <h5 class="text-muted">Aucun lot en inventaire</h5>
                                        <a href="${pageContext.request.contextPath}/inventory/add"
                                           class="btn btn-modern btn-gradient-primary mt-3">
                                            <i class="bi bi-plus-circle me-2"></i>Ajouter votre premier lot
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${inventoryList}">
                                    <tr>
                                        <td><strong>#${item.inventoryId}</strong></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                                                    <i class="bi bi-capsule text-primary"></i>
                                                </div>
                                                <div>
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${not empty item.productName}">
                                                                ${item.productName}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Produit #${item.productId}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                    <c:if test="${not empty item.supplierName}">
                                                        <br>
                                                        <small class="text-muted">
                                                            <i class="bi bi-truck"></i> ${item.supplierName}
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge badge-modern bg-secondary">
                                                    ${item.batchNumber}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex flex-column">
                                                <c:choose>
                                                    <c:when test="${item.quantityInStock < 10}">
                                                        <span class="badge badge-modern bg-danger">
                                                            <i class="bi bi-exclamation-triangle me-1"></i>
                                                            ${item.quantityInStock} unités
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${item.quantityInStock < 50}">
                                                        <span class="badge badge-modern bg-warning text-dark">
                                                            <i class="bi bi-exclamation-circle me-1"></i>
                                                            ${item.quantityInStock} unités
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-modern bg-success">
                                                            <i class="bi bi-check-circle me-1"></i>
                                                            ${item.quantityInStock} unités
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${item.quantityReserved > 0}">
                                                    <small class="text-muted mt-1">
                                                        <i class="bi bi-lock"></i> Réservé: ${item.quantityReserved}
                                                    </small>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.manufacturingDate}">
                                                    ${item.manufacturingDate}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.expiryDate}">
                                                    <!-- Pour calculer si c'est expiré, vous avez besoin de le faire dans votre Servlet -->
                                                    <c:set var="today" value="<%= java.time.LocalDate.now() %>" />
                                                    <c:set var="isExpired" value="${item.expiryDate.isBefore(today)}" />
                                                    <c:set var="daysUntil" value="${item.expiryDate.until(today).getDays()}" />

                                                    <c:choose>
                                                        <c:when test="${isExpired}">
                                                            <span class="text-danger fw-bold">
                                                                <i class="bi bi-x-circle me-1"></i>
                                                                ${item.expiryDate}
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${daysUntil <= 60}">
                                                            <span class="text-warning fw-bold">
                                                                <i class="bi bi-exclamation-triangle me-1"></i>
                                                                ${item.expiryDate}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${item.expiryDate}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <i class="bi bi-geo-alt-fill text-muted me-1"></i>
                                            <c:choose>
                                                <c:when test="${not empty item.location}">
                                                    ${item.location}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Non spécifié</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.isExpired}">
                                                    <span class="badge badge-modern bg-danger">
                                                        <i class="bi bi-ban me-1"></i>Expiré
                                                    </span>
                                                </c:when>
                                                <c:when test="${item.quantityInStock <= 0}">
                                                    <span class="badge badge-modern bg-danger">
                                                        <i class="bi bi-box me-1"></i>Épuisé
                                                    </span>
                                                </c:when>
                                                <c:when test="${item.quantityInStock < 10}">
                                                    <span class="badge badge-modern bg-warning text-dark">
                                                        <i class="bi bi-graph-down me-1"></i>Stock bas
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-modern bg-success">
                                                        <i class="bi bi-check-circle me-1"></i>Disponible
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a href="${pageContext.request.contextPath}/inventory/view?id=${item.inventoryId}"
                                                   class="btn btn-outline-info" title="Voir détails">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/inventory/edit?id=${item.inventoryId}"
                                                   class="btn btn-outline-primary" title="Modifier">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <button type="button" class="btn btn-outline-danger"
                                                        onclick="confirmDelete(${item.inventoryId})" title="Supprimer">
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

                <!-- Pagination -->
                <c:if test="${not empty inventoryList and not empty totalPages and totalPages > 1}">
                    <div class="p-4 border-top">
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="mb-0 text-muted">
                                Affichage de <strong>${inventoryList.size()}</strong> lots sur <strong>${totalItems}</strong>
                            </p>
                            <nav>
                                <ul class="pagination mb-0">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&status=${param.status}&product=${param.product}">
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
                                                    <a class="page-link" href="?page=${page}&search=${param.search}&status=${param.status}&product=${param.product}">
                                                            ${page}
                                                    </a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&status=${param.status}&product=${param.product}">
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
    function confirmDelete(id) {
        if (confirm('Êtes-vous sûr de vouloir supprimer ce lot ?')) {
            window.location.href = '${pageContext.request.contextPath}/inventory/delete?id=' + id;
        }
    }

    function adjustStock(inventoryId, action) {
        const amount = prompt('Quantité à ' + (action === 'add' ? 'ajouter' : 'retirer') + ' :');
        if (amount && !isNaN(amount) && amount > 0) {
            window.location.href = '${pageContext.request.contextPath}/inventory/adjust?id=' + inventoryId +
                '&action=' + action + '&amount=' + amount;
        }
    }
</script>