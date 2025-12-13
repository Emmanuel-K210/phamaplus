<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid px-0">
    <!-- En-tête avec navigation -->
    <div class="modern-header bg-gradient-primary text-white p-4 mb-4">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="mb-1">
                        <i class="bi bi-cart-plus-fill me-3"></i>Nouvelle Vente
                    </h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-white-50">Tableau de bord</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/sales" class="text-white-50">Ventes</a></li>
                            <li class="breadcrumb-item active text-white">Nouvelle transaction</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <span class="badge bg-white text-primary fs-6 px-3 py-2 me-3">
                        <i class="bi bi-clock me-2"></i><span id="currentTime"></span>
                    </span>
                    <a href="${pageContext.request.contextPath}/sales" class="btn btn-light">
                        <i class="bi bi-arrow-left me-2"></i>Retour aux ventes
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Messages d'alerte -->
    <div class="container mb-4">
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show modern-alert" role="alert">
                <div class="d-flex align-items-center">
                    <i class="bi bi-exclamation-triangle-fill fs-4 me-3"></i>
                    <div>
                        <h5 class="alert-heading mb-1">Erreur</h5>
                        <p class="mb-0">${error}</p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-warning alert-dismissible fade show modern-alert" role="alert">
                <div class="d-flex align-items-center">
                    <i class="bi bi-info-circle-fill fs-4 me-3"></i>
                    <div>
                        <h5 class="alert-heading mb-1">Information</h5>
                        <p class="mb-0">${param.error}</p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
    </div>

    <div class="container-fluid">
        <form method="post" action="${pageContext.request.contextPath}/sales/create" id="saleForm">
            <div class="row g-4">
                <!-- Colonne gauche - Recherche et panier -->
                <div class="col-lg-8">
                    <!-- Carte de recherche produit -->
                    <div class="card modern-card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3 border-0">
                            <h4 class="mb-0">
                                <i class="bi bi-search text-primary me-2"></i>Recherche de Produits
                            </h4>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <div class="input-group input-group-lg">
                                        <span class="input-group-text bg-light border-end-0">
                                            <i class="bi bi-upc-scan"></i>
                                        </span>
                                        <input type="text"
                                               id="productSearch"
                                               class="form-control modern-input border-start-0"
                                               placeholder="Rechercher par nom, code, code-barre..."
                                               autocomplete="off"
                                               autofocus>
                                    </div>
                                    <div id="searchResults" class="list-group mt-2 position-absolute w-100" style="display: none; z-index: 1050; max-width: 600px;"></div>
                                </div>

                                <div class="col-md-4">
                                    <div class="input-group input-group-lg">
                                        <span class="input-group-text bg-light border-end-0">
                                            <i class="bi bi-upc"></i>
                                        </span>
                                        <input type="text"
                                               id="barcodeInput"
                                               class="form-control modern-input border-start-0"
                                               placeholder="Scanner code-barre..."
                                               autocomplete="off">
                                    </div>
                                </div>
                            </div>

                            <!-- Produits populaires -->
                            <div class="mt-4">
                                <h6 class="text-muted mb-3">
                                    <i class="bi bi-lightning-charge me-1"></i>Produits fréquents
                                </h6>
                                <div class="d-flex flex-wrap gap-2" id="popularProductsContainer">
                                    <c:forEach var="product" items="${popularProducts}">
                                        <button type="button"
                                                class="btn btn-outline-primary d-flex align-items-center quick-add-btn"
                                                data-product-id="${product.productId}"
                                                data-product-name="${fn:escapeXml(product.productName)}"
                                                data-product-price="${product.sellingPrice}"
                                                data-product-stock="100"
                                                data-product-barcode="${product.barcode}"
                                                title="${product.productName}">
                                            <i class="bi bi-capsule me-2"></i>
                                            <span class="text-truncate" style="max-width: 120px;">
                                                    ${product.productName}
                                            </span>
                                            <span class="badge bg-primary ms-2">
                                                <fmt:formatNumber value="${product.sellingPrice}" pattern="#,##0"/> FCFA
                                            </span>
                                        </button>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Panier d'achat -->
                    <div class="card modern-card border-0 shadow-sm">
                        <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                            <h4 class="mb-0">
                                <i class="bi bi-cart3 text-success me-2"></i>Panier d'Achat
                            </h4>
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-sm btn-outline-danger" id="clearCartBtn">
                                    <i class="bi bi-trash me-1"></i>Vider
                                </button>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0" id="cartTable">
                                    <thead class="table-light">
                                    <tr>
                                        <th style="width: 35%;" class="py-3">
                                            <i class="bi bi-capsule me-2"></i>Produit
                                        </th>
                                        <th style="width: 15%;" class="py-3 text-center">
                                            <i class="bi bi-tag me-2"></i>Prix Unit.
                                        </th>
                                        <th style="width: 20%;" class="py-3 text-center">
                                            <i class="bi bi-123 me-2"></i>Quantité
                                        </th>
                                        <th style="width: 15%;" class="py-3 text-center">
                                            <i class="bi bi-calculator me-2"></i>Total
                                        </th>
                                        <th style="width: 15%;" class="py-3 text-center">
                                            <i class="bi bi-gear me-2"></i>Actions
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody id="cartItems">
                                    <tr class="empty-cart">
                                        <td colspan="5" class="text-center py-5">
                                            <div class="py-4">
                                                <i class="bi bi-cart-x text-muted" style="font-size: 4rem;"></i>
                                                <h5 class="text-muted mt-3 mb-2">Votre panier est vide</h5>
                                                <p class="text-muted mb-0">Recherchez et ajoutez des produits pour commencer</p>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Colonne droite - Résumé et paiement -->
                <div class="col-lg-4">
                    <!-- Informations client -->
                    <div class="card modern-card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3 border-0">
                            <h5 class="mb-0">
                                <i class="bi bi-person-circle text-info me-2"></i>Informations Client
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">
                                    <i class="bi bi-search me-1"></i>Rechercher un client
                                </label>
                                <div class="input-group">
                                    <input type="text"
                                           id="customerSearch"
                                           class="form-control modern-input"
                                           placeholder="Nom, téléphone..."
                                           autocomplete="off">
                                    <button type="button" class="btn btn-outline-primary" id="newCustomerBtn" title="Créer un nouveau client">
                                        <i class="bi bi-person-plus"></i>
                                    </button>
                                </div>
                                <input type="hidden" name="customerId" id="customerId">
                                <div id="customerResults" class="list-group mt-2 position-absolute w-100" style="display: none; z-index: 1050; max-width: 350px;"></div>
                            </div>

                            <div id="selectedCustomer" style="display: none;">
                                <div class="alert alert-info border-0 d-flex align-items-center justify-content-between">
                                    <div>
                                        <h6 class="mb-1" id="customerName"></h6>
                                        <small class="text-muted" id="customerPhone"></small>
                                    </div>
                                    <button type="button" class="btn-close" id="clearCustomerBtn"></button>
                                </div>
                            </div>

                            <div class="form-check form-switch mt-3">
                                <input class="form-check-input" type="checkbox" id="anonymousSale">
                                <label class="form-check-label" for="anonymousSale">
                                    <i class="bi bi-person-x me-1"></i>Vente anonyme
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Résumé financier -->
                    <div class="card modern-card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3 border-0">
                            <h5 class="mb-0">
                                <i class="bi bi-calculator-fill text-success me-2"></i>Résumé Financier
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="text-muted">Articles:</span>
                                <span class="fw-bold fs-5" id="itemCount">0</span>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="text-muted">Sous-total:</span>
                                <span class="fw-bold fs-5" id="subtotal">0 FCFA</span>
                            </div>

                            <!--<div class="mb-3">
                                <label class="form-label">
                                    <i class="bi bi-percent me-1"></i>Remise
                                </label>
                                <div class="input-group">
                                    <input type="number"
                                           class="form-control modern-input"
                                           id="discount"
                                           name="discount"
                                           value="0"
                                           min="0"
                                           step="100">
                                    <span class="input-group-text">FCFA</span>
                                </div>
                            </div>-->

                            <hr class="my-4">

                            <div class="d-flex justify-content-between align-items-center">
                                <h4>Total:</h4>
                                <h3 class="text-primary" id="grandTotal">0 FCFA</h3>
                            </div>
                        </div>
                    </div>

                    <!-- Mode de paiement -->
                    <div class="card modern-card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3 border-0">
                            <h5 class="mb-0">
                                <i class="bi bi-credit-card text-warning me-2"></i>Mode de Paiement
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-2">
                                <div class="col-6">
                                    <input type="radio" class="btn-check" name="paymentMethod" id="cash" value="cash" autocomplete="off" checked>
                                    <label class="btn btn-outline-success w-100 py-3" for="cash">
                                        <i class="bi bi-cash-coin fs-4 d-block mb-2"></i>
                                        Espèces
                                    </label>
                                </div>
                                <div class="col-6">
                                    <input type="radio" class="btn-check" name="paymentMethod" id="card" value="card" autocomplete="off">
                                    <label class="btn btn-outline-primary w-100 py-3" for="card">
                                        <i class="bi bi-credit-card fs-4 d-block mb-2"></i>
                                        Carte
                                    </label>
                                </div>
                                <div class="col-6">
                                    <input type="radio" class="btn-check" name="paymentMethod" id="mobile" value="mobile_payment" autocomplete="off">
                                    <label class="btn btn-outline-warning w-100 py-3" for="mobile">
                                        <i class="bi bi-phone fs-4 d-block mb-2"></i>
                                        Mobile
                                    </label>
                                </div>
                                <div class="col-6">
                                    <input type="radio" class="btn-check" name="paymentMethod" id="insurance" value="insurance" autocomplete="off">
                                    <label class="btn btn-outline-info w-100 py-3" for="insurance">
                                        <i class="bi bi-shield-check fs-4 d-block mb-2"></i>
                                        Assurance
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Informations complémentaires -->
                    <div class="card modern-card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3 border-0">
                            <h5 class="mb-0">
                                <i class="bi bi-info-circle text-secondary me-2"></i>Informations
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">Servi par</label>
                                <input type="text"
                                       name="servedBy"
                                       class="form-control modern-input"
                                       value="${sessionScope.user.fullName}"
                                       required
                                       readonly>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Notes (optionnel)</label>
                                <textarea class="form-control modern-input"
                                          name="notes"
                                          rows="2"
                                          placeholder="Notes supplémentaires..."></textarea>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="printReceipt" id="printReceipt" checked>
                                <label class="form-check-label" for="printReceipt">
                                    <i class="bi bi-printer me-1"></i>Imprimer le reçu
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="d-grid gap-3">
                        <button type="submit"
                                class="btn btn-success btn-lg py-3 shadow"
                                id="submitBtn"
                                disabled>
                            <i class="bi bi-check-circle-fill me-2"></i>
                            <span id="submitText">Valider la Vente</span>
                        </button>

                        <button type="button" class="btn btn-outline-secondary" id="resetFormBtn">
                            <i class="bi bi-arrow-clockwise me-2"></i>Recommencer
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Modal Nouveau Client -->
<div class="modal fade" id="newCustomerModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="bi bi-person-plus-fill me-2"></i>Nouveau Client
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="newCustomerForm">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Prénom *</label>
                            <input type="text" class="form-control" id="newFirstName" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Nom *</label>
                            <input type="text" class="form-control" id="newLastName" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Téléphone *</label>
                            <input type="tel" class="form-control" id="newPhone" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" id="newEmail">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Adresse</label>
                            <textarea class="form-control" id="newAddress" rows="2"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-1"></i>Annuler
                </button>
                <button type="button" class="btn btn-primary" id="saveCustomerBtn">
                    <i class="bi bi-check-circle me-1"></i>Enregistrer
                </button>
            </div>
        </div>
    </div>
</div>

<style>
    .modern-header {
        background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);
        border-radius: 0 0 20px 20px;
    }

    .modern-card {
        border-radius: 12px;
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .modern-input {
        border: 2px solid #e9ecef;
        border-radius: 8px;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .modern-input:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
    }

    .btn-check:checked + .btn-outline-success {
        background-color: #198754;
        color: white;
    }

    .btn-check:checked + .btn-outline-primary {
        background-color: #0d6efd;
        color: white;
    }

    .btn-check:checked + .btn-outline-warning {
        background-color: #ffc107;
        color: #000;
    }

    .btn-check:checked + .btn-outline-info {
        background-color: #0dcaf0;
        color: white;
    }

    #searchResults, #customerResults {
        max-height: 300px;
        overflow-y: auto;
        box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        border-radius: 8px;
    }

    .list-group-item:hover {
        background-color: #f8f9fa;
        cursor: pointer;
    }
</style>

<script>
(function() {
    'use strict';

    // ============================================
    // VARIABLES LOCALES
    // ============================================
    let cart = [];
    const apiBase = '${pageContext.request.contextPath}/sales/api';
    let customerModal;
    let searchTimeout;
    let customerSearchTimeout;
    let timeInterval;

    // ============================================
    // FONCTIONS UTILITAIRES
    // ============================================

    function formatFCFA(amount) {
        if (!amount || isNaN(amount)) return '0 FCFA';
        return new Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amount) + ' FCFA';
    }

    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function showNotification(message, type) {
        type = type || 'info';
        const alert = document.createElement('div');
        alert.className = 'alert alert-' + type + ' alert-dismissible fade show position-fixed';
        alert.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';

        const iconMap = {
            'success': 'bi-check-circle-fill',
            'warning': 'bi-exclamation-triangle-fill',
            'danger': 'bi-x-circle-fill',
            'info': 'bi-info-circle-fill'
        };

        alert.innerHTML = '<div class="d-flex align-items-center"><i class="bi ' + iconMap[type] + ' me-2"></i><span>' + escapeHtml(message) + '</span><button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button></div>';
        document.body.appendChild(alert);

        setTimeout(function() {
            if (alert.parentNode) {
                alert.classList.remove('show');
                setTimeout(function() {
                    if (alert.parentNode) {
                        alert.remove();
                    }
                }, 300);
            }
        }, 5000);
    }

    function updateCurrentTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
        const dateString = now.toLocaleDateString('fr-FR', {
            weekday: 'long',
            day: 'numeric',
            month: 'long',
            year: 'numeric'
        });
        const timeElement = document.getElementById('currentTime');
        if (timeElement) {
            timeElement.textContent = dateString + ' - ' + timeString;
        }
    }

    // ============================================
    // GESTION DU PANIER
    // ============================================

    function updateCart() {
        const tbody = document.getElementById('cartItems');
        const submitBtn = document.getElementById('submitBtn');

        if (!tbody || !submitBtn) return;

        if (cart.length === 0) {
            tbody.innerHTML = '<tr class="empty-cart"><td colspan="5" class="text-center py-5"><div class="py-4"><i class="bi bi-cart-x text-muted" style="font-size: 4rem;"></i><h5 class="text-muted mt-3 mb-2">Votre panier est vide</h5><p class="text-muted mb-0">Recherchez et ajoutez des produits pour commencer</p></div></td></tr>';
            submitBtn.disabled = true;
            updateSummary();
            return;
        }

        tbody.innerHTML = '';
        cart.forEach(function(item, index) {
            const lineTotal = item.price * item.quantity;
            const row = document.createElement('tr');
            row.innerHTML = '<td class="align-middle"><div class="d-flex align-items-center"><div class="bg-primary bg-opacity-10 rounded-circle p-2 me-3"><i class="bi bi-capsule text-primary"></i></div><div><strong class="d-block">' + escapeHtml(item.name) + '</strong><small class="text-muted">Stock: ' + item.stock + '</small></div></div></td>' +
                '<td class="align-middle text-center"><strong class="text-primary">' + formatFCFA(item.price) + '</strong></td>' +
                '<td class="align-middle"><div class="d-flex align-items-center justify-content-center"><div class="input-group input-group-sm" style="width: 120px;"><button class="btn btn-outline-secondary decrease-btn" type="button" data-index="' + index + '"><i class="bi bi-dash"></i></button><input type="number" class="form-control text-center quantity-input" value="' + item.quantity + '" min="1" max="' + item.stock + '" data-index="' + index + '"><button class="btn btn-outline-secondary increase-btn" type="button" data-index="' + index + '"><i class="bi bi-plus"></i></button></div></div></td>' +
                '<td class="align-middle text-center"><strong class="text-success">' + formatFCFA(lineTotal) + '</strong></td>' +
                '<td class="align-middle text-center"><button type="button" class="btn btn-sm btn-outline-danger remove-btn" data-index="' + index + '"><i class="bi bi-trash"></i></button></td>';
            tbody.appendChild(row);
        });

        submitBtn.disabled = false;
        updateSummary();
    }

    function updateQuantity(index, change) {
        if (!cart[index]) return;
        const item = cart[index];
        const newQuantity = item.quantity + change;

        if (newQuantity > 0 && newQuantity <= item.stock) {
            item.quantity = newQuantity;
            updateCart();
        } else if (newQuantity <= 0) {
            removeFromCart(index);
        } else {
            showNotification('Stock insuffisant. Maximum: ' + item.stock, 'warning');
        }
    }

    function setQuantity(index, value) {
        if (!cart[index]) return;
        const quantity = parseInt(value);
        const item = cart[index];

        if (isNaN(quantity) || quantity < 1) {
            removeFromCart(index);
            return;
        }

        if (quantity <= item.stock) {
            item.quantity = quantity;
            updateCart();
        } else {
            showNotification('Stock insuffisant. Maximum: ' + item.stock, 'warning');
            updateCart();
        }
    }

    function addToCart(product) {
        const existingItem = cart.find(function(item) { return item.id == product.id; });

        if (existingItem) {
            if (existingItem.quantity < product.stock) {
                existingItem.quantity++;
            } else {
                showNotification('Stock insuffisant pour ' + product.name, 'warning');
                return;
            }
        } else {
            if (product.stock <= 0) {
                showNotification(product.name + ' est en rupture de stock', 'warning');
                return;
            }
            cart.push({
                id: product.id,
                name: product.name,
                price: product.price,
                quantity: 1,
                stock: product.stock,
                barcode: product.barcode || ''
            });
        }

        updateCart();
        showNotification(product.name + ' ajouté au panier', 'success');
    }

    function removeFromCart(index) {
        if (!cart[index]) return;
        const itemName = cart[index].name;
        cart.splice(index, 1);
        updateCart();
        showNotification(itemName + ' retiré du panier', 'info');
    }

    function updateSummary() {
        const itemCount = cart.reduce(function(sum, item) { return sum + item.quantity; }, 0);
        const subtotal = cart.reduce(function(sum, item) { return sum + (item.price * item.quantity); }, 0);
        const discountInput = document.getElementById('discount');
        const discount = discountInput ? (parseFloat(discountInput.value) || 0) : 0;
        const total = Math.max(0, subtotal - discount);

        const itemCountEl = document.getElementById('itemCount');
        const subtotalEl = document.getElementById('subtotal');
        const grandTotalEl = document.getElementById('grandTotal');
        const submitTextEl = document.getElementById('submitText');

        if (itemCountEl) itemCountEl.textContent = itemCount;
        if (subtotalEl) subtotalEl.textContent = formatFCFA(subtotal);
        if (grandTotalEl) grandTotalEl.textContent = formatFCFA(total);
        if (submitTextEl) submitTextEl.innerHTML = 'Valider la Vente - ' + formatFCFA(total);
    }

    // ============================================
    // RECHERCHE PRODUITS
    // ============================================

    function handleProductSearch() {
        const productSearchInput = document.getElementById('productSearch');
        if (!productSearchInput) return;

        productSearchInput.addEventListener('input', function(e) {
            clearTimeout(searchTimeout);
            const query = e.target.value.trim();

            if (query.length < 2) {
                const searchResults = document.getElementById('searchResults');
                if (searchResults) searchResults.style.display = 'none';
                return;
            }

            searchTimeout = setTimeout(function() {
                fetch(apiBase + '/products?q=' + encodeURIComponent(query))
                    .then(function(response) { return response.json(); })
                    .then(function(products) { displayProductResults(products); })
                    .catch(function(error) {
                        console.error('Erreur recherche:', error);
                        showNotification('Erreur lors de la recherche', 'danger');
                    });
            }, 300);
        });
    }

    function displayProductResults(products) {
        const resultsDiv = document.getElementById('searchResults');
        if (!resultsDiv) return;

        if (!products || products.length === 0) {
            resultsDiv.style.display = 'none';
            return;
        }

        resultsDiv.innerHTML = '';
        products.forEach(function(product) {
            const item = document.createElement('a');
            item.href = '#';
            item.className = 'list-group-item list-group-item-action py-3';
            item.innerHTML = '<div class="d-flex justify-content-between align-items-center"><div><strong>' + escapeHtml(product.name) + '</strong><br><small class="text-muted">Stock: ' + product.stock + '</small></div><div class="text-end"><strong class="text-primary">' + formatFCFA(product.price) + '</strong><br><button class="btn btn-sm btn-primary mt-1">Ajouter</button></div></div>';

            item.onclick = function(e) {
                e.preventDefault();
                addToCart(product);
                document.getElementById('productSearch').value = '';
                resultsDiv.style.display = 'none';
            };
            resultsDiv.appendChild(item);
        });

        resultsDiv.style.display = 'block';
    }

    // ============================================
    // RECHERCHE CODE-BARRES
    // ============================================

    function handleBarcodeInput() {
        const barcodeInput = document.getElementById('barcodeInput');
        if (!barcodeInput) return;

        barcodeInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                const barcode = this.value.trim();
                if (barcode) {
                    fetch(apiBase + '/products?q=' + encodeURIComponent(barcode))
                        .then(function(response) { return response.json(); })
                        .then(function(products) {
                            if (products.length > 0) {
                                addToCart(products[0]);
                                barcodeInput.value = '';
                            } else {
                                showNotification('Produit non trouvé', 'warning');
                            }
                        })
                        .catch(function(error) {
                            console.error('Erreur scan:', error);
                            showNotification('Erreur lors du scan', 'danger');
                        });
                }
            }
        });
    }

    // ============================================
    // RECHERCHE CLIENTS
    // ============================================

    function handleCustomerSearch() {
        const customerSearchInput = document.getElementById('customerSearch');
        if (!customerSearchInput) return;

        customerSearchInput.addEventListener('input', function(e) {
            clearTimeout(customerSearchTimeout);
            const query = e.target.value.trim();

            if (query.length < 2) {
                const customerResults = document.getElementById('customerResults');
                if (customerResults) customerResults.style.display = 'none';
                return;
            }

            customerSearchTimeout = setTimeout(function() {
                fetch(apiBase + '/customers?q=' + encodeURIComponent(query))
                    .then(function(response) { return response.json(); })
                    .then(function(customers) { displayCustomerResults(customers); })
                    .catch(function(error) {
                        console.error('Erreur recherche clients:', error);
                    });
            }, 300);
        });
    }

    function displayCustomerResults(customers) {
        const resultsDiv = document.getElementById('customerResults');
        if (!resultsDiv) return;

        if (!customers || customers.length === 0) {
            resultsDiv.style.display = 'none';
            return;
        }

        resultsDiv.innerHTML = '';
        customers.forEach(function(customer) {
            const item = document.createElement('a');
            item.href = '#';
            item.className = 'list-group-item list-group-item-action py-2';
            item.innerHTML = '<div><strong>' + escapeHtml(customer.name) + '</strong><br><small class="text-muted">' + escapeHtml(customer.phone) + '</small></div>';

            item.onclick = function(e) {
                e.preventDefault();
                selectCustomer(customer.id, customer.name, customer.phone);
            };
            resultsDiv.appendChild(item);
        });

        resultsDiv.style.display = 'block';
    }

    function selectCustomer(id, name, phone) {
        document.getElementById('customerId').value = id;
        document.getElementById('customerName').textContent = name;
        document.getElementById('customerPhone').textContent = phone || '';
        document.getElementById('selectedCustomer').style.display = 'block';
        document.getElementById('customerSearch').style.display = 'none';
        document.getElementById('customerResults').style.display = 'none';
        document.getElementById('anonymousSale').checked = false;
        showNotification('Client sélectionné: ' + name, 'info');
    }

    // ============================================
    // SOUMISSION FORMULAIRE
    // ============================================

    function handleFormSubmission() {
        const form = document.getElementById('saleForm');
        if (!form) return;

        form.addEventListener('submit', function(e) {
            e.preventDefault();

            if (cart.length === 0) {
                showNotification('Le panier est vide', 'warning');
                return;
            }

            const anonymousSale = document.getElementById('anonymousSale');
            if (anonymousSale && anonymousSale.checked) {
                document.getElementById('customerId').value = '';
            }

            const oldInputs = form.querySelectorAll('input[name="productId[]"], input[name="quantity[]"], input[name="price[]"]');
            oldInputs.forEach(function(input) {
                if (input.parentNode) {
                    input.remove();
                }
            });

            cart.forEach(function(item) {
                ['productId', 'quantity', 'price'].forEach(function(field) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = field + '[]';
                    input.value = field === 'productId' ? item.id :
                        field === 'quantity' ? item.quantity : item.price;
                    form.appendChild(input);
                });
            });

            const submitBtn = document.getElementById('submitBtn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Traitement...';
            }

            form.submit();
        });
    }

    // ============================================
    // GESTION DES ÉVÉNEMENTS
    // ============================================

    function setupEventListeners() {
        const clearCartBtn = document.getElementById('clearCartBtn');
        if (clearCartBtn) {
            clearCartBtn.addEventListener('click', function() {
                if (cart.length === 0) return;
                if (confirm('Vider le panier (' + cart.length + ' article' + (cart.length > 1 ? 's' : '') + ') ?')) {
                    cart = [];
                    updateCart();
                    showNotification('Panier vidé', 'info');
                }
            });
        }

        const clearCustomerBtn = document.getElementById('clearCustomerBtn');
        if (clearCustomerBtn) {
            clearCustomerBtn.addEventListener('click', function() {
                document.getElementById('customerId').value = '';
                document.getElementById('selectedCustomer').style.display = 'none';
                document.getElementById('customerSearch').style.display = 'block';
                document.getElementById('customerSearch').value = '';
            });
        }

        const discountInput = document.getElementById('discount');
        if (discountInput) {
            discountInput.addEventListener('input', updateSummary);
        }

        const anonymousSale = document.getElementById('anonymousSale');
        if (anonymousSale) {
            anonymousSale.addEventListener('change', function() {
                if (this.checked) {
                    document.getElementById('customerId').value = '';
                    document.getElementById('selectedCustomer').style.display = 'none';
                    document.getElementById('customerSearch').style.display = 'block';
                }
            });
        }

        const resetFormBtn = document.getElementById('resetFormBtn');
        if (resetFormBtn) {
            resetFormBtn.addEventListener('click', function() {
                if (confirm('Recommencer une nouvelle vente ?')) {
                    cart = [];
                    updateCart();
                    document.getElementById('customerSearch').value = '';
                    document.getElementById('selectedCustomer').style.display = 'none';
                    document.getElementById('customerSearch').style.display = 'block';
                    document.getElementById('discount').value = '0';
                    document.getElementById('cash').checked = true;
                    const productSearch = document.getElementById('productSearch');
                    if (productSearch) productSearch.focus();
                }
            });
        }

        const newCustomerBtn = document.getElementById('newCustomerBtn');
        if (newCustomerBtn && customerModal) {
            newCustomerBtn.addEventListener('click', function() {
                customerModal.show();
            });
        }

        const saveCustomerBtn = document.getElementById('saveCustomerBtn');
        if (saveCustomerBtn) {
            saveCustomerBtn.addEventListener('click', saveNewCustomer);
        }

        document.addEventListener('click', function(e) {
            if (e.target.closest('.quick-add-btn')) {
                const button = e.target.closest('.quick-add-btn');
                addToCart({
                    id: button.getAttribute('data-product-id'),
                    name: button.getAttribute('data-product-name'),
                    price: parseFloat(button.getAttribute('data-product-price')),
                    stock: parseInt(button.getAttribute('data-product-stock')),
                    barcode: button.getAttribute('data-product-barcode') || ''
                });
            }

            if (e.target.closest('.decrease-btn')) {
                const index = parseInt(e.target.closest('.decrease-btn').getAttribute('data-index'));
                updateQuantity(index, -1);
            }

            if (e.target.closest('.increase-btn')) {
                const index = parseInt(e.target.closest('.increase-btn').getAttribute('data-index'));
                updateQuantity(index, 1);
            }

            if (e.target.closest('.remove-btn')) {
                const index = parseInt(e.target.closest('.remove-btn').getAttribute('data-index'));
                removeFromCart(index);
            }

            const searchResults = document.getElementById('searchResults');
            const productSearch = document.getElementById('productSearch');
            const customerResults = document.getElementById('customerResults');
            const customerSearch = document.getElementById('customerSearch');

            if (searchResults && !searchResults.contains(e.target) && e.target !== productSearch) {
                searchResults.style.display = 'none';
            }

            if (customerResults && !customerResults.contains(e.target) && e.target !== customerSearch) {
                customerResults.style.display = 'none';
            }
        });

        document.addEventListener('input', function(e) {
            if (e.target.classList.contains('quantity-input')) {
                const index = parseInt(e.target.getAttribute('data-index'));
                setQuantity(index, e.target.value);
            }
        });

        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key === 'f') {
                e.preventDefault();
                const productSearch = document.getElementById('productSearch');
                if (productSearch) productSearch.focus();
            }
        });
    }

    function saveNewCustomer() {
        const firstName = document.getElementById('newFirstName').value.trim();
        const lastName = document.getElementById('newLastName').value.trim();
        const phone = document.getElementById('newPhone').value.trim();

        if (!firstName || !lastName || !phone) {
            showNotification('Veuillez remplir tous les champs obligatoires', 'warning');
            return;
        }

        const customerData = {
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            email: document.getElementById('newEmail').value.trim(),
            address: document.getElementById('newAddress').value.trim()
        };

        fetch('${pageContext.request.contextPath}/customers/create', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams(customerData)
        })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.success) {
                    selectCustomer(data.customerId, firstName + ' ' + lastName, phone);
                    customerModal.hide();
                    document.getElementById('newCustomerForm').reset();
                    showNotification('Client créé avec succès', 'success');
                } else {
                    showNotification('Erreur: ' + data.message, 'danger');
                }
            })
            .catch(function(error) {
                console.error('Erreur:', error);
                showNotification('Erreur lors de la création du client', 'danger');
            });
    }

    // ============================================
    // NETTOYAGE
    // ============================================

    function cleanup() {
        clearTimeout(searchTimeout);
        clearTimeout(customerSearchTimeout);
        if (timeInterval) clearInterval(timeInterval);

        const searchResults = document.getElementById('searchResults');
        const customerResults = document.getElementById('customerResults');
        if (searchResults) searchResults.style.display = 'none';
        if (customerResults) customerResults.style.display = 'none';

        if (customerModal && customerModal._isShown) {
            customerModal.hide();
        }

        cart = [];
    }

    // ============================================
    // INITIALISATION
    // ============================================

    function initialize() {
        cleanup();

        const modalElement = document.getElementById('newCustomerModal');
        if (modalElement && typeof bootstrap !== 'undefined') {
            customerModal = new bootstrap.Modal(modalElement);
        }

        updateCurrentTime();
        timeInterval = setInterval(updateCurrentTime, 60000);

        handleProductSearch();
        handleBarcodeInput();
        handleCustomerSearch();
        handleFormSubmission();
        setupEventListeners();

        updateSummary();

        setTimeout(function() {
            const productSearch = document.getElementById('productSearch');
            if (productSearch) productSearch.focus();
        }, 100);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        initialize();
    }

    window.addEventListener('beforeunload', cleanup);
    window.addEventListener('pagehide', cleanup);

})();
</script>