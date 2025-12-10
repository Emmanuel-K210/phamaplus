<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>

<%-- Désactiver le cache pour éviter les pages blanches --%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    java.time.LocalDate today = java.time.LocalDate.now();
    java.time.format.DateTimeFormatter htmlDateFormatter =
            java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");

    pageContext.setAttribute("today", today);
    pageContext.setAttribute("htmlDateFormatter", htmlDateFormatter);
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

                <!-- Vérifier que l'inventaire existe -->
                <c:choose>
                    <c:when test="${empty inventory}">
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            Lot non trouvé ou erreur de chargement.
                            <a href="${pageContext.request.contextPath}/inventory" class="alert-link">
                                Retour à l'inventaire
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>

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
                                                        data-price="${product.unitPrice}"
                                                        data-selling="${product.sellingPrice}">
                                                        ${product.productName}
                                                    <c:if test="${not empty product.genericName}">
                                                        - ${product.genericName}
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
                                                <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(-10)">-10</button>
                                                <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(-1)"><i class="bi bi-dash"></i></button>
                                                <input type="number" class="form-control modern-input text-center"
                                                       id="quantity" name="quantity" min="0" max="9999"
                                                       value="${inventory.quantityInStock}" required>
                                                <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(1)"><i class="bi bi-plus"></i></button>
                                                <button class="btn btn-outline-secondary" type="button" onclick="adjustQuantity(10)">+10</button>
                                                <span class="input-group-text">unités</span>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="quantityReserved" class="form-label">
                                                <i class="bi bi-lock me-1"></i>Quantité Réservée
                                            </label>
                                            <input type="number" class="form-control modern-input" id="quantityReserved"
                                                   name="quantityReserved" min="0"
                                                   value="${inventory.quantityReserved != null ? inventory.quantityReserved : 0}">
                                            <small class="text-muted">
                                                Disponible: <strong id="availableQty">0</strong> unités
                                            </small>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="purchasePrice" class="form-label">
                                                <i class="bi bi-cash me-1"></i>Prix d'Achat Unitaire
                                            </label>
                                            <div class="input-group">
                                                <input type="number" class="form-control modern-input" id="purchasePrice"
                                                       name="purchasePrice" step="1" min="0"
                                                       value="${inventory.purchasePrice != null ? inventory.purchasePrice : 0}">
                                                <span class="input-group-text">FCFA</span>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="sellingPrice" class="form-label">
                                                <i class="bi bi-tag me-1"></i>Prix de Vente Unitaire
                                            </label>
                                            <div class="input-group">
                                                <input type="number" class="form-control modern-input" id="sellingPrice"
                                                       name="sellingPrice" step="1" min="0"
                                                       value="${inventory.sellingPrice != null ? inventory.sellingPrice : 0}">
                                                <span class="input-group-text">FCFA</span>
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
                                                   value="<c:if test="${not empty inventory.manufacturingDate}">${inventory.manufacturingDate.format(htmlDateFormatter)}</c:if>"
                                                   max="${today.format(htmlDateFormatter)}">
                                        </div>

                                        <div class="mb-3">
                                            <label for="receivedDate" class="form-label">
                                                <i class="bi bi-calendar-plus me-1"></i>Date de Réception
                                            </label>
                                            <input type="date" class="form-control modern-input" id="receivedDate"
                                                   name="receivedDate"
                                                   value="<c:if test="${not empty inventory.receivedDate}">${inventory.receivedDate.format(htmlDateFormatter)}</c:if>"
                                                   max="${today.format(htmlDateFormatter)}">
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="expiryDate" class="form-label">
                                                <i class="bi bi-calendar-x me-1"></i>Date d'Expiration <span class="text-danger">*</span>
                                            </label>
                                            <input type="date" class="form-control modern-input" id="expiryDate"
                                                   name="expiryDate" required
                                                   value="<c:if test="${not empty inventory.expiryDate}">${inventory.expiryDate.format(htmlDateFormatter)}</c:if>"
                                                   min="${today.format(htmlDateFormatter)}">
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


                            <div class="d-flex gap-3 justify-content-end pt-4 border-top">
                                <a href="${pageContext.request.contextPath}/inventory" class="btn btn-outline-secondary px-4">
                                    <i class="bi bi-x-circle me-2"></i>Annuler
                                </a>
                                <button type="submit" class="btn btn-modern btn-gradient-primary px-4" id="submitBtn">
                                    <i class="bi bi-check-circle me-2"></i>Mettre à Jour
                                </button>
                            </div>
                        </form>

                    </c:otherwise>
                </c:choose>

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
                <p>Êtes-vous sûr de vouloir supprimer le lot <strong>${inventory.batchNumber}</strong>?</p>
                <p class="text-danger">
                    <i class="bi bi-exclamation-circle me-1"></i>
                    Cette action est irréversible.
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

<style>
    .modern-card {
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        border: 1px solid #e9ecef;
    }

    .modern-input {
        border: 2px solid #e9ecef;
        border-radius: 8px;
        transition: all 0.3s;
    }

    .modern-input:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
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

    .btn-gradient-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(102, 126, 234, 0.3);
    }

    .form-check-input:checked {
        background-color: #198754;
        border-color: #198754;
    }
</style>


<script>
    (function() {
        'use strict';

        let deleteModal = null;
        let isInitialized = false;

        // ============================================
        // FONCTIONS UTILITAIRES
        // ============================================

        function formatFCFA(amount) {
            if (amount === null || amount === undefined || amount === '' || isNaN(amount)) {
                return '0 FCFA';
            }
            const numAmount = parseFloat(amount);
            if (isNaN(numAmount)) return '0 FCFA';
            return new Intl.NumberFormat('fr-FR', {
                minimumFractionDigits: 0,
                maximumFractionDigits: 0
            }).format(numAmount) + ' FCFA';
        }

        // ============================================
        // FONCTIONS BUSINESS
        // ============================================

        function adjustQuantity(value) {
            const input = document.getElementById('quantity');
            if (!input) return;

            let currentValue = parseInt(input.value) || 0;
            let newValue = currentValue + value;

            if (newValue < 0) newValue = 0;
            if (newValue > 9999) newValue = 9999;

            input.value = newValue;
            calculateTotalValue();
            updateAvailableQuantity();
            updateReservedMax();
        }

        function updateReservedMax() {
            const quantity = document.getElementById('quantity');
            const reserved = document.getElementById('quantityReserved');

            if (!quantity || !reserved) return;

            const qty = parseInt(quantity.value) || 0;
            reserved.max = qty;

            if (parseInt(reserved.value) > qty) {
                reserved.value = qty;
            }

            updateAvailableQuantity();
        }

        function updateAvailableQuantity() {
            const quantity = parseInt(document.getElementById('quantity')?.value) || 0;
            const reserved = parseInt(document.getElementById('quantityReserved')?.value) || 0;
            const available = quantity - reserved;

            const availableElement = document.getElementById('availableQty');
            if (availableElement) {
                availableElement.textContent = available;
                if (available < 0) {
                    availableElement.className = 'text-danger fw-bold';
                } else if (available < 10) {
                    availableElement.className = 'text-warning fw-bold';
                } else {
                    availableElement.className = 'text-success fw-bold';
                }
            }
        }

        function calculateTotalValue() {
            const quantity = parseFloat(document.getElementById('quantity')?.value) || 0;
            const price = parseFloat(document.getElementById('purchasePrice')?.value) || 0;
            const totalValue = quantity * price;
            const totalElement = document.getElementById('totalValue');
            if (totalElement) {
                totalElement.textContent = formatFCFA(totalValue);
            }
        }

        function generateBatchNumber() {
            const input = document.getElementById('batchNumber');
            if (!input) return;

            const date = new Date();
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
            const batchNumber = 'LOT' + year + month + day + random;
            input.value = batchNumber;
        }

        function checkExpiryDate() {
            const expiryDateInput = document.getElementById('expiryDate');
            if (!expiryDateInput || !expiryDateInput.value) return;

            const expiryDate = expiryDateInput.value;
            const today = new Date();
            const expiry = new Date(expiryDate);
            const diffTime = expiry - today;
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

            const warningElement = document.getElementById('expiryWarning');
            const alertElement = document.getElementById('expiryAlert');
            const messageElement = document.getElementById('expiryMessage');

            if (!warningElement || !alertElement || !messageElement) return;

            if (diffDays < 0) {
                warningElement.innerHTML = '<i class="bi bi-x-circle text-danger me-1"></i>Produit expiré';
                messageElement.innerHTML = 'Ce produit est déjà expiré. Il doit être retiré de la vente.';
                alertElement.style.display = 'block';
                alertElement.className = 'alert alert-danger p-3';
            } else if (diffDays <= 30) {
                warningElement.innerHTML = '<i class="bi bi-exclamation-triangle text-warning me-1"></i>Expire dans ' + diffDays + ' jours';
                messageElement.innerHTML = 'Ce produit expire dans ' + diffDays + ' jours. Pensez à le vendre en priorité.';
                alertElement.style.display = 'block';
                alertElement.className = 'alert alert-warning p-3';
            } else if (diffDays <= 90) {
                warningElement.innerHTML = '<i class="bi bi-info-circle text-info me-1"></i>Expire dans ' + diffDays + ' jours';
                alertElement.style.display = 'none';
            } else {
                warningElement.innerHTML = '<i class="bi bi-check-circle text-success me-1"></i>Valide (' + diffDays + ' jours restants)';
                alertElement.style.display = 'none';
            }
        }

        function updateProductInfo(productId) {
            const select = document.getElementById('productId');
            if (!select) return;

            const option = select.selectedOptions[0];
            if (!option) return;

            const price = option.getAttribute('data-price');
            const sellingPrice = option.getAttribute('data-selling');

            let info = '';
            if (price) {
                info += '<small class="text-muted">Prix d\'achat suggéré: ' + formatFCFA(price) + '</small>';
            }
            if (sellingPrice) {
                if (info) info += '<br>';
                info += '<small class="text-muted">Prix de vente suggéré: ' + formatFCFA(sellingPrice) + '</small>';
            }

            const productInfoElement = document.getElementById('productInfo');
            if (productInfoElement) {
                productInfoElement.innerHTML = info;
            }

            const purchasePriceInput = document.getElementById('purchasePrice');
            if (purchasePriceInput && price && (!purchasePriceInput.value || purchasePriceInput.value === '0')) {
                purchasePriceInput.value = parseFloat(price);
                calculateTotalValue();
            }

            const sellingPriceInput = document.getElementById('sellingPrice');
            if (sellingPriceInput && sellingPrice && (!sellingPriceInput.value || sellingPriceInput.value === '0')) {
                sellingPriceInput.value = parseFloat(sellingPrice);
            }
        }

        function confirmDelete() {
            const modalElement = document.getElementById('deleteModal');
            if (!modalElement) return;

            if (typeof bootstrap !== 'undefined' && deleteModal) {
                deleteModal.show();
            }

            const confirmCheckbox = document.getElementById('confirmDelete');
            const deleteBtn = document.getElementById('deleteBtn');

            if (confirmCheckbox && deleteBtn) {
                confirmCheckbox.onchange = function() {
                    deleteBtn.disabled = !this.checked;
                };
            }
        }

        function deleteInventory() {
            const contextPath = '${pageContext.request.contextPath}';
            const inventoryId = '${inventory.inventoryId}';
            window.location.href = contextPath + '/inventory/delete?id=' + inventoryId;
        }

        // ============================================
        // VALIDATION FORMULAIRE
        // ============================================

        function setupFormValidation() {
            const form = document.getElementById('editForm');
            if (!form) return;

            form.addEventListener('submit', function(event) {
                const quantity = document.getElementById('quantity')?.value;
                const expiryDate = document.getElementById('expiryDate')?.value;
                const batchNumber = document.getElementById('batchNumber')?.value;

                if (!quantity || quantity < 0) {
                    alert('La quantité doit être un nombre positif');
                    event.preventDefault();
                    return;
                }

                if (!expiryDate) {
                    alert('La date d\'expiration est obligatoire');
                    event.preventDefault();
                    return;
                }

                if (!batchNumber) {
                    alert('Le numéro de lot est obligatoire');
                    event.preventDefault();
                    return;
                }

                const today = new Date();
                const expiry = new Date(expiryDate);
                if (expiry < today) {
                    if (!confirm('La date d\'expiration est passée. Souhaitez-vous quand même continuer?')) {
                        event.preventDefault();
                        return;
                    }
                }

                const submitBtn = document.getElementById('submitBtn');
                if (submitBtn) {
                    submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Enregistrement...';
                    submitBtn.disabled = true;
                }
            });
        }

        // ============================================
        // ÉCOUTEURS D'ÉVÉNEMENTS
        // ============================================

        function setupEventListeners() {
            const expiryDateInput = document.getElementById('expiryDate');
            const quantityInput = document.getElementById('quantity');
            const reservedInput = document.getElementById('quantityReserved');
            const purchasePriceInput = document.getElementById('purchasePrice');
            const productSelect = document.getElementById('productId');

            if (expiryDateInput) {
                expiryDateInput.addEventListener('change', checkExpiryDate);
            }

            if (quantityInput) {
                quantityInput.addEventListener('input', function() {
                    calculateTotalValue();
                    updateAvailableQuantity();
                    updateReservedMax();
                });
            }

            if (reservedInput) {
                reservedInput.addEventListener('input', updateAvailableQuantity);
            }

            if (purchasePriceInput) {
                purchasePriceInput.addEventListener('input', calculateTotalValue);
            }

            if (productSelect) {
                productSelect.addEventListener('change', function() {
                    updateProductInfo(this.value);
                });
            }
        }

        // ============================================
        // NETTOYAGE
        // ============================================

        function cleanup() {
            if (deleteModal && deleteModal._isShown) {
                deleteModal.hide();
            }
            isInitialized = false;
        }

        // ============================================
        // INITIALISATION
        // ============================================

        function initialize() {
            if (isInitialized) {
                console.log('Already initialized, skipping...');
                return;
            }

            console.log('Initializing inventory edit page...');

            try {
                isInitialized = true;

                // Initialiser la modal
                const modalElement = document.getElementById('deleteModal');
                if (modalElement && typeof bootstrap !== 'undefined') {
                    deleteModal = new bootstrap.Modal(modalElement);
                }

                // Initialiser les valeurs
                calculateTotalValue();
                updateAvailableQuantity();
                checkExpiryDate();
                setupFormValidation();

                const productSelect = document.getElementById('productId');
                if (productSelect && productSelect.value) {
                    updateProductInfo(productSelect.value);
                }

                updateReservedMax();
                setupEventListeners();

                console.log('Inventory edit page initialized successfully');
            } catch (e) {
                console.error('Error during initialization:', e);
                isInitialized = false;
            }
        }

        // Exposer les fonctions nécessaires globalement
        window.adjustQuantity = adjustQuantity;
        window.generateBatchNumber = generateBatchNumber;
        window.confirmDelete = confirmDelete;
        window.deleteInventory = deleteInventory;
        window.updateProductInfo = updateProductInfo;
        // ============================================
        // PRÉVENTION DES DOUBLES SOUMISSIONS
        // ============================================

        function preventDoubleSubmission() {
            const form = document.getElementById('editForm');
            if (!form) return;

            let isSubmitting = false;

            form.addEventListener('submit', function(e) {
                if (isSubmitting) {
                    e.preventDefault();
                    return;
                }

                isSubmitting = true;

                // Désactiver le bouton
                const submitBtn = document.getElementById('submitBtn');
                if (submitBtn) {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Traitement...';
                }

                // Permettre la soumission
                return true;
            });
        }

        // ============================================
        // GESTION DES ERREURS DE PAGE
        // ============================================

        function handlePageErrors() {
            // Vérifier si la page est vide
            setTimeout(() => {
                const mainContent = document.querySelector('.modern-card');
                if (mainContent && mainContent.children.length === 0) {
                    console.warn('Page content appears empty, attempting recovery...');
                    window.location.reload();
                }
            }, 1000);

            // Détecter les changements de navigation
            window.addEventListener('pageshow', function(event) {
                if (event.persisted) {
                    console.log('Page loaded from cache, reinitializing...');
                    initialize();
                }
            });

            // Détecter la navigation avant/arrière
            if (window.performance && window.performance.navigation) {
                const nav = window.performance.navigation;
                if (nav.type === 2) { // Navigation par historique
                    console.log('Navigated via history, reloading...');
                    setTimeout(initialize, 100);
                }
            }
        }

        // ============================================
        // INITIALISATION AVEC DÉLAI POUR LE DOM
        // ============================================

        function delayedInitialize() {
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', function() {
                    setTimeout(initialize, 100); // Petit délai pour être sûr
                });
            } else {
                setTimeout(initialize, 100);
            }
        }

        // ============================================
        // POLLING POUR LA VALIDITÉ DE LA SESSION
        // ============================================

        function startSessionMonitor() {
            // Vérifier la session toutes les 2 minutes
            setInterval(function() {
                fetch('${pageContext.request.contextPath}/api/session-check', {
                    method: 'HEAD',
                    credentials: 'include'
                }).catch(function() {
                    // Si la session est expirée, rediriger
                    if (confirm('Votre session a expiré. Rediriger vers la page de connexion?')) {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    }
                });
            }, 120000); // 2 minutes
        }

        // ============================================
        // INITIALISATION COMPLÈTE
        // ============================================

        function fullInitialize() {
            try {
                // Éviter les initialisations multiples
                if (window.pageInitialized) {
                    return;
                }
                window.pageInitialized = true;

                // Initialiser avec délai
                delayedInitialize();

                // Prévenir les doubles soumissions
                preventDoubleSubmission();

                // Gérer les erreurs de page
                handlePageErrors();

                // Démarrer le monitoring de session (optionnel)
                // startSessionMonitor();

                // Nettoyer au déchargement
                window.addEventListener('beforeunload', cleanup);
                window.addEventListener('pagehide', cleanup);

                // Forcer l'initialisation au cas où
                setTimeout(initialize, 500);

                console.log('Page initialization complete');

            } catch (error) {
                console.error('Error in full initialization:', error);
                // Réessayer après une erreur
                setTimeout(fullInitialize, 1000);
            }
        }

        // ============================================
        // DÉMARRAGE
        // ============================================

        // Démarrer l'initialisation complète
        fullInitialize();

    })();
</script>