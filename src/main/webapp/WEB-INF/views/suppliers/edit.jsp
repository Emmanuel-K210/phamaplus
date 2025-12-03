<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-pencil text-primary me-2"></i>Modifier le Fournisseur
                    </h2>
                    <p class="text-muted mb-0">
                        Modifiez les informations de ${supplier.supplierName}
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/suppliers" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Retour à la liste
                </a>
            </div>
        </div>
    </div>

    <!-- Messages d'erreur -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show modern-card mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <strong>Erreur !</strong> ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <div class="col-lg-8">
            <div class="modern-card p-4">
                <form action="${pageContext.request.contextPath}/suppliers/edit" method="post" id="supplierForm">
                    <input type="hidden" name="id" value="${supplier.supplierId}">

                    <!-- Informations principales -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-building text-primary me-2"></i>Informations de l'entreprise
                            </h5>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Nom du fournisseur <span class="text-danger">*</span></label>
                            <input type="text" class="form-control modern-input"
                                   name="supplierName" required
                                   value="${supplier.supplierName}"
                                   placeholder="MediCorp France">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Code barre</label>
                            <input type="text" class="form-control modern-input"
                                   name="barcode"
                                   value="${supplier.barcode}"
                                   placeholder="123456789012">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Personne de contact</label>
                            <input type="text" class="form-control modern-input"
                                   name="contactPerson"
                                   value="${supplier.contactPerson}"
                                   placeholder="M. Martin Dupont">
                        </div>
                    </div>

                    <!-- Contact -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-telephone text-primary me-2"></i>Coordonnées
                            </h5>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Téléphone <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control modern-input"
                                   name="phone" required
                                   value="${supplier.phone}"
                                   placeholder="01 23 45 67 89">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" class="form-control modern-input"
                                   name="email"
                                   value="${supplier.email}"
                                   placeholder="contact@medicorp.fr">
                        </div>
                    </div>

                    <!-- Adresse -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-geo-alt text-primary me-2"></i>Adresse
                            </h5>
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label fw-bold">Adresse complète</label>
                            <textarea class="form-control modern-input"
                                      name="address" rows="2"
                                      placeholder="123 Avenue des Champs-Élysées">${supplier.address}</textarea>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Ville</label>
                            <input type="text" class="form-control modern-input"
                                   name="city"
                                   value="${supplier.city}"
                                   placeholder="Paris">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Pays</label>
                            <select class="form-select modern-input" name="country">
                                <option value="France" ${supplier.country == 'France' ? 'selected' : ''}>France</option>
                                <option value="Belgique" ${supplier.country == 'Belgique' ? 'selected' : ''}>Belgique</option>
                                <option value="Suisse" ${supplier.country == 'Suisse' ? 'selected' : ''}>Suisse</option>
                                <option value="Allemagne" ${supplier.country == 'Allemagne' ? 'selected' : ''}>Allemagne</option>
                                <option value="Espagne" ${supplier.country == 'Espagne' ? 'selected' : ''}>Espagne</option>
                                <option value="Italie" ${supplier.country == 'Italie' ? 'selected' : ''}>Italie</option>
                                <option value="Autre" ${supplier.country == 'Autre' ? 'selected' : ''}>Autre</option>
                            </select>
                        </div>
                    </div>

                    <!-- Paramètres -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-gear text-primary me-2"></i>Paramètres
                            </h5>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Niveau de réapprovisionnement</label>
                            <input type="number" class="form-control modern-input"
                                   name="reorderLevel" min="1" max="1000"
                                   value="${supplier.reorderLevel}">
                            <small class="text-muted">Niveau à partir duquel une commande est suggérée</small>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Statut</label>
                            <div class="form-check form-switch mt-2">
                                <input class="form-check-input" type="checkbox"
                                       name="isActive" value="true"
                                       role="switch" id="flexSwitchCheckDefault"
                                ${supplier.isActive ? 'checked' : ''}>
                                <label class="form-check-label" for="flexSwitchCheckDefault">
                                    Fournisseur actif
                                </label>
                            </div>
                            <small class="text-muted">Désactivez pour suspendre les commandes</small>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <button type="button" class="btn btn-modern btn-gradient-danger"
                                            onclick="confirmDelete(${supplier.supplierId})">
                                        <i class="bi bi-trash me-2"></i>Supprimer
                                    </button>
                                    <button type="button" class="btn btn-modern ${supplier.isActive ? 'btn-gradient-warning' : 'btn-gradient-success'}"
                                            onclick="toggleStatus(${supplier.supplierId}, ${supplier.isActive})">
                                        <i class="bi ${supplier.isActive ? 'bi-toggle-off' : 'bi-toggle-on'} me-2"></i>
                                        ${supplier.isActive ? 'Désactiver' : 'Activer'}
                                    </button>
                                </div>
                                <div class="d-flex gap-3">
                                    <a href="${pageContext.request.contextPath}/suppliers" class="btn btn-modern btn-gradient-secondary">
                                        <i class="bi bi-x-circle me-2"></i>Annuler
                                    </a>
                                    <button type="submit" class="btn btn-modern btn-gradient-primary">
                                        <i class="bi bi-check-circle me-2"></i>Enregistrer les modifications
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Sidebar - Informations -->
        <div class="col-lg-4">
            <div class="modern-card p-4 mb-4">
                <h5 class="mb-3">
                    <i class="bi bi-info-circle text-info me-2"></i>Informations du fournisseur
                </h5>
                <div class="mb-3">
                    <div class="d-flex align-items-center mb-2">
                        <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                            <i class="bi bi-building text-primary"></i>
                        </div>
                        <div>
                            <strong>${supplier.supplierName}</strong>
                            <br>
                            <small class="text-muted">ID: #${supplier.supplierId}</small>
                        </div>
                    </div>
                </div>
                <ul class="list-unstyled">
                    <c:if test="${not empty supplier.contactPerson}">
                        <li class="mb-2">
                            <i class="bi bi-person text-primary me-2"></i>
                            <strong>Contact :</strong> ${supplier.contactPerson}
                        </li>
                    </c:if>
                    <li class="mb-2">
                        <i class="bi bi-telephone text-primary me-2"></i>
                        <strong>Téléphone :</strong> ${supplier.phone}
                    </li>
                    <c:if test="${not empty supplier.email}">
                        <li class="mb-2">
                            <i class="bi bi-envelope text-primary me-2"></i>
                            <strong>Email :</strong> ${supplier.email}
                        </li>
                    </c:if>
                    <c:if test="${not empty supplier.city}">
                        <li class="mb-2">
                            <i class="bi bi-geo-alt text-primary me-2"></i>
                            <strong>Localisation :</strong> ${supplier.city}, ${supplier.country}
                        </li>
                    </c:if>
                    <li class="mb-2">
                        <i class="bi bi-box text-primary me-2"></i>
                        <strong>Niveau réappro :</strong> ${supplier.reorderLevel}
                    </li>
                    <li class="mb-2">
                        <i class="bi bi-toggle-on text-primary me-2"></i>
                        <strong>Statut :</strong>
                        <c:choose>
                            <c:when test="${supplier.isActive}">
                                <span class="badge bg-success">Actif</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Inactif</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <c:if test="${not empty supplier.createdAt}">
                        <li class="mb-2">
                            <i class="bi bi-clock text-primary me-2"></i>
                            <strong>Créé le :</strong> ${supplier.createdAt}
                        </li>
                    </c:if>
                </ul>
            </div>

            <div class="modern-card p-4">
                <h5 class="mb-3">
                    <i class="bi bi-lightning text-warning me-2"></i>Actions rapides
                </h5>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/purchase/create?supplierId=${supplier.supplierId}"
                       class="btn btn-outline-success text-start">
                        <i class="bi bi-cart-plus me-2"></i>Nouvelle commande
                    </a>
                    <a href="${pageContext.request.contextPath}/inventory?supplierId=${supplier.supplierId}"
                       class="btn btn-outline-info text-start">
                        <i class="bi bi-box-seam me-2"></i>Voir les stocks
                    </a>
                    <a href="${pageContext.request.contextPath}/suppliers"
                       class="btn btn-outline-primary text-start">
                        <i class="bi bi-list me-2"></i>Voir tous les fournisseurs
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Validation du formulaire
    document.getElementById('supplierForm').addEventListener('submit', function(e) {
        const supplierName = document.querySelector('input[name="supplierName"]').value.trim();
        const phone = document.querySelector('input[name="phone"]').value.trim();

        if (!supplierName) {
            e.preventDefault();
            alert('Le nom du fournisseur est obligatoire');
            return false;
        }

        if (!phone || !/^[0-9\-\+\s\(\)]{10,}$/.test(phone)) {
            e.preventDefault();
            alert('Veuillez entrer un numéro de téléphone valide');
            return false;
        }

        return true;
    });

    function confirmDelete(supplierId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer ce fournisseur ? Cette action est irréversible.')) {
            window.location.href = '${pageContext.request.contextPath}/suppliers/delete?id=' + supplierId;
        }
    }

    function toggleStatus(supplierId, isActive) {
        const action = isActive ? 'deactivate' : 'activate';
        const message = isActive ?
            'Êtes-vous sûr de vouloir désactiver ce fournisseur ? Les nouvelles commandes seront bloquées.' :
            'Êtes-vous sûr de vouloir activer ce fournisseur ?';

        if (confirm(message)) {
            window.location.href = '${pageContext.request.contextPath}/suppliers/toggle-status?id=' + supplierId + '&action=' + action;
        }
    }

    // Focus sur le premier champ
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelector('input[name="supplierName"]').focus();
    });
</script>