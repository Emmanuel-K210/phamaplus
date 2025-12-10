<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Désactiver le cache pour éviter les pages blanches --%>
<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);
%>

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
              <li class="breadcrumb-item active">
                <c:choose>
                  <c:when test="${not empty product.productName}">
                    ${product.productName}
                  </c:when>
                  <c:otherwise>
                    Modification
                  </c:otherwise>
                </c:choose>
              </li>
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

        <!-- Message d'erreur -->
        <c:if test="${not empty error}">
          <div class="alert alert-danger alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        </c:if>

        <!-- Vérifier que le produit existe -->
        <c:choose>
          <c:when test="${empty product}">
            <div class="alert alert-warning">
              <i class="bi bi-exclamation-triangle-fill me-2"></i>
              Produit non trouvé ou erreur de chargement.
              <a href="${pageContext.request.contextPath}/products" class="alert-link">
                Retour à la liste
              </a>
            </div>
          </c:when>
          <c:otherwise>

            <form action="${pageContext.request.contextPath}/products/update" method="post" id="editProductForm">
              <input type="hidden" name="productId" value="${product.productId}">

              <!-- 🧩 Informations de Base -->
              <div class="mb-4">
                <h5 class="border-bottom pb-3 mb-3">
                  <i class="bi bi-info-circle text-primary me-2"></i>Informations de Base
                </h5>

                <div class="row g-3">

                  <div class="col-md-6">
                    <label for="productName" class="form-label">
                      Nom du Produit <span class="text-danger">*</span>
                    </label>
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
                      <option value="piece" ${product.unitOfMeasure == 'piece' ? 'selected' : ''}>pièce</option>
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
                    <label for="unitPrice" class="form-label">
                      Prix d'Achat (FCFA) <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                      <span class="input-group-text"><i class="bi bi-cash-coin"></i></span>
                      <input type="number" class="form-control modern-input"
                             id="unitPrice" name="unitPrice"
                             step="1" min="0" value="${product.unitPrice}" required>
                    </div>
                  </div>

                  <div class="col-md-6">
                    <label for="sellingPrice" class="form-label">
                      Prix de Vente (FCFA) <span class="text-danger">*</span>
                    </label>
                    <div class="input-group">
                      <span class="input-group-text"><i class="bi bi-cash-coin"></i></span>
                      <input type="number" class="form-control modern-input"
                             id="sellingPrice" name="sellingPrice"
                             step="1" min="0" value="${product.sellingPrice}" required>
                    </div>
                  </div>

                  <!-- Afficher la marge -->
                  <div class="col-12">
                    <div class="alert alert-info d-flex align-items-center" id="profitMarginDisplay">
                      <i class="bi bi-info-circle me-2"></i>
                      <span>Marge bénéficiaire: <strong id="marginValue">0%</strong></span>
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
                           name="reorderLevel" min="0" value="${product.reorderLevel}">
                    <small class="text-muted">Alerte si le stock descend en dessous de ce niveau</small>
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

<script>
  (function() {
    'use strict';

    let isInitialized = false;

    // ============================================
    // CALCUL DE LA MARGE
    // ============================================

    function calculateProfitMargin() {
      const unitPrice = parseFloat(document.getElementById('unitPrice').value) || 0;
      const sellingPrice = parseFloat(document.getElementById('sellingPrice').value) || 0;

      if (unitPrice > 0) {
        const margin = ((sellingPrice - unitPrice) / unitPrice) * 100;
        const marginElement = document.getElementById('marginValue');
        const displayElement = document.getElementById('profitMarginDisplay');

        if (marginElement && displayElement) {
          marginElement.textContent = margin.toFixed(2) + '%';

          // Changer la couleur selon la marge
          displayElement.className = 'alert d-flex align-items-center';
          if (margin < 0) {
            displayElement.classList.add('alert-danger');
          } else if (margin < 10) {
            displayElement.classList.add('alert-warning');
          } else {
            displayElement.classList.add('alert-success');
          }
        }
      }
    }

    // ============================================
    // VALIDATION DU FORMULAIRE
    // ============================================

    function setupFormValidation() {
      const form = document.getElementById('editProductForm');
      if (!form) return;

      form.addEventListener('submit', function(e) {
        const unitPrice = parseFloat(document.getElementById('unitPrice').value) || 0;
        const sellingPrice = parseFloat(document.getElementById('sellingPrice').value) || 0;

        // Vérifier que le prix de vente > prix d'achat
        if (sellingPrice <= unitPrice) {
          const confirmed = confirm(
                  'Attention: Le prix de vente est inférieur ou égal au prix d\'achat.\n' +
                  'Cela engendrera une perte. Voulez-vous continuer ?'
          );

          if (!confirmed) {
            e.preventDefault();
            return false;
          }
        }

        // Afficher un loader
        const submitBtn = document.getElementById('submitBtn');
        if (submitBtn) {
          submitBtn.disabled = true;
          submitBtn.innerHTML =
                  '<span class="spinner-border spinner-border-sm me-2"></span>Mise à jour...';
        }

        return true;
      });
    }

    // ============================================
    // ÉVÉNEMENTS SUR LES PRIX
    // ============================================

    function setupPriceListeners() {
      const unitPriceInput = document.getElementById('unitPrice');
      const sellingPriceInput = document.getElementById('sellingPrice');

      if (unitPriceInput) {
        unitPriceInput.addEventListener('input', calculateProfitMargin);
        unitPriceInput.addEventListener('change', calculateProfitMargin);
      }

      if (sellingPriceInput) {
        sellingPriceInput.addEventListener('input', calculateProfitMargin);
        sellingPriceInput.addEventListener('change', calculateProfitMargin);
      }
    }

    // ============================================
    // AUTO-DISMISS DES ALERTES
    // ============================================

    function setupAlertAutoDismiss() {
      const alerts = document.querySelectorAll('.alert-dismissible');

      alerts.forEach(function(alert) {
        setTimeout(function() {
          if (alert && alert.parentNode && typeof bootstrap !== 'undefined') {
            try {
              const bsAlert = new bootstrap.Alert(alert);
              bsAlert.close();
            } catch (e) {
              console.error('Error dismissing alert:', e);
            }
          }
        }, 5000);
      });
    }

    // ============================================
    // CONFIRMATION DE NAVIGATION
    // ============================================

    function setupNavigationWarning() {
      const form = document.getElementById('editProductForm');
      if (!form) return;

      let formChanged = false;

      // Surveiller les changements
      form.addEventListener('input', function() {
        formChanged = true;
      });

      form.addEventListener('change', function() {
        formChanged = true;
      });

      // Prévenir avant de quitter si modifications
      window.addEventListener('beforeunload', function(e) {
        if (formChanged) {
          e.preventDefault();
          e.returnValue = '';
          return '';
        }
      });

      // Ne pas avertir si le formulaire est soumis
      form.addEventListener('submit', function() {
        formChanged = false;
      });
    }

    // ============================================
    // NETTOYAGE
    // ============================================

    function cleanup() {
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

      console.log('Initializing product edit page...');

      try {
        isInitialized = true;

        // Initialiser les fonctionnalités
        setupFormValidation();
        setupPriceListeners();
        setupAlertAutoDismiss();
        setupNavigationWarning();

        // Calculer la marge initiale
        calculateProfitMargin();

        console.log('Product edit page initialized successfully');
      } catch (e) {
        console.error('Error during initialization:', e);
        isInitialized = false;
      }
    }

    // ============================================
    // LANCEMENT
    // ============================================

    // Nettoyer au déchargement
    window.addEventListener('beforeunload', cleanup);
    window.addEventListener('pagehide', cleanup);

    // Initialiser au chargement du DOM
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', initialize);
    } else {
      initialize();
    }

  })();
</script>

<style>
  .modern-card {
    border-radius: 15px;
    border: 1px solid #e9ecef;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    transition: box-shadow 0.3s ease;
  }

  .modern-input {
    border: 2px solid #e9ecef;
    border-radius: 8px;
    transition: all 0.3s ease;
  }

  .modern-input:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  }

  .btn-modern {
    border-radius: 10px;
    font-weight: 600;
    padding: 0.5rem 1.5rem;
    transition: all 0.3s ease;
  }

  .btn-gradient-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    color: white;
  }

  .btn-gradient-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
    color: white;
  }

  .form-check-input:checked {
    background-color: #667eea;
    border-color: #667eea;
  }

  .input-group-text {
    background-color: #f8f9fa;
    border: 2px solid #e9ecef;
    border-right: none;
  }

  .input-group .form-control {
    border-left: none;
  }

  .input-group:focus-within .input-group-text {
    border-color: #667eea;
  }

  /* Animation pour le loader */
  .spinner-border-sm {
    width: 1rem;
    height: 1rem;
    border-width: 0.2em;
  }

  /* Amélioration de l'alerte de marge */
  #profitMarginDisplay {
    margin-bottom: 0;
    transition: all 0.3s ease;
  }

  /* Responsive */
  @media (max-width: 768px) {
    .modern-card {
      padding: 1rem !important;
    }
  }
</style>