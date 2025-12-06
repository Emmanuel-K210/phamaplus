<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    /* Styles pour la page de vue détaillée */
    .product-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 15px;
        padding: 2rem;
        margin-bottom: 2rem;
    }

    .info-card {
        background: white;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        padding: 1.5rem;
        margin-bottom: 1.5rem;
        border: 1px solid #eee;
    }

    .info-label {
        color: #666;
        font-weight: 600;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .info-value {
        font-size: 1.1rem;
        font-weight: 500;
        color: #333;
    }

    .status-badge {
        padding: 0.5rem 1rem;
        border-radius: 50px;
        font-weight: 600;
        display: inline-block;
    }

    .price-display {
        font-size: 1.8rem;
        font-weight: 700;
        color: #28a745;
    }

    .action-buttons .btn {
        padding: 0.6rem 1.2rem;
        font-weight: 600;
    }

    .detail-icon {
        font-size: 1.2rem;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 10px;
        margin-right: 1rem;
    }

    .stock-info {
        padding: 1rem;
        border-radius: 10px;
        border-left: 4px solid;
    }

    .stock-low {
        background-color: #fff5f5;
        border-left-color: #f56565;
    }

    .stock-ok {
        background-color: #f0fff4;
        border-left-color: #48bb78;
    }

    .profit-badge {
        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        color: white;
        padding: 0.3rem 0.8rem;
        border-radius: 50px;
        font-size: 0.9rem;
        font-weight: 600;
    }
</style>

<div class="container-fluid">
    <!-- En-tête du produit -->
    <div class="product-header">
        <div class="row align-items-center">
            <div class="col-md-8">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-white bg-opacity-20 rounded-circle p-3 me-3">
                        <i class="bi bi-capsule-fill" style="font-size: 2rem;"></i>
                    </div>
                    <div>
                        <h1 class="mb-1">${product.productName}</h1>
                        <c:if test="${not empty product.genericName}">
                            <p class="mb-0 opacity-75">
                                <i class="bi bi-tag me-1"></i> ${product.genericName}
                            </p>
                        </c:if>
                        <p class="mb-0 opacity-75">
                            <i class="bi bi-hash me-1"></i> Réf: #${product.productId}
                            <c:if test="${not empty product.barcode}">
                                <span class="ms-3">
                                    <i class="bi bi-upc-scan me-1"></i> ${product.barcode}
                                </span>
                            </c:if>
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 text-end">
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/products/edit?id=${product.productId}"
                       class="btn btn-light me-2">
                        <i class="bi bi-pencil me-1"></i> Modifier
                    </a>
                    <a href="${pageContext.request.contextPath}/products"
                       class="btn btn-outline-light">
                        <i class="bi bi-arrow-left me-1"></i> Retour
                    </a>
                </div>
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

    <div class="row">
        <!-- Informations principales -->
        <div class="col-lg-8">
            <div class="row">
                <!-- Informations produit -->
                <div class="col-md-6 mb-4">
                    <div class="info-card h-100">
                        <h5 class="mb-3">
                            <i class="bi bi-info-circle text-primary me-2"></i>
                            Informations du produit
                        </h5>
                        <div class="mb-3">
                            <div class="info-label">Fabricant</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty product.manufacturer}">
                                        <i class="bi bi-building text-muted me-2"></i>
                                        ${product.manufacturer}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted fst-italic">Non spécifié</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">Forme galénique</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty product.dosageForm}">
                                        <span class="badge bg-info bg-opacity-10 text-info">
                                            ${product.dosageForm}
                                            <c:if test="${not empty product.strength}">
                                                - ${product.strength}
                                            </c:if>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted fst-italic">Non spécifié</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">Unité de mesure</div>
                            <div class="info-value">
                                <i class="bi bi-rulers text-muted me-2"></i>
                                ${product.unitOfMeasure}
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">Catégorie</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty product.categoryName}">
                                        <span class="badge bg-primary bg-opacity-10 text-primary">
                                                ${product.categoryName}
                                        </span>
                                    </c:when>
                                    <c:when test="${not empty product.categoryId}">
                                        <span class="badge bg-primary bg-opacity-10 text-primary">
                                            Catégorie #${product.categoryId}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted fst-italic">Non catégorisé</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Informations prix -->
                <div class="col-md-6 mb-4">
                    <div class="info-card h-100">
                        <h5 class="mb-3">
                            <i class="bi bi-cash-stack text-success me-2"></i>
                            Informations financières
                        </h5>
                        <div class="mb-3">
                            <div class="info-label">Prix d'achat</div>
                            <div class="info-value">
                                <i class="bi bi-arrow-down-circle text-muted me-2"></i>
                                <fmt:formatNumber value="${product.unitPrice}" pattern="#,##0" /> FCFA
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">Prix de vente</div>
                            <div class="info-value price-display">
                                <i class="bi bi-arrow-up-circle me-2"></i>
                                <fmt:formatNumber value="${product.sellingPrice}" pattern="#,##0" /> FCFA
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">Marge bénéficiaire</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${product.unitPrice > 0 and product.sellingPrice > product.unitPrice}">
                                        <span class="profit-badge">
                                            +<fmt:formatNumber value="${product.getProfitMargin()}" pattern="#,##0.0" />%
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted fst-italic">Non calculable</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Informations réglementaires -->
                <div class="col-md-6 mb-4">
                    <div class="info-card h-100">
                        <h5 class="mb-3">
                            <i class="bi bi-clipboard-check text-warning me-2"></i>
                            Informations réglementaires
                        </h5>
                        <div class="mb-3">
                            <div class="info-label">Ordonnance requise</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${product.requiresPrescription}">
                                        <span class="status-badge bg-danger bg-opacity-10 text-danger">
                                            <i class="bi bi-prescription me-1"></i> Oui
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge bg-success bg-opacity-10 text-success">
                                            <i class="bi bi-check-circle me-1"></i> Non
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="info-label">Statut</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${product.isActive}">
                                        <span class="status-badge bg-success bg-opacity-10 text-success">
                                            <i class="bi bi-check-circle me-1"></i> Actif
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge bg-secondary bg-opacity-10 text-secondary">
                                            <i class="bi bi-x-circle me-1"></i> Inactif
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Informations stock -->
                <div class="col-md-6 mb-4">
                    <div class="info-card h-100">
                        <h5 class="mb-3">
                            <i class="bi bi-boxes text-info me-2"></i>
                            Informations stock
                        </h5>
                        <div class="mb-3">
                            <div class="info-label">Seuil de réapprovisionnement</div>
                            <div class="info-value">
                                <i class="bi bi-box-arrow-down text-muted me-2"></i>
                                ${product.reorderLevel} unités
                            </div>
                        </div>
                        <c:if test="${not empty currentStock}">
                            <div class="mb-3">
                                <div class="info-label">Stock actuel</div>
                                <div class="info-value">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-box-seam text-muted me-2"></i>
                                        <strong>${currentStock}</strong> unités
                                        <c:if test="${currentStock <= product.reorderLevel}">
                                            <span class="ms-2 text-danger">
                                                <i class="bi bi-exclamation-triangle me-1"></i>
                                                Stock faible
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/inventory?productId=${product.productId}"
                               class="btn btn-outline-info w-100">
                                <i class="bi bi-boxes me-2"></i>
                                Voir le détail du stock
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recherchez la section "Historique et métadonnées" -->
            <div class="info-card">
                <h5 class="mb-3">
                    <i class="bi bi-clock-history text-secondary me-2"></i>
                    Historique et métadonnées
                </h5>
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="info-label">Date de création</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty product.createdAt}">
                                        <i class="bi bi-calendar-plus text-muted me-2"></i>
                                        ${product.createdAt}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted fst-italic">Non disponible</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <div class="info-label">Dernière mise à jour</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty product.updatedAt}">
                                        <i class="bi bi-calendar-check text-muted me-2"></i>
                                        ${product.updatedAt}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted fst-italic">Non disponible</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <!-- Actions rapides -->
        <div class="col-lg-4">
            <div class="sticky-top" style="top: 20px;">
                <!-- Actions rapides -->
                <div class="info-card mb-4">
                    <h5 class="mb-3">
                        <i class="bi bi-lightning-charge text-warning me-2"></i>
                        Actions rapides
                    </h5>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/inventory/entry?productId=${product.productId}"
                           class="btn btn-outline-primary">
                            <i class="bi bi-box-arrow-in-down me-2"></i>
                            Ajouter au stock
                        </a>
                        <a href="${pageContext.request.contextPath}/sales/new?productId=${product.productId}"
                           class="btn btn-outline-success">
                            <i class="bi bi-cart-plus me-2"></i>
                            Vendre ce produit
                        </a>
                        <button type="button" class="btn btn-outline-secondary"
                                onclick="toggleProductStatus(${product.productId}, '${product.isActive ? 'désactiver' : 'activer'}')">
                            <i class="bi ${product.isActive ? 'bi-toggle-off' : 'bi-toggle-on'} me-2"></i>
                            ${product.isActive ? 'Désactiver' : 'Activer'} le produit
                        </button>
                        <button type="button" class="btn btn-outline-danger"
                                onclick="confirmDelete(${product.productId})">
                            <i class="bi bi-trash me-2"></i>
                            Supprimer définitivement
                        </button>
                    </div>
                </div>

                <!-- Informations supplémentaires -->
                <c:if test="${not empty lowStockWarning}">
                    <div class="info-card mb-4 stock-low">
                        <h5 class="mb-2 text-danger">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            Alerte stock
                        </h5>
                        <p class="mb-0">${lowStockWarning}</p>
                    </div>
                </c:if>

                <!-- Code QR (si disponible) -->
                <c:if test="${not empty product.barcode}">
                    <div class="info-card">
                        <h5 class="mb-3">
                            <i class="bi bi-qr-code text-info me-2"></i>
                            Code produit
                        </h5>
                        <div class="text-center">
                            <div class="bg-light p-3 rounded d-inline-block mb-2">
                                <div class="text-monospace fw-bold">${product.barcode}</div>
                            </div>
                            <p class="small text-muted mb-0">
                                Scannez ce code pour accéder rapidement aux informations du produit
                            </p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleProductStatus(productId, action) {
        if (confirm('Êtes-vous sûr de vouloir ' + action + ' ce produit ?')) {
            window.location.href = '${pageContext.request.contextPath}/products/toggle-status?id=' + productId + '&redirect=view';
        }
    }

    function confirmDelete(productId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer définitivement ce produit ? Cette action est irréversible.')) {
            window.location.href = '${pageContext.request.contextPath}/products/delete?id=' + productId;
        }
    }
</script>