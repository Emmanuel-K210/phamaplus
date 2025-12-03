<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // Pour les dates par défaut
    java.time.LocalDate today = java.time.LocalDate.now();
    pageContext.setAttribute("today", today);
%>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-pencil-square text-primary me-2"></i>Modifier le Lot
                    </h2>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/inventory">Inventaire</a>
                            </li>
                            <c:if test="${not empty inventory.inventoryId}">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/inventory/view?id=${inventory.inventoryId}">
                                        Lot ${inventory.batchNumber}
                                    </a>
                                </li>
                            </c:if>
                            <li class="breadcrumb-item active">Modification</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <c:if test="${not empty inventory.inventoryId}">
                        <button type="button" class="btn btn-outline-danger me-2" onclick="confirmDelete()">
                            <i class="bi bi-trash me-2"></i>Supprimer
                        </button>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Retour
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8 mx-auto">
            <div class="modern-card p-4">
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show mb-4">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show mb-4">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/inventory/update" method="post" id="editForm">
                    <input type="hidden" name="inventoryId" value="${inventory.inventoryId}">

                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-box-seam text-primary me-2"></i>Informations Produit
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="productId" class="form-label">
                                    <i class="bi bi-capsule me-1"></i>Produit <span class="text-danger">*</span>
                                </label>
                                <select class="form-select modern-input" id="productId" name="productId" required
                                        onchange="updateProductInfo(this.value)">
                                    <option value="">Sélectionner un produit</option>
                                    <c:forEach var="product" items="${products}">
                                        <option value="${product.productId}"
                                            ${inventory.productId == product.productId ? 'selected' : ''}
                                                data-price="${product.purchasePrice}"
                                                data-category="${product.category}"
                                                data-code="${product.code}">
                                                ${product.productName}
                                            <c:if test="${not empty product.genericName}">
                                                - ${product.genericName}
                                            </c:if>
                                            <c:if test="${product.stockQuantity <= 10}">
                                                (Stock faible: ${product.stockQuantity})
                                            </c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">
                                    <span id="productInfo"></span>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="batchNumber" class="form-label">
                                    <i class="bi bi-upc me-1"></i>Numéro de Lot <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <input type="text" class="form-control modern-input" id="batchNumber"
                                           name="batchNumber" value="${inventory.batchNumber}" required
                                           placeholder="EX: LOT202401001">
                                    <button type="button" class="btn btn-outline-secondary" onclick="generateBatchNumber()">
                                        <i class="bi bi-arrow-clockwise"></i> Générer
                                    </button>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="supplierId" class="form-label">
                                    <i class="bi bi-truck me-1"></i>Fournisseur
                                </label>
                                <select class="form-select modern-input" id="supplierId" name="supplierId">
                                    <option value="">Sélectionner un fournisseur</option>
                                    <c:forEach var="supplier" items="${suppliers}">
                                        <option value="${supplier.supplierId}"
                                            ${inventory.supplierId == supplier.supplierId ? 'selected' : ''}>
                                                ${supplier.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="location" class="form-label">
                                    <i class="bi bi-geo-alt me-1"></i>Emplacement
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-shelves"></i></span>
                                    <input type="text" class="form-control modern-input" id="location"
                                           name="location" value="${inventory.location}"
                                           placeholder="Ex: Rayon A, Étagère 3">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-boxes text-success me-2"></i>Quantité et Prix
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="quantity" class="form-label">
                                        <i class="bi bi-123 me-1"></i>Quantité en Stock <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(-10)">
                                            -10
                                        </button>
                                        <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(-1)">
                                            <i class="bi bi-dash"></i>
                                        </button>
                                        <input type="number" class="form-control modern-input text-center"
                                               id="quantity" name="quantity" min="0" max="9999"
                                               value="${inventory.quantityInStock}" required>
                                        <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(1)">
                                            <i class="bi bi-plus"></i>
                                        </button>
                                        <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(10)">
                                            +10
                                        </button>
                                        <span class="input-group-text">unités</span>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="quantityReserved" class="form-label">
                                        <i class="bi bi-lock me-1"></i>Quantité Réservée
                                    </label>
                                    <input type="number" class="form-control modern-input" id="quantityReserved"
                                           name="quantityReserved" min="0" max="${inventory.quantityInStock}"
                                           value="${inventory.quantityReserved}">
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="purchasePrice" class="form-label">
                                        <i class="bi bi-cash me-1"></i>Prix d'Achat Unitaire
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">FCFA</span>
                                        <input type="number" class="form-control modern-input" id="purchasePrice"
                                               name="purchasePrice" step="1" min="0"
                                               value="<fmt:formatNumber value='${inventory.purchasePrice}' pattern='#' />"
                                               onchange="calculateTotalValue()">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="sellingPrice" class="form-label">
                                        <i class="bi bi-tag me-1"></i>Prix de Vente Unitaire
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">FCFA</span>
                                        <input type="number" class="form-control modern-input" id="sellingPrice"
                                               name="sellingPrice" step="1" min="0"
                                               value="<fmt:formatNumber value='${inventory.sellingPrice}' pattern='#' />">
                                    </div>
                                </div>

                                <div class="alert alert-info p-2">
                                    <div class="d-flex justify-content-between">
                                        <small>Valeur totale du stock:</small>
                                        <strong id="totalValue">0 FCFA</strong>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-calendar text-info me-2"></i>Dates Importantes
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="manufacturingDate" class="form-label">
                                        <i class="bi bi-calendar-check me-1"></i>Date de Fabrication
                                    </label>
                                    <input type="date" class="form-control modern-input" id="manufacturingDate"
                                           name="manufacturingDate"
                                           value="${inventory.manufacturingDate}"
                                           max="${today}">
                                </div>

                                <div class="mb-3">
                                    <label for="receivedDate" class="form-label">
                                        <i class="bi bi-calendar-plus me-1"></i>Date de Réception
                                    </label>
                                    <input type="date" class="form-control modern-input" id="receivedDate"
                                           name="receivedDate"
                                           value="${inventory.receivedDate}"
                                           max="${today}">
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="expiryDate" class="form-label">
                                        <i class="bi bi-calendar-x me-1"></i>Date d'Expiration <span class="text-danger">*</span>
                                    </label>
                                    <input type="date" class="form-control modern-input" id="expiryDate"
                                           name="expiryDate" required
                                           value="${inventory.expiryDate}"
                                           min="${today}">
                                    <div class="mt-2">
                                        <small class="text-muted" id="expiryWarning"></small>
                                    </div>
                                </div>

                                <div class="alert alert-warning p-3" id="expiryAlert" style="display: none;">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                    <span id="expiryMessage"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-card-text text-secondary me-2"></i>Informations Complémentaires
                        </h5>

                        <div class="row g-3">
                            <div class="col-12">
                                <label for="notes" class="form-label">
                                    <i class="bi bi-journal-text me-1"></i>Notes
                                </label>
                                <textarea class="form-control modern-input" id="notes" name="notes"
                                          rows="3" placeholder="Notes supplémentaires...">${inventory.notes}</textarea>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-toggle-on me-1"></i>Statut
                                </label>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isActive" name="isActive"
                                    ${inventory.isActive ? 'checked' : ''}>
                                    <label class="form-check-label" for="isActive">
                                        <c:choose>
                                            <c:when test="${inventory.isActive}">
                                                <span class="text-success">Actif</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger">Inactif</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </label>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="minimumStock" class="form-label">
                                    <i class="bi bi-graph-down me-1"></i>Stock Minimum d'Alerte
                                </label>
                                <input type="number" class="form-control modern-input" id="minimumStock"
                                       name="minimumStock" min="0" value="${inventory.minimumStock}">
                            </div>
                        </div>
                    </div>

                    <div class="d-flex gap-3 justify-content-between align-items-center pt-4 border-top">
                        <div>
                            <span class="text-muted">
                                <i class="bi bi-clock-history me-1"></i>
                                <c:if test="${not empty inventory.createdAt}">
                                    Créé le: <fmt:formatDate value="${inventory.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:if>
                                <c:if test="${not empty inventory.updatedAt}">
                                    | Modifié le: <fmt:formatDate value="${inventory.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:if>
                            </span>
                        </div>

                        <div class="d-flex gap-3">
                            <a href="${pageContext.request.contextPath}/inventory"
                               class="btn btn-outline-secondary px-4">
                                <i class="bi bi-x-circle me-2"></i>Annuler
                            </a>
                            <button type="button" class="btn btn-modern btn-gradient-warning px-4"
                                    onclick="saveAsDraft()">
                                <i class="bi bi-save me-2"></i>Enregistrer brouillon
                            </button>
                            <button type="submit" class="btn btn-modern btn-gradient-primary px-4">
                                <i class="bi bi-check-circle me-2"></i>Mettre à Jour
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal de confirmation -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-exclamation-triangle text-danger me-2"></i>Confirmer la suppression
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer le lot <strong>${inventory.batchNumber}</strong> ?</p>
                <p class="text-danger">
                    <i class="bi bi-exclamation-circle me-1"></i>
                    Cette action est irréversible et supprimera toutes les données associées à ce lot.
                </p>
                <div class="form-check mt-3">
                    <input class="form-check-input" type="checkbox" id="confirmDelete">
                    <label class="form-check-label" for="confirmDelete">
                        Je confirme vouloir supprimer ce lot
                    </label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-2"></i>Annuler
                </button>
                <button type="button" class="btn btn-danger" onclick="deleteInventory()" id="deleteBtn" disabled>
                    <i class="bi bi-trash me-2"></i>Supprimer définitivement
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Fonction pour formater les montants en FCFA
    function formatFCFA(amount) {
        if (!amount || isNaN(amount) || amount === '') return '0 FCFA';

        const numAmount = parseFloat(amount);
        if (isNaN(numAmount)) return '0 FCFA';

        // Formater avec séparateurs de milliers, sans décimales
        return new Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(numAmount) + ' FCFA';
    }

    // Initialisation
    document.addEventListener('DOMContentLoaded', function() {
        calculateTotalValue();
        checkExpiryDate();
        setupFormValidation();
        updateProductInfo(document.getElementById('productId').value);
    });

    function adjustQuantity(value) {
        const input = document.getElementById('quantity');
        let currentValue = parseInt(input.value) || 0;
        let newValue = currentValue + value;

        if (newValue < 0) newValue = 0;
        if (newValue > 9999) newValue = 9999;

        input.value = newValue;
        calculateTotalValue();
        updateReservedMax();
    }

    function updateReservedMax() {
        const quantity = document.getElementById('quantity').value;
        const reserved = document.getElementById('quantityReserved');
        reserved.max = quantity;

        if (parseInt(reserved.value) > parseInt(quantity)) {
            reserved.value = quantity;
        }
    }

    function calculateTotalValue() {
        const quantity = document.getElementById('quantity').value;
        const price = document.getElementById('purchasePrice').value;
        const totalValue = (quantity * price);

        // Formater en FCFA
        document.getElementById('totalValue').textContent = formatFCFA(totalValue);
    }

    function generateBatchNumber() {
        const date = new Date();
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');

        const batchNumber = `LOT${year}${month}${day}${random}`;
        document.getElementById('batchNumber').value = batchNumber;
    }

    function checkExpiryDate() {
        const expiryDate = document.getElementById('expiryDate').value;
        if (!expiryDate) return;

        const today = new Date();
        const expiry = new Date(expiryDate);
        const diffTime = expiry - today;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

        const warningElement = document.getElementById('expiryWarning');
        const alertElement = document.getElementById('expiryAlert');
        const messageElement = document.getElementById('expiryMessage');

        if (diffDays < 0) {
            warningElement.innerHTML = '<i class="bi bi-x-circle text-danger me-1"></i>Produit expiré';
            messageElement.innerHTML = 'Ce produit est déjà expiré. Il doit être retiré de la vente.';
            alertElement.style.display = 'block';
            alertElement.className = 'alert alert-danger p-3';
        } else if (diffDays <= 30) {
            warningElement.innerHTML = `<i class="bi bi-exclamation-triangle text-warning me-1"></i>Expire dans ${diffDays} jours`;
            messageElement.innerHTML = `Ce produit expire dans ${diffDays} jours. Pensez à le vendre en priorité.`;
            alertElement.style.display = 'block';
            alertElement.className = 'alert alert-warning p-3';
        } else if (diffDays <= 90) {
            warningElement.innerHTML = `<i class="bi bi-info-circle text-info me-1"></i>Expire dans ${diffDays} jours`;
            alertElement.style.display = 'none';
        } else {
            warningElement.innerHTML = `<i class="bi bi-check-circle text-success me-1"></i>Valide (${diffDays} jours restants)`;
            alertElement.style.display = 'none';
        }
    }

    function updateProductInfo(productId) {
        const select = document.getElementById('productId');
        const option = select.selectedOptions[0];
        const price = option.getAttribute('data-price');
        const category = option.getAttribute('data-category');
        const code = option.getAttribute('data-code');

        let info = '';
        if (code) {
            info += `<span class="badge bg-secondary me-2">${code}</span>`;
        }
        if (category) {
            info += `<span class="badge bg-info me-2">${category}</span>`;
        }
        if (price) {
            // Formater le prix en FCFA
            const formattedPrice = formatFCFA(price);
            info += `<br><small class="text-muted">Prix suggéré: ${formattedPrice}</small>`;
        }

        document.getElementById('productInfo').innerHTML = info;

        // Mettre à jour le prix d'achat si vide
        if (price && !document.getElementById('purchasePrice').value) {
            document.getElementById('purchasePrice').value = parseFloat(price).toFixed(0);
            calculateTotalValue();
        }
    }

    function setupFormValidation() {
        const form = document.getElementById('editForm');

        form.addEventListener('submit', function(event) {
            const quantity = document.getElementById('quantity').value;
            const expiryDate = document.getElementById('expiryDate').value;
            const batchNumber = document.getElementById('batchNumber').value;
            const purchasePrice = document.getElementById('purchasePrice').value;

            // Validation quantité
            if (!quantity || quantity < 0) {
                alert('La quantité doit être un nombre positif');
                event.preventDefault();
                return;
            }

            // Validation date d'expiration
            if (!expiryDate) {
                alert('La date d\'expiration est obligatoire');
                event.preventDefault();
                return;
            }

            // Validation numéro de lot
            if (!batchNumber) {
                alert('Le numéro de lot est obligatoire');
                event.preventDefault();
                return;
            }

            // Validation prix d'achat (si renseigné)
            if (purchasePrice && purchasePrice < 0) {
                alert('Le prix d\'achat ne peut pas être négatif');
                event.preventDefault();
                return;
            }

            // Vérifier que la date d'expiration est future
            const today = new Date();
            const expiry = new Date(expiryDate);
            if (expiry < today) {
                if (!confirm('La date d\'expiration est passée. Souhaitez-vous quand même continuer ?')) {
                    event.preventDefault();
                    return;
                }
            }

            // Afficher un indicateur de chargement
            const submitBtn = form.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="bi bi-arrow-repeat spin me-2"></i>Enregistrement...';
            submitBtn.disabled = true;
        });
    }

    function saveAsDraft() {
        // Ajouter un champ caché pour indiquer qu'il s'agit d'un brouillon
        const draftInput = document.createElement('input');
        draftInput.type = 'hidden';
        draftInput.name = 'isDraft';
        draftInput.value = 'true';
        document.getElementById('editForm').appendChild(draftInput);

        // Soumettre le formulaire
        document.getElementById('editForm').submit();
    }

    function confirmDelete() {
        const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
        modal.show();

        // Activer/désactiver le bouton de suppression
        const confirmCheckbox = document.getElementById('confirmDelete');
        const deleteBtn = document.getElementById('deleteBtn');

        confirmCheckbox.addEventListener('change', function() {
            deleteBtn.disabled = !this.checked;
        });
    }

    function deleteInventory() {
        window.location.href = '${pageContext.request.contextPath}/inventory/delete?id=${inventory.inventoryId}';
    }

    // Mettre à jour la vérification de date d'expiration
    document.getElementById('expiryDate').addEventListener('change', checkExpiryDate);
    document.getElementById('quantity').addEventListener('input', function() {
        calculateTotalValue();
        updateReservedMax();
    });
    document.getElementById('purchasePrice').addEventListener('input', calculateTotalValue);
    document.getElementById('productId').addEventListener('change', function() {
        updateProductInfo(this.value);
    });
</script>

<style>
    .spin {
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }

    .form-check-input:checked {
        background-color: #198754;
        border-color: #198754;
    }

    .modern-input:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
    }

    .alert-warning {
        background-color: rgba(255, 193, 7, 0.1);
        border-color: rgba(255, 193, 7, 0.3);
    }

    .alert-danger {
        background-color: rgba(220, 53, 69, 0.1);
        border-color: rgba(220, 53, 69, 0.3);
    }

    .input-group-text {
        background-color: #f8f9fa;
        border-color: #dee2e6;
    }

    .badge {
        font-size: 0.75em;
        padding: 0.35em 0.65em;
    }
</style>