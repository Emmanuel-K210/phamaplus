<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-plus-circle text-success me-2"></i>Nouveau Produit
                    </h2>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/products" class="text-decoration-none">
                                    <i class="bi bi-box-seam me-1"></i>Produits
                                </a>
                            </li>
                            <li class="breadcrumb-item active">Nouveau</li>
                        </ol>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Retour
                </a>
            </div>
        </div>
    </div>

    <!-- Formulaire -->
    <div class="row">
        <div class="col-lg-8 mx-auto">
            <div class="modern-card p-4">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/products/add" method="post" id="productForm">
                    <!-- Informations de base -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-info-circle text-primary me-2"></i>
                            Informations de Base
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="productName" class="form-label">
                                    <i class="bi bi-tag me-1"></i>Nom du Produit <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control modern-input" id="productName"
                                       name="productName" placeholder="Ex: Paracétamol 500mg" required>
                            </div>

                            <div class="col-md-6">
                                <label for="genericName" class="form-label">
                                    <i class="bi bi-file-text me-1"></i>Nom Générique
                                </label>
                                <input type="text" class="form-control modern-input" id="genericName"
                                       name="genericName" placeholder="Ex: Paracétamol">
                            </div>

                            <div class="col-md-6">
                                <label for="manufacturer" class="form-label">
                                    <i class="bi bi-building me-1"></i>Fabricant
                                </label>
                                <input type="text" class="form-control modern-input" id="manufacturer"
                                       name="manufacturer" placeholder="Nom du fabricant">
                            </div>

                            <div class="col-md-6">
                                <label for="categoryId" class="form-label">
                                    <i class="bi bi-folder me-1"></i>Catégorie
                                </label>
                                <select class="form-select modern-input" id="categoryId" name="categoryId">
                                    <option value="">Sélectionner une catégorie</option>
                                    <option value="1">Médicaments</option>
                                    <option value="2">Vitamines</option>
                                    <option value="3">Antibiotiques</option>
                                    <option value="4">Analgésiques</option>
                                    <option value="5">Soins</option>
                                    <option value="6">Matériel Médical</option>
                                    <option value="7">Premiers Secours</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="barcode" class="form-label">
                                    <i class="bi bi-upc-scan me-1"></i>Code-barres
                                </label>
                                <input type="text" class="form-control modern-input" id="barcode"
                                       name="barcode" placeholder="123456789">
                            </div>
                        </div>
                    </div>

                    <!-- Dosage et Forme -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-capsule text-info me-2"></i>
                            Dosage et Forme
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label for="dosageForm" class="form-label">
                                    <i class="bi bi-clipboard-pulse me-1"></i>Forme Pharmaceutique
                                </label>
                                <select class="form-select modern-input" id="dosageForm" name="dosageForm">
                                    <option value="">Sélectionner</option>
                                    <option value="Comprimé">Comprimé</option>
                                    <option value="Gélule">Gélule</option>
                                    <option value="Sirop">Sirop</option>
                                    <option value="Injection">Injection</option>
                                    <option value="Crème">Crème</option>
                                    <option value="Pommade">Pommade</option>
                                    <option value="Suppositoire">Suppositoire</option>
                                    <option value="Poudre">Poudre</option>
                                    <option value="Solution">Solution</option>
                                    <option value="Spray">Spray</option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label for="strength" class="form-label">
                                    <i class="bi bi-speedometer me-1"></i>Dosage
                                </label>
                                <input type="text" class="form-control modern-input" id="strength"
                                       name="strength" placeholder="500mg, 10ml, 5g">
                            </div>

                            <div class="col-md-4">
                                <label for="unitOfMeasure" class="form-label">
                                    <i class="bi bi-rulers me-1"></i>Unité de Mesure
                                </label>
                                <select class="form-select modern-input" id="unitOfMeasure" name="unitOfMeasure">
                                    <option value="piece" selected>unité</option>
                                    <option value="mg">mg</option>
                                    <option value="g">g</option>
                                    <option value="ml">ml</option>
                                    <option value="L">L</option>
                                    <option value="boîte">boîte</option>
                                    <option value="flacon">flacon</option>
                                    <option value="tube">tube</option>
                                    <option value="sachet">sachet</option>
                                    <option value="paquet">paquet</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Prix -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-cash-stack text-success me-2"></i>
                            Tarification
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="unitPrice" class="form-label">
                                    <i class="bi bi-cart me-1"></i>Prix d'Achat <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <input type="number" class="form-control modern-input" id="unitPrice"
                                           name="unitPrice" step="1" min="0" placeholder="0" required>
                                    <span class="input-group-text">FCFA</span>
                                </div>
                                <div class="form-text text-muted">
                                    <small>Prix d'achat unitaire</small>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="sellingPrice" class="form-label">
                                    <i class="bi bi-tag-fill me-1"></i>Prix de Vente <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <input type="number" class="form-control modern-input" id="sellingPrice"
                                           name="sellingPrice" step="1" min="0" placeholder="0" required>
                                    <span class="input-group-text">FCFA</span>
                                </div>
                                <div class="form-text">
                                    <span id="profitMargin"></span>
                                    <br>
                                    <small id="profitAmount" class="text-muted"></small>
                                </div>
                            </div>
                        </div>

                        <!-- Indicateur de marge -->
                        <div class="row mt-3">
                            <div class="col-12">
                                <div class="progress mb-2" style="height: 10px;">
                                    <div id="profitBar" class="progress-bar bg-success" role="progressbar" style="width: 0%"></div>
                                </div>
                                <div class="d-flex justify-content-between small text-muted">
                                    <span>Prix d'achat</span>
                                    <span id="profitIndicator">Marge: 0%</span>
                                    <span>Prix de vente</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Stock et Sécurité -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-boxes text-warning me-2"></i>
                            Stock et Sécurité
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="reorderLevel" class="form-label">
                                    <i class="bi bi-exclamation-triangle me-1"></i>Seuil d'alerte stock
                                </label>
                                <div class="input-group">
                                    <input type="number" class="form-control modern-input" id="reorderLevel"
                                           name="reorderLevel" min="0" value="10">
                                    <span class="input-group-text">unités</span>
                                </div>
                                <div class="form-text text-muted">
                                    <small>Alerte lorsque le stock atteint ce niveau</small>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label d-block">
                                    <i class="bi bi-shield-check me-1"></i>Exigences réglementaires
                                </label>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="requiresPrescription"
                                           name="requiresPrescription" value="true">
                                    <label class="form-check-label" for="requiresPrescription">
                                        <i class="bi bi-prescription me-1"></i>Sur ordonnance uniquement
                                    </label>
                                </div>
                                <div class="form-check form-switch mt-2">
                                    <input class="form-check-input" type="checkbox" id="isActive"
                                           name="isActive" value="true" checked>
                                    <label class="form-check-label" for="isActive">
                                        <i class="bi bi-toggle-on me-1"></i>Produit actif
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Validation et résumé -->
                    <div class="mb-4">
                        <div class="alert alert-info border-0">
                            <h6 class="alert-heading">
                                <i class="bi bi-clipboard-check me-2"></i>Résumé
                            </h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <small class="text-muted d-block">Marge bénéficiaire:</small>
                                    <strong id="summaryMargin" class="text-success">0 FCFA (0%)</strong>
                                </div>
                                <div class="col-md-6">
                                    <small class="text-muted d-block">Stock initial:</small>
                                    <strong id="summaryStock" class="text-primary">10 unités</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="d-flex gap-3 justify-content-end pt-4 border-top">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="reset" class="btn btn-outline-warning px-4" onclick="resetForm()">
                            <i class="bi bi-arrow-counterclockwise me-2"></i>Réinitialiser
                        </button>
                        <button type="submit" class="btn btn-modern btn-gradient-success px-4" id="submitBtn">
                            <i class="bi bi-check-circle me-2"></i>Enregistrer le Produit
                        </button>
                    </div>
                </form>
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

    .btn-gradient-success {
        background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        border: none;
        color: white;
    }

    .btn-gradient-success:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(17, 153, 142, 0.3);
    }

    .form-check-input:checked {
        background-color: #667eea;
        border-color: #667eea;
    }

    .progress {
        border-radius: 10px;
        overflow: hidden;
    }

    .progress-bar {
        transition: width 0.5s ease-in-out;
    }
</style>

<script>
    function formatFCFA(amount) {
        if (!amount || isNaN(amount)) return '0 FCFA';
        return new Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amount) + ' FCFA';
    }

    function calculateMargin() {
        const unitPrice = parseFloat(document.getElementById('unitPrice').value) || 0;
        const sellingPrice = parseFloat(document.getElementById('sellingPrice').value) || 0;

        if (unitPrice > 0 && sellingPrice > 0) {
            const profit = sellingPrice - unitPrice;
            const margin = ((profit / unitPrice) * 100).toFixed(1);

            const marginElement = document.getElementById('profitMargin');
            const amountElement = document.getElementById('profitAmount');
            const indicatorElement = document.getElementById('profitIndicator');
            const summaryElement = document.getElementById('summaryMargin');
            const profitBar = document.getElementById('profitBar');

            if (profit > 0) {
                marginElement.innerHTML = '<i class="bi bi-graph-up-arrow text-success me-1"></i><strong class="text-success">' + margin + '%</strong> de marge';
                amountElement.innerHTML = 'Bénéfice: <strong class="text-success">' + formatFCFA(profit) + '</strong>';
                indicatorElement.textContent = 'Marge: ' + margin + '%';
                summaryElement.innerHTML = formatFCFA(profit) + ' (' + margin + '%)';
                profitBar.className = 'progress-bar bg-success';
            } else if (profit < 0) {
                marginElement.innerHTML = '<i class="bi bi-graph-down-arrow text-danger me-1"></i><strong class="text-danger">' + margin + '%</strong> de perte';
                amountElement.innerHTML = 'Perte: <strong class="text-danger">' + formatFCFA(Math.abs(profit)) + '</strong>';
                indicatorElement.textContent = 'Perte: ' + Math.abs(margin) + '%';
                summaryElement.innerHTML = '<span class="text-danger">-' + formatFCFA(Math.abs(profit)) + ' (' + margin + '%)</span>';
                profitBar.className = 'progress-bar bg-danger';
            } else {
                marginElement.innerHTML = '<i class="bi bi-dash-circle text-warning me-1"></i><strong class="text-warning">0%</strong> de marge';
                amountElement.textContent = 'Pas de marge bénéficiaire';
                indicatorElement.textContent = 'Marge: 0%';
                summaryElement.textContent = '0 FCFA (0%)';
                profitBar.className = 'progress-bar bg-warning';
            }

            if (sellingPrice > 0) {
                const barWidth = Math.min((unitPrice / sellingPrice * 100), 100);
                profitBar.style.width = barWidth + '%';
            }
        } else {
            document.getElementById('profitMargin').innerHTML = '';
            document.getElementById('profitAmount').textContent = '';
            document.getElementById('profitIndicator').textContent = 'Marge: 0%';
            document.getElementById('summaryMargin').textContent = '0 FCFA (0%)';
            document.getElementById('profitBar').style.width = '0%';
        }
    }

    document.getElementById('reorderLevel').addEventListener('input', function() {
        const stock = this.value || 10;
        document.getElementById('summaryStock').textContent = stock + ' unités';
    });

    document.getElementById('productForm').addEventListener('submit', function(e) {
        const productName = document.getElementById('productName').value.trim();
        const unitPrice = parseFloat(document.getElementById('unitPrice').value) || 0;
        const sellingPrice = parseFloat(document.getElementById('sellingPrice').value) || 0;
        const submitBtn = document.getElementById('submitBtn');

        if (!productName) {
            e.preventDefault();
            alert('Le nom du produit est obligatoire');
            document.getElementById('productName').focus();
            return;
        }

        if (unitPrice <= 0 || sellingPrice <= 0) {
            e.preventDefault();
            alert('Les prix doivent être supérieurs à 0');
            return;
        }

        if (sellingPrice < unitPrice) {
            e.preventDefault();
            if (confirm('⚠️ Attention: Vous vendez à perte!\n\nPrix d\'achat: ' + formatFCFA(unitPrice) + '\nPrix de vente: ' + formatFCFA(sellingPrice) + '\nPerte: ' + formatFCFA(unitPrice - sellingPrice) + '\n\nVoulez-vous quand même continuer?')) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Enregistrement...';
                setTimeout(() => this.submit(), 100);
            }
            return;
        }

        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Enregistrement...';
    });

    function resetForm() {
        if (confirm('Voulez-vous réinitialiser tous les champs du formulaire?')) {
            document.getElementById('productForm').reset();
            calculateMargin();
            document.getElementById('summaryStock').textContent = '10 unités';
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('productName').focus();
        calculateMargin();

        document.getElementById('unitPrice').addEventListener('input', calculateMargin);
        document.getElementById('sellingPrice').addEventListener('input', calculateMargin);

        document.getElementById('reorderLevel').addEventListener('change', function() {
            const value = parseInt(this.value);
            if (value < 0) this.value = 0;
            if (value > 1000) this.value = 1000;
        });
    });
</script>