<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-plus-circle text-success me-2"></i>Nouveau Lot d'Inventaire
                    </h2>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/inventory">Inventaire</a>
                            </li>
                            <li class="breadcrumb-item active">Nouveau</li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Retour
                </a>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8 mx-auto">
            <div class="modern-card p-4">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/inventory/add" method="post">
                    <!-- Informations Produit -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-box-seam text-primary me-2"></i>
                            Informations Produit
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="productId" class="form-label">
                                    <i class="bi bi-capsule me-1"></i>Produit <span class="text-danger">*</span>
                                </label>
                                <select class="form-select modern-input" id="productId" name="productId" required>
                                    <option value="">Sélectionner un produit</option>
                                    <c:forEach var="product" items="${products}">
                                        <option value="${product.productId}">
                                                ${product.productName} - ${product.genericName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="batchNumber" class="form-label">
                                    <i class="bi bi-upc me-1"></i>Numéro de Lot <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control modern-input" id="batchNumber"
                                       name="batchNumber" placeholder="Ex: BATCH2024001" required>
                            </div>

                            <div class="col-md-6">
                                <label for="supplierId" class="form-label">
                                    <i class="bi bi-truck me-1"></i>Fournisseur
                                </label>
                                <select class="form-select modern-input" id="supplierId" name="supplierId">
                                    <option value="">Sélectionner un fournisseur</option>
                                    <option value="1">Fournisseur A</option>
                                    <option value="2">Fournisseur B</option>
                                    <option value="3">Fournisseur C</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="location" class="form-label">
                                    <i class="bi bi-geo-alt me-1"></i>Emplacement
                                </label>
                                <input type="text" class="form-control modern-input" id="location"
                                       name="location" placeholder="Ex: Rayon A - Étagère 3">
                            </div>
                        </div>
                    </div>

                    <!-- Quantité -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-boxes text-success me-2"></i>
                            Quantité
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="quantity" class="form-label">
                                    <i class="bi bi-123 me-1"></i>Quantité en Stock <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(-1)">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <input type="number" class="form-control modern-input text-center"
                                           id="quantity" name="quantity" min="1" value="1" required>
                                    <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(1)">
                                        <i class="bi bi-plus"></i>
                                    </button>
                                    <span class="input-group-text">unités</span>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="purchasePrice" class="form-label">
                                    <i class="bi bi-currency-euro me-1"></i>Prix d'Achat Unitaire
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-currency-euro"></i></span>
                                    <input type="number" class="form-control modern-input" id="purchasePrice"
                                           name="purchasePrice" step="0.01" min="0" placeholder="0.00">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Dates -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-calendar text-info me-2"></i>
                            Dates Importantes
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="manufacturingDate" class="form-label">
                                    <i class="bi bi-calendar-check me-1"></i>Date de Fabrication
                                </label>
                                <input type="date" class="form-control modern-input" id="manufacturingDate"
                                       name="manufacturingDate">
                            </div>

                            <div class="col-md-6">
                                <label for="expiryDate" class="form-label">
                                    <i class="bi bi-calendar-x me-1"></i>Date d'Expiration <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control modern-input" id="expiryDate"
                                       name="expiryDate" required onchange="checkExpiry()">
                                <div id="expiryAlert" class="form-text"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Résumé -->
                    <div class="alert alert-info d-flex align-items-center">
                        <i class="bi bi-info-circle fs-4 me-3"></i>
                        <div>
                            <strong>Astuce:</strong> Assurez-vous que toutes les informations sont correctes
                            avant d'enregistrer le lot. Une fois enregistré, vous pourrez toujours le modifier.
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="d-flex gap-3 justify-content-end pt-4 border-top">
                        <a href="${pageContext.request.contextPath}/inventory"
                           class="btn btn-outline-secondary px-4">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="reset" class="btn btn-outline-warning px-4">
                            <i class="bi bi-arrow-counterclockwise me-2"></i>Réinitialiser
                        </button>
                        <button type="submit" class="btn btn-modern btn-gradient-success px-4">
                            <i class="bi bi-check-circle me-2"></i>Enregistrer le Lot
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function adjustQuantity(value) {
        const input = document.getElementById('quantity');
        const currentValue = parseInt(input.value) || 0;
        const newValue = currentValue + value;
        if (newValue > 0) {
            input.value = newValue;
        }
    }

    function checkExpiry() {
        const expiryDate = new Date(document.getElementById('expiryDate').value);
        const today = new Date();
        const alertDiv = document.getElementById('expiryAlert');

        const diffTime = expiryDate - today;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        if (diffDays < 0) {
            alertDiv.innerHTML = '<i class="bi bi-x-circle text-danger me-1"></i>' +
                '<strong class="text-danger">Attention: Ce produit est déjà expiré!</strong>';
        } else if (diffDays < 30) {
            alertDiv.innerHTML = '<i class="bi bi-exclamation-triangle text-warning me-1"></i>' +
                '<strong class="text-warning">Attention: Ce produit expire dans ' + diffDays + ' jours</strong>';
        } else if (diffDays < 90) {
            alertDiv.innerHTML = '<i class="bi bi-info-circle text-info me-1"></i>' +
                '<span class="text-info">Ce produit expire dans ' + diffDays + ' jours</span>';
        } else {
            alertDiv.innerHTML = '<i class="bi bi-check-circle text-success me-1"></i>' +
                '<span class="text-success">Date d\'expiration valide (' + diffDays + ' jours)</span>';
        }
    }

    // Set min date for expiry to today
    document.getElementById('expiryDate').min = new Date().toISOString().split('T')[0];
</script>