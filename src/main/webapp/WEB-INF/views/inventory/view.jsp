<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>

<%
    // Créer un formatter une fois pour toutes
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    LocalDate today = LocalDate.now();

    pageContext.setAttribute("dateFormatter", dateFormatter);
    pageContext.setAttribute("today", today);
%>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-box-seam text-primary me-2"></i>Détails du Lot
                    </h2>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/inventory">Inventaire</a>
                            </li>
                            <li class="breadcrumb-item active">Lot #${inventory.inventoryId}</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/inventory" class="btn btn-modern btn-outline-secondary me-2">
                        <i class="bi bi-arrow-left me-2"></i>Retour
                    </a>
                    <a href="${pageContext.request.contextPath}/inventory/edit?id=${inventory.inventoryId}"
                       class="btn btn-modern btn-gradient-primary">
                        <i class="bi bi-pencil me-2"></i>Modifier
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

    <!-- Contenu principal -->
    <div class="row">
        <!-- Carte principale -->
        <div class="col-lg-8">
            <div class="modern-card">
                <div class="p-4 border-bottom">
                    <div class="d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">
                            <i class="bi bi-info-circle me-2"></i>Informations du Lot
                            </h5>
                            <c:set var="stockLevel" value="${inventory.quantityInStock}" />
                            <span class="badge badge-modern ${stockLevel <= 0 ? 'bg-danger' : stockLevel < 10 ? 'bg-warning text-dark' : 'bg-success'}">
                            <c:choose>
                                <c:when test="${stockLevel <= 0}">
                                    <i class="bi bi-x-circle me-1"></i>Épuisé
                                </c:when>
                                <c:when test="${stockLevel < 10}">
                                    <i class="bi bi-exclamation-triangle me-1"></i>Stock bas
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-check-circle me-1"></i>Disponible
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <div class="p-4">
                    <div class="row g-4">
                        <!-- Informations produit -->
                        <div class="col-md-6">
                            <h6 class="text-uppercase text-muted mb-3">
                                <i class="bi bi-capsule me-2"></i>Produit
                            </h6>
                            <div class="d-flex align-items-center mb-4">
                                <div class="bg-primary bg-opacity-10 rounded-circle p-3 me-3">
                                    <i class="bi bi-capsule fs-4 text-primary"></i>
                                </div>
                                <div>
                                    <h5 class="mb-1">${inventory.productName}</h5>
                                    <p class="text-muted mb-0">Référence: #${inventory.productId}</p>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label text-muted small">Numéro de Lot</label>
                                <div class="fs-5 fw-bold">${inventory.batchNumber}</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label text-muted small">Emplacement</label>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-geo-alt-fill text-muted me-2"></i>
                                    <span class="fs-5">${not empty inventory.location ? inventory.location : 'Non spécifié'}</span>
                                </div>
                            </div>
                        </div>

                        <!-- Informations stock -->
                        <div class="col-md-6">
                            <h6 class="text-uppercase text-muted mb-3">
                                <i class="bi bi-boxes me-2"></i>Stock
                            </h6>
                            <div class="row mb-4">
                                <div class="col-6">
                                    <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                        <div class="text-center">
                                            <h3 class="mb-1">${inventory.quantityInStock}</h3>
                                            <p class="mb-0 opacity-75">En stock</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
                                        <div class="text-center">
                                            <h3 class="mb-1">${inventory.quantityReserved != null ? inventory.quantityReserved : 0}</h3>
                                            <p class="mb-0 opacity-75">Réservé</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Barre de progression stock -->
                            <div class="mb-4">
                                <label class="form-label text-muted small">Niveau de stock</label>
                                <div class="progress" style="height: 12px;">
                                    <c:choose>
                                        <c:when test="${stockLevel >= 50}">
                                            <div class="progress-bar bg-success" role="progressbar"
                                                 style="width: ${stockLevel > 100 ? 100 : stockLevel}%">
                                            </div>
                                        </c:when>
                                        <c:when test="${stockLevel >= 10}">
                                            <div class="progress-bar bg-warning" role="progressbar"
                                                 style="width: ${stockLevel}%">
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="progress-bar bg-danger" role="progressbar"
                                                 style="width: ${stockLevel * 10}%">
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="d-flex justify-content-between mt-2">
                                    <small class="text-muted">Faible</small>
                                    <small class="text-muted">Normal</small>
                                </div>
                            </div>
                        </div>

                        <!-- Dates - SECTION COMPLÈTEMENT CORRIGÉE -->
                        <div class="col-md-6">
                            <h6 class="text-uppercase text-muted mb-3">
                                <i class="bi bi-calendar me-2"></i>Dates
                            </h6>
                            <div class="row">
                                <div class="col-6 mb-3">
                                    <label class="form-label text-muted small">Date d'arrivée</label>
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-calendar-plus text-muted me-2"></i>
                                        <span>
                                            <c:choose>
                                                <c:when test="${not empty inventory.receivedDate}">
                                                    ${inventory.receivedDate.format(dateFormatter)}
                                                </c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>

                                <div class="col-6 mb-3">
                                    <label class="form-label text-muted small">Date de fabrication</label>
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-calendar-check text-muted me-2"></i>
                                        <span>
                                            <c:choose>
                                                <c:when test="${not empty inventory.manufacturingDate}">
                                                    ${inventory.manufacturingDate.format(dateFormatter)}
                                                </c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label text-muted small">Date d'expiration</label>
                                    <div class="d-flex align-items-center">
                                        <c:choose>
                                            <c:when test="${inventory.isExpired}">
                                                <i class="bi bi-calendar-x text-danger me-2"></i>
                                                <span class="text-danger">${inventory.expiryDate.format(dateFormatter)}</span>
                                                <span class="badge bg-danger ms-2">Expiré</span>
                                            </c:when>
                                            <c:when test="${inventory.expiryDate.isBefore(today.plusDays(30))}">
                                                <i class="bi bi-calendar-x text-warning me-2"></i>
                                                <span class="text-warning">${inventory.expiryDate.format(dateFormatter)}</span>
                                                <span class="badge bg-warning ms-2">Bientôt expiré</span>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-calendar-event text-success me-2"></i>
                                                <span>${inventory.expiryDate.format(dateFormatter)}</span>
                                                <span class="badge bg-success ms-2">Valide</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Informations supplémentaires -->
                        <div class="col-md-6">
                            <h6 class="text-uppercase text-muted mb-3">
                                <i class="bi bi-info-square me-2"></i>Informations supplémentaires
                            </h6>
                            <div class="row">
                                <c:if test="${not empty inventory.supplierName}">
                                    <div class="col-12 mb-3">
                                        <label class="form-label text-muted small">Fournisseur</label>
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-truck text-muted me-2"></i>
                                            <span>${inventory.supplierName}</span>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty inventory.purchasePrice}">
                                    <div class="col-6 mb-3">
                                        <label class="form-label text-muted small">Prix d'achat</label>
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-cash text-muted me-2"></i>
                                            <span><fmt:formatNumber value="${inventory.purchasePrice}" pattern="#,##0"/> FCFA</span>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty inventory.sellingPrice}">
                                    <div class="col-6 mb-3">
                                        <label class="form-label text-muted small">Prix de vente</label>
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-tag text-muted me-2"></i>
                                            <span><fmt:formatNumber value="${inventory.sellingPrice}" pattern="#,##0"/> FCFA</span>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="col-12 mb-3">
                                    <label class="form-label text-muted small">Valeur totale du stock</label>
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-calculator text-muted me-2"></i>
                                        <c:if test="${not empty inventory.purchasePrice}">
                                            <c:set var="totalValue" value="${inventory.quantityInStock * inventory.purchasePrice}" />
                                            <span class="fs-5 fw-bold text-primary">
                                                <fmt:formatNumber value="${totalValue}" pattern="#,##0"/> FCFA
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar actions - SECTION CORRIGÉE -->
        <div class="col-lg-4">
            <!-- Actions rapides -->
            <div class="modern-card mb-4">
                <div class="p-4 border-bottom">
                    <h5 class="mb-0">
                        <i class="bi bi-lightning-charge me-2"></i>Actions rapides
                    </h5>
                </div>
                <div class="p-4">
                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-modern btn-gradient-success mb-2"
                                onclick="adjustStock('add')">
                            <i class="bi bi-plus-circle me-2"></i>Ajouter au stock
                        </button>
                        <button type="button" class="btn btn-modern btn-gradient-warning mb-2"
                                onclick="adjustStock('remove')" ${inventory.quantityInStock <= 0 ? 'disabled' : ''}>
                            <i class="bi bi-dash-circle me-2"></i>Retirer du stock
                        </button>
                        <button type="button" class="btn btn-modern btn-gradient-info mb-2">
                            <i class="bi bi-arrow-left-right me-2"></i>Transférer
                        </button>
                        <button type="button" class="btn btn-modern btn-gradient-secondary mb-2">
                            <i class="bi bi-file-earmark-text me-2"></i>Historique
                        </button>
                    </div>
                </div>
            </div>

            <!-- Statut d'expiration - CORRIGÉ SANS TAGLIB -->
            <div class="modern-card">
                <div class="p-4 border-bottom">
                    <h5 class="mb-0">
                        <i class="bi bi-shield-exclamation me-2"></i>Statut d'expiration
                    </h5>
                </div>
                <div class="p-4">
                    <c:choose>
                        <c:when test="${inventory.isExpired}">
                            <div class="text-center">
                                <div class="bg-danger bg-opacity-10 p-4 rounded-circle d-inline-block mb-3">
                                    <i class="bi bi-exclamation-triangle fs-1 text-danger"></i>
                                </div>
                                <h5 class="text-danger mb-2">Expiré</h5>
                                <p class="text-muted">Ce produit doit être retiré de la vente.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:set var="daysUntilExpiry" value="${today.until(inventory.expiryDate).getDays()}" />

                            <c:choose>
                                <c:when test="${daysUntilExpiry <= 30}">
                                    <div class="text-center">
                                        <div class="bg-warning bg-opacity-10 p-4 rounded-circle d-inline-block mb-3">
                                            <i class="bi bi-exclamation-circle fs-1 text-warning"></i>
                                        </div>
                                        <h5 class="text-warning mb-2">Bientôt expiré</h5>
                                        <p class="text-muted">Expire dans ${daysUntilExpiry} jours.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center">
                                        <div class="bg-success bg-opacity-10 p-4 rounded-circle d-inline-block mb-3">
                                            <i class="bi bi-check-circle fs-1 text-success"></i>
                                        </div>
                                        <h5 class="text-success mb-2">Valide</h5>
                                        <p class="text-muted">Ce produit est en bon état.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .modern-card {
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        border: 1px solid #e9ecef;
    }

    .stat-card {
        border-radius: 12px;
        padding: 20px;
        color: white;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        transition: transform 0.2s;
    }

    .stat-card:hover {
        transform: translateY(-5px);
    }

    .progress {
        border-radius: 10px;
    }

    .progress-bar {
        border-radius: 10px;
    }

    .btn-modern {
        border-radius: 10px;
        font-weight: 600;
        transition: all 0.3s;
    }

    .btn-gradient-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        color: white;
    }

    .btn-gradient-success {
        background: linear-gradient(135deg, #0d6efd 0%, #38ef7d 100%);
        border: none;
        color: white;
    }

    .btn-gradient-warning {
        background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);
        border: none;
        color: white;
    }

    .btn-gradient-info {
        background: linear-gradient(135deg, #00d2ff 0%, #3a7bd5 100%);
        border: none;
        color: white;
    }

    .btn-gradient-secondary {
        background: linear-gradient(135deg, #b3b3b3 0%, #808080 100%);
        border: none;
        color: white;
    }

    .badge-modern {
        padding: 0.5rem 1rem;
        font-size: 0.9rem;
        border-radius: 8px;
    }
</style>

<script>
    function adjustStock(action) {
        const amount = prompt('Quantité à ' + (action === 'add' ? 'ajouter' : 'retirer') + ':');
        if (amount && !isNaN(amount) && amount > 0) {
            alert('Fonctionnalité à implémenter: ajuster le stock de ' + amount + ' unités');
        }
    }

    function confirmDelete() {
        if (confirm('Êtes-vous sûr de vouloir supprimer ce lot? Cette action est irréversible.')) {
            window.location.href = '${pageContext.request.contextPath}/inventory/delete?id=${inventory.inventoryId}';
        }
    }
</script>