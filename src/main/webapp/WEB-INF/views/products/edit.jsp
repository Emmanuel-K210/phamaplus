<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">

  <!-- HEADER + BREADCRUMB -->
  <div class="row mb-4">
    <div class="col-12">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h2 class="mb-1">
            <i class="bi bi-pencil-square text-primary me-2"></i>Modifier le Produit
          </h2>

          <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
              <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/products">Produits</a>
              </li>
              <li class="breadcrumb-item active">${product.productName}</li>
            </ol>
          </nav>
        </div>

        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
          <i class="bi bi-arrow-left me-2"></i>Retour
        </a>
      </div>
    </div>
  </div>

  <!-- FORMULAIRE -->
  <div class="row">
    <div class="col-lg-8 mx-auto">
      <div class="modern-card p-4">

        <!-- Message d’erreur -->
        <c:if test="${not empty error}">
          <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
          </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/products/update" method="post">
          <input type="hidden" name="productId" value="${product.productId}">

          <!-- 🧩 Informations de Base -->
          <div class="mb-4">
            <h5 class="border-bottom pb-3 mb-3">
              <i class="bi bi-info-circle text-primary me-2"></i>Informations de Base
            </h5>

            <div class="row g-3">

              <div class="col-md-6">
                <label for="productName" class="form-label">Nom du Produit *</label>
                <input type="text" class="form-control modern-input" id="productName"
                       name="productName" value="${product.productName}" required>
              </div>

              <div class="col-md-6">
                <label for="genericName" class="form-label">Nom Générique</label>
                <input type="text" class="form-control modern-input" id="genericName"
                       name="genericName" value="${product.genericName}">
              </div>

              <div class="col-md-6">
                <label for="manufacturer" class="form-label">Fabricant</label>
                <input type="text" class="form-control modern-input" id="manufacturer"
                       name="manufacturer" value="${product.manufacturer}">
              </div>

              <div class="col-md-6">
                <label for="categoryId" class="form-label">Catégorie</label>
                <select class="form-select modern-input" id="categoryId" name="categoryId">
                  <option value="">Sélectionner une catégorie</option>
                  <option value="1" ${product.categoryId == 1 ? 'selected' : ''}>Médicaments</option>
                  <option value="2" ${product.categoryId == 2 ? 'selected' : ''}>Vitamines</option>
                  <option value="3" ${product.categoryId == 3 ? 'selected' : ''}>Antibiotiques</option>
                  <option value="4" ${product.categoryId == 4 ? 'selected' : ''}>Analgésiques</option>
                </select>
              </div>

              <div class="col-md-6">
                <label for="barcode" class="form-label">Code-barres</label>
                <input type="text" class="form-control modern-input" id="barcode"
                       name="barcode" value="${product.barcode}">
              </div>

            </div>
          </div>

          <!-- 💊 Dosage et Forme -->
          <div class="mb-4">
            <h5 class="border-bottom pb-3 mb-3">
              <i class="bi bi-capsule text-info me-2"></i>Dosage et Forme
            </h5>

            <div class="row g-3">

              <div class="col-md-4">
                <label for="dosageForm" class="form-label">Forme Pharmaceutique</label>
                <select class="form-select modern-input" id="dosageForm" name="dosageForm">
                  <option value="">Sélectionner</option>
                  <option value="Comprimé" ${product.dosageForm == 'Comprimé' ? 'selected' : ''}>Comprimé</option>
                  <option value="Gélule" ${product.dosageForm == 'Gélule' ? 'selected' : ''}>Gélule</option>
                  <option value="Sirop" ${product.dosageForm == 'Sirop' ? 'selected' : ''}>Sirop</option>
                  <option value="Injection" ${product.dosageForm == 'Injection' ? 'selected' : ''}>Injection</option>
                  <option value="Crème" ${product.dosageForm == 'Crème' ? 'selected' : ''}>Crème</option>
                  <option value="Pommade" ${product.dosageForm == 'Pommade' ? 'selected' : ''}>Pommade</option>
                </select>
              </div>

              <div class="col-md-4">
                <label for="strength" class="form-label">Dosage</label>
                <input type="text" class="form-control modern-input" id="strength"
                       name="strength" value="${product.strength}">
              </div>

              <div class="col-md-4">
                <label for="unitOfMeasure" class="form-label">Unité</label>
                <select class="form-select modern-input" id="unitOfMeasure" name="unitOfMeasure">
                  <option value="">Sélectionner</option>
                  <option value="mg" ${product.unitOfMeasure == 'mg' ? 'selected' : ''}>mg</option>
                  <option value="g" ${product.unitOfMeasure == 'g' ? 'selected' : ''}>g</option>
                  <option value="ml" ${product.unitOfMeasure == 'ml' ? 'selected' : ''}>ml</option>
                  <option value="unité" ${product.unitOfMeasure == 'unité' ? 'selected' : ''}>unité</option>
                </select>
              </div>

            </div>
          </div>

          <!-- 💵 Tarification FCFA -->
          <div class="mb-4">
            <h5 class="border-bottom pb-3 mb-3">
              <i class="bi bi-cash-coin text-success me-2"></i>Tarification
            </h5>

            <div class="row g-3">
              <div class="col-md-6">
                <label for="unitPrice" class="form-label">Prix d'Achat (FCFA)</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-cash-coin"></i></span>
                  <input type="number" class="form-control modern-input"
                         id="unitPrice" name="unitPrice"
                         step="0.01" value="${product.unitPrice}" required>
                </div>
              </div>

              <div class="col-md-6">
                <label for="sellingPrice" class="form-label">Prix de Vente (FCFA)</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-cash-coin"></i></span>
                  <input type="number" class="form-control modern-input"
                         id="sellingPrice" name="sellingPrice"
                         step="0.01" value="${product.sellingPrice}" required>
                </div>
              </div>
            </div>
          </div>

          <!-- 📦 Stock & Sécurité -->
          <div class="mb-4">
            <h5 class="border-bottom pb-3 mb-3">
              <i class="bi bi-boxes text-warning me-2"></i>Stock et Sécurité
            </h5>

            <div class="row g-3">

              <div class="col-md-6">
                <label for="reorderLevel" class="form-label">Niveau de Réapprovisionnement</label>
                <input type="number" class="form-control modern-input" id="reorderLevel"
                       name="reorderLevel" value="${product.reorderLevel}">
              </div>

              <div class="col-md-6">
                <label class="form-label d-block">Exigences</label>
                <div class="form-check form-switch">
                  <input class="form-check-input" type="checkbox" id="requiresPrescription"
                         name="requiresPrescription" value="true"
                  ${product.requiresPrescription ? 'checked' : ''}>
                  <label class="form-check-label" for="requiresPrescription">
                    Nécessite une ordonnance
                  </label>
                </div>
              </div>

            </div>
          </div>

          <!-- FOOTER -->
          <div class="d-flex gap-3 justify-content-end pt-4 border-top">
            <a href="${pageContext.request.contextPath}/products"
               class="btn btn-outline-secondary px-4">
              <i class="bi bi-x-circle me-2"></i>Annuler
            </a>

            <button type="submit" class="btn btn-modern btn-gradient-primary px-4">
              <i class="bi bi-check-circle me-2"></i>Mettre à Jour
            </button>
          </div>
        </form>

      </div>
    </div>
  </div>

</div>
