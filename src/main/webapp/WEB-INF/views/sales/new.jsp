<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    // Définir la date du jour pour les champs date
    java.time.LocalDate today = java.time.LocalDate.now();
    pageContext.setAttribute("today", today);
%>

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
                                    <div id="searchResults" class="list-group mt-2 position-absolute w-100" style="display: none; z-index: 1050;"></div>
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
                                <div class="d-flex flex-wrap gap-2">
                                    <c:forEach var="product" items="${popularProducts}" varStatus="status">
                                        <button type="button"
                                                class="btn btn-outline-primary d-flex align-items-center"
                                                onclick="quickAddProduct(${product.productId}, '${fn:escapeXml(product.productName)}', ${product.sellingPrice})"
                                                title="${product.productName} - ${product.sellingPrice} FCFA">
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
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="printCart()">
                                    <i class="bi bi-printer me-1"></i>Imprimer
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="clearCart()">
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
                                    <button type="button" class="btn btn-outline-primary" onclick="newCustomer()">
                                        <i class="bi bi-person-plus"></i>
                                    </button>
                                </div>
                                <input type="hidden" name="customerId" id="customerId">
                                <div id="customerResults" class="list-group mt-2 position-absolute w-100" style="display: none; z-index: 1050;"></div>
                            </div>

                            <div id="selectedCustomer" style="display: none;">
                                <div class="alert alert-info border-0 d-flex align-items-center justify-content-between">
                                    <div>
                                        <h6 class="mb-1" id="customerName"></h6>
                                        <small class="text-muted" id="customerPhone"></small>
                                    </div>
                                    <button type="button" class="btn-close" onclick="clearCustomer()"></button>
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

                            <div class="mb-3">
                                <label class="form-label">
                                    <i class="bi bi-percent me-1"></i>Remise
                                </label>
                                <div class="input-group">
                                    <input type="number"
                                           class="form-control modern-input"
                                           id="discount"
                                           value="0"
                                           min="0"
                                           step="100"
                                           onchange="updateSummary()">
                                    <span class="input-group-text">FCFA</span>
                                    <button type="button" class="btn btn-outline-secondary" onclick="applyDiscount(500)">
                                        500
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" onclick="applyDiscount(1000)">
                                        1K
                                    </button>
                                </div>
                            </div>

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
                                    <input type="radio" class="btn-check" name="paymentMethod" id="mobile" value="mobile" autocomplete="off">
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
                            <span id="submitLoading" style="display: none;">
                                <i class="bi bi-arrow-repeat spin me-2"></i>Traitement...
                            </span>
                        </button>

                        <div class="d-grid gap-2">
                            <button type="button" class="btn btn-outline-primary" onclick="saveAsDraft()">
                                <i class="bi bi-save me-2"></i>Enregistrer comme brouillon
                            </button>
                            <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                                <i class="bi bi-arrow-clockwise me-2"></i>Recommencer
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Modal pour nouveau client -->
<div class="modal fade" id="newCustomerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-person-plus text-primary me-2"></i>Nouveau Client
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="newCustomerForm">
                    <div class="mb-3">
                        <label class="form-label">Nom complet *</label>
                        <input type="text" class="form-control modern-input" id="newCustomerName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Téléphone *</label>
                        <input type="tel" class="form-control modern-input" id="newCustomerPhone" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control modern-input" id="newCustomerEmail">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Adresse</label>
                        <textarea class="form-control modern-input" id="newCustomerAddress" rows="2"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-2"></i>Annuler
                </button>
                <button type="button" class="btn btn-primary" onclick="saveNewCustomer()">
                    <i class="bi bi-check-circle me-2"></i>Enregistrer
                </button>
            </div>
        </div>
    </div>
</div>

<style>
    .modern-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 0 0 20px 20px;
    }

    .modern-card {
        border-radius: 12px;
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .modern-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.1) !important;
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

    .modern-alert {
        border-radius: 12px;
        border: none;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
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

    .spin {
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
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

    .table th {
        font-weight: 600;
        color: #495057;
    }

    .btn-lg {
        padding: 1rem 2rem;
        font-size: 1.1rem;
        font-weight: 600;
    }
</style>

<script >

    let cart = [];
    let searchTimeouts = {};
    const apiBase = '${pageContext.request.contextPath}/sales/api';

    // Initialisation
    document.addEventListener('DOMContentLoaded', function() {
        updateCurrentTime();
        setInterval(updateCurrentTime, 60000); // Mettre à jour chaque minute

        // Charger le panier depuis localStorage si disponible
        loadCartFromStorage();

        // Focus sur la recherche
        document.getElementById('productSearch').focus();

        // Configuration des shortcuts clavier
        setupKeyboardShortcuts();
    });

    function updateCurrentTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('fr-FR', {
            hour: '2-digit',
            minute: '2-digit'
        });
        const dateString = now.toLocaleDateString('fr-FR', {
            weekday: 'long',
            day: 'numeric',
            month: 'long',
            year: 'numeric'
        });

        document.getElementById('currentTime').textContent =
            `${dateString} - ${timeString}`;
    }

    function setupKeyboardShortcuts() {
        document.addEventListener('keydown', function(e) {
            // Ctrl + F : Focus sur la recherche
            if (e.ctrlKey && e.key === 'f') {
                e.preventDefault();
                document.getElementById('productSearch').focus();
            }

            // Ctrl + B : Focus sur le code-barre
            if (e.ctrlKey && e.key === 'b') {
                e.preventDefault();
                document.getElementById('barcodeInput').focus();
            }

            // Ctrl + Enter : Valider la vente
            if (e.ctrlKey && e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('saleForm').requestSubmit();
            }

            // Échap : Vider le panier
            if (e.key === 'Escape') {
                if (confirm('Vider le panier ?')) {
                    clearCart();
                }
            }
        });
    }

    // ============ GESTION PRODUITS ============

    // Recherche de produits
    document.getElementById('productSearch').addEventListener('input', function(e) {
        clearTimeout(searchTimeouts.productSearch);
        const query = e.target.value.trim();

        if (query.length < 2) {
            document.getElementById('searchResults').style.display = 'none';
            return;
        }

        searchTimeouts.productSearch = setTimeout(() => {
            fetch(`${apiBase}/products?q=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(products => displayProductResults(products))
                .catch(error => console.error('Erreur recherche produits:', error));
        }, 300);
    });

    // Recherche par code-barre
    document.getElementById('barcodeInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            const barcode = this.value.trim();

            if (barcode) {
                fetch(`${apiBase}/products?q=${encodeURIComponent(barcode)}`)
                    .then(response => response.json())
                    .then(products => {
                        if (products.length > 0) {
                            addToCart(products[0]);
                            this.value = '';
                            showNotification('Produit ajouté au panier', 'success');
                        } else {
                            showNotification('Produit non trouvé', 'warning');
                        }
                    })
                    .catch(error => {
                        console.error('Erreur scan code-barre:', error);
                        showNotification('Erreur lors du scan', 'danger');
                    });
            }
        }
    });

    function displayProductResults(products) {
        const resultsDiv = document.getElementById('searchResults');

        if (!products || products.length === 0) {
            resultsDiv.style.display = 'none';
            return;
        }

        resultsDiv.innerHTML = '';
        products.forEach(product => {
            const item = document.createElement('a');
            item.href = '#';
            item.className = 'list-group-item list-group-item-action py-3';

            // Échapper les caractères spéciaux pour le HTML
            const productName = escapeHtml(product.name || '');
            const barcode = escapeHtml(product.barcode || 'N/A');
            const stock = product.stock || 0;
            const price = product.price || 0;

            item.innerHTML = `
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="d-flex align-items-center">
                            <i class="bi bi-capsule text-primary me-3 fs-5"></i>
                            <div>
                                <strong class="d-block">${productName}</strong>
                                <small class="text-muted">
                                    <i class="bi bi-upc me-1"></i>${barcode}
                                    <span class="mx-2">•</span>
                                    <i class="bi bi-box me-1"></i>Stock: ${stock}
                                </small>
                            </div>
                        </div>
                    </div>
                    <div class="text-end">
                        <strong class="text-primary d-block fs-5">
                            ${formatNumber(price)} FCFA
                        </strong>
                        <button class="btn btn-sm btn-primary mt-1" onclick="event.stopPropagation(); addProductToCart('${product.id}', '${productName}', ${price}, ${stock}, '${barcode}')">
                            <i class="bi bi-plus-circle me-1"></i>Ajouter
                        </button>
                    </div>
                </div>
            `;

            item.onclick = function(e) {
                e.preventDefault();
                addToCart(product);
                document.getElementById('productSearch').value = '';
                resultsDiv.style.display = 'none';
                document.getElementById('productSearch').focus();
            };

            resultsDiv.appendChild(item);
        });

        resultsDiv.style.display = 'block';
    }

    function addProductToCart(id, name, price, stock, barcode) {
        addToCart({
            id: id,
            name: name,
            price: price,
            stock: stock,
            barcode: barcode
        });
    }

    function quickAddProduct(productId, productName, price) {
        // Récupérer les informations produit depuis l'API
        fetch(`${apiBase}/products?id=${productId}`)
            .then(response => response.json())
            .then(product => {
                if (product) {
                    addToCart({
                        id: product.id,
                        name: product.name || productName,
                        price: product.price || price,
                        stock: product.stock || 100,
                        barcode: product.barcode || ''
                    });
                } else {
                    // Fallback si l'API ne répond pas
                    addToCart({
                        id: productId,
                        name: productName,
                        price: price,
                        stock: 100, // Valeur par défaut
                        barcode: ''
                    });
                }
            })
            .catch(error => {
                console.error('Erreur récupération produit:', error);
                // Fallback avec les données de base
                addToCart({
                    id: productId,
                    name: productName,
                    price: price,
                    stock: 100,
                    barcode: ''
                });
            });
    }
    // ============ GESTION PANIER ============

    function addToCart(product) {
        const existingItem = cart.find(item => item.id == product.id);

        if (existingItem) {
            if (existingItem.quantity < product.stock) {
                existingItem.quantity++;
            } else {
                showNotification(`Stock insuffisant pour ${product.name}. Stock disponible: ${product.stock}`, 'warning');
                return;
            }
        } else {
            if (product.stock <= 0) {
                showNotification(`${product.name} est en rupture de stock`, 'warning');
                return;
            }

            cart.push({
                id: product.id,
                name: product.name,
                price: product.price,
                quantity: 1,
                stock: product.stock,
                barcode: product.barcode
            });
        }

        updateCart();
        saveCartToStorage();
        showNotification(`${product.name} ajouté au panier`, 'success');
    }

    function updateCart() {
        const tbody = document.getElementById('cartItems');

        if (cart.length === 0) {
            tbody.innerHTML = `
                <tr class="empty-cart">
                    <td colspan="5" class="text-center py-5">
                        <div class="py-4">
                            <i class="bi bi-cart-x text-muted" style="font-size: 4rem;"></i>
                            <h5 class="text-muted mt-3 mb-2">Votre panier est vide</h5>
                            <p class="text-muted mb-0">Recherchez et ajoutez des produits pour commencer</p>
                        </div>
                    </td>
                </tr>
            `;
            document.getElementById('submitBtn').disabled = true;
            updateSummary();
            return;
        }

        tbody.innerHTML = '';
        cart.forEach((item, index) => {
            const lineTotal = item.price * item.quantity;
            const itemName = escapeHtml(item.name);
            const barcode = escapeHtml(item.barcode || 'N/A');

            const row = document.createElement('tr');
            row.innerHTML = `
                <td class="align-middle">
                    <div class="d-flex align-items-center">
                        <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-3">
                            <i class="bi bi-capsule text-primary"></i>
                        </div>
                        <div>
                            <strong class="d-block">${itemName}</strong>
                            <small class="text-muted">
                                <i class="bi bi-upc me-1"></i>${barcode}
                                <span class="mx-2">•</span>
                                Stock: ${item.stock}
                            </small>
                        </div>
                    </div>
                </td>
                <td class="align-middle text-center">
                    <strong class="text-primary">${formatNumber(item.price)}</strong>
                    <br><small class="text-muted">FCFA</small>
                </td>
                <td class="align-middle">
                    <div class="d-flex align-items-center justify-content-center">
                        <div class="input-group input-group-sm" style="width: 120px;">
                            <button class="btn btn-outline-secondary" type="button" onclick="updateQuantity(${index}, -1)">
                                <i class="bi bi-dash"></i>
                            </button>
                            <input type="number" class="form-control text-center" value="${item.quantity}"
                                   min="1" max="${item.stock}" onchange="setQuantity(${index}, this.value)"
                                   style="background: #f8f9fa;">
                            <button class="btn btn-outline-secondary" type="button" onclick="updateQuantity(${index}, 1)">
                                <i class="bi bi-plus"></i>
                            </button>
                        </div>
                    </div>
                </td>
                <td class="align-middle text-center">
                    <strong class="text-success">${formatNumber(lineTotal)}</strong>
                    <br><small class="text-muted">FCFA</small>
                </td>
                <td class="align-middle text-center">
                    <div class="btn-group">
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="updateQuantity(${index}, 10)" title="Ajouter 10">
                            <i class="bi bi-plus-lg"></i>10
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeFromCart(${index})" title="Supprimer">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </td>
            `;
            tbody.appendChild(row);
        });

        document.getElementById('submitBtn').disabled = false;
        updateSummary();
    }

    function updateQuantity(index, change) {
        const item = cart[index];
        const newQuantity = item.quantity + change;

        if (newQuantity > 0 && newQuantity <= item.stock) {
            item.quantity = newQuantity;
            updateCart();
            saveCartToStorage();
        } else if (newQuantity <= 0) {
            removeFromCart(index);
        } else {
            showNotification(`Stock insuffisant. Maximum: ${item.stock}`, 'warning');
        }
    }

    function setQuantity(index, value) {
        const quantity = parseInt(value);
        const item = cart[index];

        if (isNaN(quantity) || quantity < 1) {
            removeFromCart(index);
            return;
        }

        if (quantity <= item.stock) {
            item.quantity = quantity;
            updateCart();
            saveCartToStorage();
        } else {
            showNotification(`Stock insuffisant. Maximum: ${item.stock}`, 'warning');
            updateCart(); // Réinitialiser la valeur
        }
    }

    function removeFromCart(index) {
        const itemName = cart[index].name;
        cart.splice(index, 1);
        updateCart();
        saveCartToStorage();
        showNotification(`${itemName} retiré du panier`, 'info');
    }

    function clearCart() {
        if (cart.length === 0) return;

        if (confirm(`Voulez-vous vraiment vider le panier ? (${cart.length} article${cart.length > 1 ? 's' : ''})`)) {
            cart = [];
            updateCart();
            localStorage.removeItem('saleCart');
            showNotification('Panier vidé', 'info');
        }
    }

    function printCart() {
        // Implémentation basique d'impression
        window.print();
    }

    // ============ GESTION CLIENTS ============

    document.getElementById('customerSearch').addEventListener('input', function(e) {
        clearTimeout(searchTimeouts.customerSearch);
        const query = e.target.value.trim();

        if (query.length < 2) {
            document.getElementById('customerResults').style.display = 'none';
            return;
        }

        searchTimeouts.customerSearch = setTimeout(() => {
            fetch(`${apiBase}/customers?q=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(customers => displayCustomerResults(customers))
                .catch(error => console.error('Erreur recherche clients:', error));
        }, 300);
    });

    function displayCustomerResults(customers) {
        const resultsDiv = document.getElementById('customerResults');

        if (!customers || customers.length === 0) {
            resultsDiv.style.display = 'none';
            return;
        }

        resultsDiv.innerHTML = '';
        customers.forEach(customer => {
            const item = document.createElement('a');
            item.href = '#';
            item.className = 'list-group-item list-group-item-action py-3';

            const customerName = escapeHtml(customer.name || '');
            const customerPhone = escapeHtml(customer.phone || 'N/A');
            const customerEmail = escapeHtml(customer.email || '');

            // Construire l'HTML avec condition pour l'email
            let emailHtml = '';
            if (customerEmail) {
                emailHtml = `<span class="mx-2">•</span><i class="bi bi-envelope me-1"></i>${customerEmail}`;
            }

            item.innerHTML = `
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="d-flex align-items-center">
                            <i class="bi bi-person-circle text-info me-3 fs-5"></i>
                            <div>
                                <strong class="d-block">${customerName}</strong>
                                <small class="text-muted">
                                    <i class="bi bi-telephone me-1"></i>${customerPhone}
                                    ${emailHtml}
                                </small>
                            </div>
                        </div>
                    </div>
                    <button class="btn btn-sm btn-outline-primary" onclick="event.stopPropagation(); selectCustomer('${customer.id}', '${customerName}', '${customerPhone}')">
                        <i class="bi bi-check-circle me-1"></i>Sélectionner
                    </button>
                </div>
            `;

            item.onclick = function(e) {
                e.preventDefault();
                selectCustomer(customer.id, customerName, customerPhone);
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

        // Désactiver la vente anonyme
        document.getElementById('anonymousSale').checked = false;

        showNotification(`Client sélectionné: ${name}`, 'info');
    }

    function clearCustomer() {
        document.getElementById('customerId').value = '';
        document.getElementById('selectedCustomer').style.display = 'none';
        document.getElementById('customerSearch').style.display = 'block';
        document.getElementById('customerSearch').value = '';
        showNotification('Client désélectionné', 'info');
    }

    function newCustomer() {
        const modal = new bootstrap.Modal(document.getElementById('newCustomerModal'));
        modal.show();
    }

    function saveNewCustomer() {
        const name = document.getElementById('newCustomerName').value;
        const phone = document.getElementById('newCustomerPhone').value;

        if (!name || !phone) {
            showNotification('Nom et téléphone sont obligatoires', 'warning');
            return;
        }

        // Ici, vous devriez appeler une API pour créer le client
        // Pour l'instant, on simule avec un objet
        const newCustomer = {
            id: Date.now(), // ID temporaire
            name: name,
            phone: phone,
            email: document.getElementById('newCustomerEmail').value || ''
        };

        // Fermer le modal
        bootstrap.Modal.getInstance(document.getElementById('newCustomerModal')).hide();

        // Sélectionner le nouveau client
        selectCustomer(newCustomer.id, newCustomer.name, newCustomer.phone);

        showNotification(`Nouveau client créé: ${name}`, 'success');
    }

    // ============ CALCULS ET RÉSUMÉ ============

    function updateSummary() {
        const itemCount = cart.reduce((sum, item) => sum + item.quantity, 0);
        const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
        const discount = parseFloat(document.getElementById('discount').value) || 0;
        const total = Math.max(0, subtotal - discount);

        document.getElementById('itemCount').textContent = itemCount;
        document.getElementById('subtotal').textContent = formatNumber(subtotal) + ' FCFA';
        document.getElementById('grandTotal').textContent = formatNumber(total) + ' FCFA';

        // Mettre à jour le texte du bouton avec le total
        const submitText = document.getElementById('submitText');
        submitText.innerHTML = `Valider la Vente - ${formatNumber(total)} FCFA`;
    }

    function applyDiscount(amount) {
        document.getElementById('discount').value = amount;
        updateSummary();
    }

    // ============ GESTION STOCKAGE ============

    function saveCartToStorage() {
        try {
            localStorage.setItem('saleCart', JSON.stringify(cart));
        } catch (e) {
            console.error('Erreur sauvegarde panier:', e);
        }
    }

    function loadCartFromStorage() {
        try {
            const savedCart = localStorage.getItem('saleCart');
            if (savedCart) {
                cart = JSON.parse(savedCart);
                updateCart();

                if (cart.length > 0) {
                    showNotification(`Panier restauré (${cart.length} article${cart.length > 1 ? 's' : ''})`, 'info');
                }
            }
        } catch (e) {
            console.error('Erreur chargement panier:', e);
            localStorage.removeItem('saleCart');
        }
    }

    // ============ SOUMISSION FORMULAIRE ============

    document.getElementById('saleForm').addEventListener('submit', function(e) {
        e.preventDefault();

        if (cart.length === 0) {
            showNotification('Le panier est vide', 'warning');
            return;
        }

        // Vérifier si la vente est anonyme
        if (document.getElementById('anonymousSale').checked) {
            document.getElementById('customerId').value = '';
        }

        // Créer les champs cachés pour les items
        cart.forEach(item => {
            // Product ID
            const productInput = document.createElement('input');
            productInput.type = 'hidden';
            productInput.name = 'productId[]';
            productInput.value = item.id;
            this.appendChild(productInput);

            // Quantity
            const quantityInput = document.createElement('input');
            quantityInput.type = 'hidden';
            quantityInput.name = 'quantity[]';
            quantityInput.value = item.quantity;
            this.appendChild(quantityInput);

            // Price
            const priceInput = document.createElement('input');
            priceInput.type = 'hidden';
            priceInput.name = 'price[]';
            priceInput.value = item.price;
            this.appendChild(priceInput);
        });

        // Afficher l'indicateur de chargement
        const submitBtn = document.getElementById('submitBtn');
        const submitText = document.getElementById('submitText');
        const submitLoading = document.getElementById('submitLoading');

        submitText.style.display = 'none';
        submitLoading.style.display = 'inline';
        submitBtn.disabled = true;

        // Soumettre le formulaire
        setTimeout(() => {
            this.submit();
        }, 500);
    });

    // ============ FONCTIONS UTILITAIRES ============

    function formatNumber(amount) {
        if (!amount || isNaN(amount)) return '0';
        return new Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amount);
    }

    function escapeHtml(text) {
        if (!text) return '';
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;',
            '`': '&#x60;',
            '=': '&#x3D;'
        };
        return text.replace(/[&<>"'`=]/g, function(m) { return map[m]; });
    }

    function showNotification(message, type = 'info') {
        // Créer une notification simple
        const alert = document.createElement('div');
        alert.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
        alert.style.cssText = `
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            border-radius: 8px;
        `;

        alert.innerHTML = `
            <div class="d-flex align-items-center">
                <i class="bi ${type == 'success' ? 'bi-check-circle-fill' :
                                  type == 'warning' ? 'bi-exclamation-triangle-fill' :
                                  type == 'danger' ? 'bi-x-circle-fill' : 'bi-info-circle-fill'}
                     me-2 fs-5"></i>
                <span class="flex-grow-1">${escapeHtml(message)}</span>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;

        document.body.appendChild(alert);

        // Auto-dismiss après 5 secondes
        setTimeout(() => {
            if (alert.parentNode) {
                alert.classList.remove('show');
                setTimeout(() => alert.remove(), 300);
            }
        }, 5000);
    }

    function resetForm() {
        if (confirm('Recommencer une nouvelle vente ? Le panier actuel sera vidé.')) {
            cart = [];
            updateCart();
            localStorage.removeItem('saleCart');
            document.getElementById('customerSearch').value = '';
            clearCustomer();
            document.getElementById('discount').value = '0';
            document.getElementById('cash').checked = true;
            document.getElementById('productSearch').focus();
            showNotification('Formulaire réinitialisé', 'info');
        }
    }

    function saveAsDraft() {
        if (cart.length === 0) {
            showNotification('Le panier est vide', 'warning');
            return;
        }

        // Sauvegarder le panier comme brouillon
        const draft = {
            cart: cart,
            customerId: document.getElementById('customerId').value,
            discount: document.getElementById('discount').value,
            paymentMethod: document.querySelector('input[name="paymentMethod"]:checked').value,
            timestamp: new Date().toISOString()
        };

        try {
            localStorage.setItem('saleDraft', JSON.stringify(draft));
            showNotification('Vente sauvegardée comme brouillon', 'success');
        } catch (e) {
            console.error('Erreur sauvegarde brouillon:', e);
            showNotification('Erreur sauvegarde brouillon', 'danger');
        }
    }

    // Écouteurs d'événements
    document.getElementById('discount').addEventListener('input', updateSummary);
    document.getElementById('anonymousSale').addEventListener('change', function() {
        if (this.checked) {
            clearCustomer();
            showNotification('Vente anonyme activée', 'info');
        }
    });

    // Initialiser le résumé
    updateSummary();
</script>
