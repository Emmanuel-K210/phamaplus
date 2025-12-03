<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    /* Styles supplémentaires pour la page produits */
    .stat-card {
        padding: 1.5rem;
        border-radius: 15px;
        color: white;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        transition: transform 0.3s;
    }

    .stat-card:hover {
        transform: translateY(-5px);
    }

    .stat-icon {
        font-size: 2.5rem;
        opacity: 0.9;
    }

    .badge-modern {
        padding: 0.4rem 0.8rem;
        border-radius: 50px;
        font-weight: 600;
        font-size: 0.85rem;
        border: none;
    }

    .badge-modern.bg-info {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%) !important;
        color: white !important;
    }

    .modern-table tbody tr {
        transition: all 0.2s;
    }

    .modern-table tbody tr:hover {
        background-color: rgba(102, 126, 234, 0.05);
    }

    .btn-group-sm .btn {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }

    /* Styles pour les badges de statut */
    .badge-modern.bg-success {
        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%) !important;
    }

    .badge-modern.bg-danger {
        background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%) !important;
    }

    .badge-modern.bg-secondary {
        background: linear-gradient(135deg, #868e96 0%, #495057 100%) !important;
    }
</style>
<div class="container-fluid">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-box-seam text-primary me-2"></i>Gestion des Produits
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-layers me-1"></i>
                        <c:choose>
                            <c:when test="${not empty totalProducts}">
                                ${totalProducts} produits au total
                            </c:when>
                            <c:otherwise>
                                0 produit au total
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/products/add" class="btn btn-modern btn-gradient-primary">
                    <i class="bi bi-plus-circle me-2"></i>Nouveau Produit
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
                                <c:when test="${not empty totalProducts}">${totalProducts}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">Total Produits</p>
                    </div>
                    <i class="bi bi-box-seam stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1">
                            <c:choose>
                                <c:when test="${not empty activeProducts}">${activeProducts}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">Produits Actifs</p>
                    </div>
                    <i class="bi bi-check-circle stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1">
                            <c:choose>
                                <c:when test="${not empty prescriptionProducts}">${prescriptionProducts}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">Sur Ordonnance</p>
                    </div>
                    <i class="bi bi-prescription stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1">
                            <c:choose>
                                <c:when test="${not empty totalValue}">
                                    <fmt:formatNumber value="${totalValue}" pattern="#,##0.00" /> €
                                </c:when>
                                <c:otherwise>0,00 €</c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">Valeur Totale</p>
                    </div>
                    <i class="bi bi-currency-euro stat-icon"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Barre de recherche et filtres -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="modern-card p-4">
                <form action="${pageContext.request.contextPath}/products" method="get" class="row g-3">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                                <i class="bi bi-search"></i>
                            </span>
                            <input type="text" class="form-control modern-input border-start-0"
                                   name="search" placeholder="Rechercher un produit..."
                                   value="${param.search}">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" name="category">
                            <option value="">Toutes les catégories</option>
                            <option value="Médicaments" ${param.category == 'Médicaments' ? 'selected' : ''}>Médicaments</option>
                            <option value="Vitamines" ${param.category == 'Vitamines' ? 'selected' : ''}>Vitamines</option>
                            <option value="Antibiotiques" ${param.category == 'Antibiotiques' ? 'selected' : ''}>Antibiotiques</option>
                            <option value="Soins" ${param.category == 'Soins' ? 'selected' : ''}>Soins</option>
                            <option value="Matériel Médical" ${param.category == 'Matériel Médical' ? 'selected' : ''}>Matériel Médical</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" name="status">
                            <option value="">Tous les statuts</option>
                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Actif</option>
                            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactif</option>
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

    <!-- Tableau des produits -->
    <div class="row">
        <div class="col-12">
            <div class="modern-card p-0">
                <div class="table-responsive">
                    <table class="table modern-table mb-0">
                        <thead>
                        <tr>
                            <th><i class="bi bi-hash me-2"></i>ID</th>
                            <th><i class="bi bi-box me-2"></i>Nom Commercial</th>
                            <th><i class="bi bi-tag me-2"></i>Nom Générique</th>
                            <th><i class="bi bi-building me-2"></i>Fabricant</th>
                            <th><i class="bi bi-capsule me-2"></i>Forme</th>
                            <th><i class="bi bi-currency-euro me-2"></i>Prix</th>
                            <th><i class="bi bi-clipboard-check me-2"></i>Ordonnance</th>
                            <th><i class="bi bi-toggle-on me-2"></i>Statut</th>
                            <th class="text-center"><i class="bi bi-gear me-2"></i>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty products}">
                                <tr>
                                    <td colspan="9" class="text-center py-5">
                                        <i class="bi bi-inbox display-1 text-muted d-block mb-3"></i>
                                        <h5 class="text-muted">Aucun produit trouvé</h5>
                                        <a href="${pageContext.request.contextPath}/products/add" class="btn btn-modern btn-gradient-primary mt-3">
                                            <i class="bi bi-plus-circle me-2"></i>Ajouter votre premier produit
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                        <td><strong>#${product.productId}</strong></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                                                    <i class="bi bi-capsule text-primary"></i>
                                                </div>
                                                <div>
                                                    <strong>${product.productName}</strong>
                                                    <c:if test="${not empty product.barcode}">
                                                        <br>
                                                        <small class="text-muted">
                                                            <i class="bi bi-upc-scan"></i> ${product.barcode}
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty product.genericName}">
                                                    ${product.genericName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted fst-italic">Non spécifié</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty product.manufacturer}">
                                                    ${product.manufacturer}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted fst-italic">Non spécifié</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge badge-modern bg-info text-dark">
                                                <c:choose>
                                                    <c:when test="${not empty product.dosageForm}">
                                                        ${product.dosageForm}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Non spécifié
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${not empty product.strength}">
                                                    - ${product.strength}
                                                </c:if>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex flex-column">
                                                <strong class="text-success">
                                                    Vente: <fmt:formatNumber value="${product.sellingPrice}" pattern="#,##0.00" /> €
                                                </strong>
                                                <small class="text-muted">
                                                    Achat: <fmt:formatNumber value="${product.unitPrice}" pattern="#,##0.00" /> €
                                                </small>
                                                <c:if test="${product.unitPrice > 0 and product.sellingPrice > product.unitPrice}">
                                                    <small class="text-success">
                                                        +<fmt:formatNumber value="${product.getProfitMargin()}" pattern="#,##0.0" />%
                                                    </small>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${product.requiresPrescription}">
                                                    <span class="badge badge-modern bg-danger">
                                                        <i class="bi bi-prescription me-1"></i>Oui
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-modern bg-success">
                                                        <i class="bi bi-check-circle me-1"></i>Non
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.isActive}">
                                                    <span class="badge badge-modern bg-success">
                                                        <i class="bi bi-check-circle me-1"></i>Actif
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-modern bg-secondary">
                                                        <i class="bi bi-x-circle me-1"></i>Inactif
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty product.reorderLevel and product.reorderLevel > 0}">
                                                <br>
                                                <small class="text-muted">
                                                    <i class="bi bi-box-arrow-down"></i> Seuil: ${product.reorderLevel}
                                                </small>
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}"
                                                   class="btn btn-outline-info" title="Voir détails">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/products/edit?id=${product.productId}"
                                                   class="btn btn-outline-primary" title="Modifier">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/inventory?productId=${product.productId}"
                                                   class="btn btn-outline-success" title="Stock">
                                                    <i class="bi bi-boxes"></i>
                                                </a>
                                                <button type="button" class="btn btn-outline-danger"
                                                        onclick="confirmToggleStatus(${product.productId}, '${product.isActive ? 'désactiver' : 'activer'}')"
                                                        title="${product.isActive ? 'Désactiver' : 'Activer'}">
                                                    <i class="bi ${product.isActive ? 'bi-toggle-off' : 'bi-toggle-on'}"></i>
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
                <c:if test="${not empty products and not empty totalPages and totalPages > 1}">
                    <div class="p-4 border-top">
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="mb-0 text-muted">
                                Affichage de <strong>${products.size()}</strong> produits sur <strong>${totalProducts}</strong>
                            </p>
                            <nav>
                                <ul class="pagination mb-0">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&category=${param.category}&status=${param.status}">
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
                                                    <a class="page-link" href="?page=${page}&search=${param.search}&category=${param.category}&status=${param.status}">
                                                            ${page}
                                                    </a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&category=${param.category}&status=${param.status}">
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
    function confirmToggleStatus(productId, action) {
        if (confirm('Êtes-vous sûr de vouloir ' + action + ' ce produit ?')) {
            window.location.href = '${pageContext.request.contextPath}/products/toggle-status?id=' + productId;
        }
    }

    function confirmDelete(productId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer définitivement ce produit ?')) {
            window.location.href = '${pageContext.request.contextPath}/products/delete?id=' + productId;
        }
    }

    // Fonction pour exporter les produits
    function exportProducts(format) {
        window.location.href = '${pageContext.request.contextPath}/products/export?format=' + format + '&search=${param.search}&category=${param.category}';
    }
</script>