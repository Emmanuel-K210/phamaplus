<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
                                                ${product.productName} <c:if test="${not empty product.genericName}">- ${product.genericName}</c:if>
                                            <c:if test="${not empty product.sellingPrice}">
                                                (<fmt:formatNumber value="${product.sellingPrice}" pattern="#,##0"/> FCFA)
                                            </c:if>
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
                                    <c:forEach var="supplier" items="${suppliers}">
                                        <option value="${supplier.supplierId}">
                                                ${supplier.supplierName}
                                            <c:if test="${not empty supplier.phone}">(${supplier.phone})</c:if>
                                        </option>
                                    </c:forEach>
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
                                    <i class="bi bi-cash-coin me-1"></i>Prix d'Achat Unitaire
                                </label>
                                <div class="input-group">
                                    <input type="number" class="form-control modern-input" id="purchasePrice"
                                           name="purchasePrice" step="100" min="0"
                                           placeholder="0" oninput="calculateTotal()">
                                    <span class="input-group-text">FCFA</span>
                                </div>
                            </div>
                        </div>

                        <!-- Calcul automatique -->
                        <div class="row mt-3">
                            <div class="col-12">
                                <div class="alert alert-secondary py-2">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="bi bi-calculator me-2"></i>
                                            <strong>Total d'achat estimé:</strong>
                                        </div>
                                        <div>
                                            <span id="totalAmount" class="fw-bold fs-5 text-success">0 FCFA</span>
                                        </div>
                                    </div>
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

                    <!-- Informations Complémentaires -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-info-circle text-warning me-2"></i>
                            Informations Complémentaires
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="receivedDate" class="form-label">
                                    <i class="bi bi-calendar-event me-1"></i>Date de Réception
                                </label>
                                <input type="date" class="form-control modern-input" id="receivedDate"
                                       name="receivedDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-shield-check me-1"></i>Statut du Lot
                                </label>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="isActive" name="isActive" checked>
                                    <label class="form-check-label" for="isActive">
                                        Lot actif
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Résumé -->
                    <div class="alert alert-info d-flex align-items-center">
                        <i class="bi bi-info-circle fs-4 me-3"></i>
                        <div>
                            <strong>Astuces:</strong>
                            <ul class="mb-0 mt-2">
                                <li>Le numéro de lot doit être unique pour chaque produit</li>
                                <li>Vérifiez attentivement la date d'expiration</li>
                                <li>Le prix d'achat est utilisé pour calculer la marge bénéficiaire</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="d-flex gap-3 justify-content-end pt-4 border-top">
                        <a href="${pageContext.request.contextPath}/inventory"
                           class="btn btn-outline-secondary px-4">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="reset" class="btn btn-outline-warning px-4" onclick="resetForm()">
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
    // Format FCFA
    function formatFCFA(amount) {
        if (!amount || isNaN(amount)) return '0 FCFA';
        return new Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amount) + ' FCFA';
    }

    // Calcul du total
    function calculateTotal() {
        const quantity = parseInt(document.getElementById('quantity').value) || 0;
        const price = parseFloat(document.getElementById('purchasePrice').value) || 0;
        const total = quantity * price;
        document.getElementById('totalAmount').textContent = formatFCFA(total);
    }

    // Ajustement quantité
    function adjustQuantity(value) {
        const input = document.getElementById('quantity');
        const currentValue = parseInt(input.value) || 0;
        const newValue = currentValue + value;
        if (newValue > 0) {
            input.value = newValue;
            calculateTotal();
        }
    }

    // Vérification expiration
    function checkExpiry() {
        const expiryDate = new Date(document.getElementById('expiryDate').value);
        const today = new Date();
        const alertDiv = document.getElementById('expiryAlert');

        const diffTime = expiryDate - today;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        if (diffDays < 0) {
            alertDiv.innerHTML = '<i class="bi bi-x-circle text-danger me-1"></i>' +
                '<strong class="text-danger">Attention: Ce produit est déjà expiré!</strong>';
            alertDiv.className = 'alert alert-danger mt-2 py-2';
        } else if (diffDays < 30) {
            alertDiv.innerHTML = '<i class="bi bi-exclamation-triangle text-warning me-1"></i>' +
                '<strong class="text-warning">Attention: Ce produit expire dans ' + diffDays + ' jours</strong>';
            alertDiv.className = 'alert alert-warning mt-2 py-2';
        } else if (diffDays < 90) {
            alertDiv.innerHTML = '<i class="bi bi-info-circle text-info me-1"></i>' +
                '<span class="text-info">Ce produit expire dans ' + diffDays + ' jours</span>';
            alertDiv.className = 'alert alert-info mt-2 py-2';
        } else {
            alertDiv.innerHTML = '<i class="bi bi-check-circle text-success me-1"></i>' +
                '<span class="text-success">Date d\'expiration valide (' + diffDays + ' jours)</span>';
            alertDiv.className = 'alert alert-success mt-2 py-2';
        }
    }

    // Réinitialisation
    function resetForm() {
        document.getElementById('totalAmount').textContent = '0 FCFA';
        document.getElementById('expiryAlert').innerHTML = '';
        document.getElementById('expiryAlert').className = '';
    }

    // Écouteurs d'événements
    document.getElementById('quantity').addEventListener('input', calculateTotal);
    document.getElementById('purchasePrice').addEventListener('input', calculateTotal);

    // Initialisation
    document.addEventListener('DOMContentLoaded', function() {
        // Set min date for expiry to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('expiryDate').min = today;
        document.getElementById('manufacturingDate').max = today;
        document.getElementById('receivedDate').max = today;

        // Calcul initial
        calculateTotal();

        // Focus sur le premier champ
        document.getElementById('productId').focus();
    });

    // Auto-génération du numéro de lot
    document.getElementById('productId').addEventListener('change', function() {
        const productId = this.value;
        if (productId) {
            // Générer un numéro de lot basé sur la date + ID produit
            const today = new Date();
            const datePart = today.getFullYear().toString().slice(-2) +
                String(today.getMonth() + 1).padStart(2, '0') +
                String(today.getDate()).padStart(2, '0');
            const batchNumber = 'BATCH' + datePart + '-' + String(productId).padStart(3, '0');

            document.getElementById('batchNumber').value = batchNumber;
        }
    });
</script>

<style>
    .modern-input {
        border: 2px solid #e9ecef;
        border-radius: 8px;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .modern-input:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
    }

    .btn-gradient-success {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        color: white;
        font-weight: 600;
    }

    .btn-gradient-success:hover {
        background: linear-gradient(135deg, #5a6fd8 0%, #6a4091 100%);
        color: white;
    }

    .modern-card {
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        border: 1px solid #e9ecef;
    }
</style>