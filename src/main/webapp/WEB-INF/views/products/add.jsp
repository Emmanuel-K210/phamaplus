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
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label for="strength" class="form-label">
                                    <i class="bi bi-speedometer me-1"></i>Dosage
                                </label>
                                <input type="text" class="form-control modern-input" id="strength"
                                       name="strength" placeholder="500mg">
                            </div>

                            <div class="col-md-4">
                                <label for="unitOfMeasure" class="form-label">
                                    <i class="bi bi-rulers me-1"></i>Unité de Mesure
                                </label>
                                <select class="form-select modern-input" id="unitOfMeasure" name="unitOfMeasure">
                                    <option value="">Sélectionner</option>
                                    <option value="mg">mg</option>
                                    <option value="g">g</option>
                                    <option value="ml">ml</option>
                                    <option value="unité">unité</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Prix -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-3 mb-3">
                            <i class="bi bi-currency-euro text-success me-2"></i>
                            Tarification
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="unitPrice" class="form-label">
                                    <i class="bi bi-cash me-1"></i>Prix d'Achat (€) <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-currency-euro"></i>
                                    </span>
                                    <input type="number" class="form-control modern-input" id="unitPrice"
                                           name="unitPrice" step="0.01" min="0" placeholder="0.00" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="sellingPrice" class="form-label">
                                    <i class="bi bi-tag-fill me-1"></i>Prix de Vente (€) <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-currency-euro"></i>
                                    </span>
                                    <input type="number" class="form-control modern-input" id="sellingPrice"
                                           name="sellingPrice" step="0.01" min="0" placeholder="0.00" required>
                                </div>
                                <div class="form-text">
                                    <span id="profitMargin"></span>
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
                                    <i class="bi bi-arrow-repeat me-1"></i>Niveau de Réapprovisionnement
                                </label>
                                <input type="number" class="form-control modern-input" id="reorderLevel"
                                       name="reorderLevel" min="0" value="10">
                                <div class="form-text">Alerte si stock inférieur à cette valeur</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label d-block">
                                    <i class="bi bi-shield-check me-1"></i>Exigences
                                </label>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="requiresPrescription"
                                           name="requiresPrescription" value="true">
                                    <label class="form-check-label" for="requiresPrescription">
                                        Nécessite une ordonnance
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="d-flex gap-3 justify-content-end pt-4 border-top">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="reset" class="btn btn-outline-warning px-4">
                            <i class="bi bi-arrow-counterclockwise me-2"></i>Réinitialiser
                        </button>
                        <button type="submit" class="btn btn-modern btn-gradient-success px-4">
                            <i class="bi bi-check-circle me-2"></i>Enregistrer le Produit
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Calcul automatique de la marge bénéficiaire
    document.getElementById('unitPrice').addEventListener('input', calculateMargin);
    document.getElementById('sellingPrice').addEventListener('input', calculateMargin);

    function calculateMargin() {
        const unitPrice = parseFloat(document.getElementById('unitPrice').value) || 0;
        const sellingPrice = parseFloat(document.getElementById('sellingPrice').value) || 0;

        if (unitPrice > 0 && sellingPrice > 0) {
            const margin = ((sellingPrice - unitPrice) / unitPrice * 100).toFixed(2);
            const marginElement = document.getElementById('profitMargin');

            if (margin > 0) {
                marginElement.innerHTML = `<i class="bi bi-graph-up-arrow text-success me-1"></i>
                                      Marge: <strong class="text-success">${margin}%</strong>`;
            } else {
                marginElement.innerHTML = `<i class="bi bi-graph-down-arrow text-danger me-1"></i>
                                      Marge: <strong class="text-danger">${margin}%</strong>`;
            }
        }
    }

    // Validation du formulaire
    document.getElementById('productForm').addEventListener('submit', function(e) {
        const unitPrice = parseFloat(document.getElementById('unitPrice').value);
        const sellingPrice = parseFloat(document.getElementById('sellingPrice').value);

        if (sellingPrice < unitPrice) {
            if (!confirm('Le prix de vente est inférieur au prix d\'achat. Voulez-vous continuer ?')) {
                e.preventDefault();
            }
        }
    });
</script>