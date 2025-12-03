<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-truck text-primary me-2"></i>Ajouter un Fournisseur
                    </h2>
                    <p class="text-muted mb-0">
                        Remplissez les informations pour créer un nouveau fournisseur
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/suppliers" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Retour à la liste
                </a>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="modern-card p-4">
                <form action="${pageContext.request.contextPath}/suppliers/add" method="post" id="supplierForm">

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
                                   placeholder="MediCorp France">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Code barre</label>
                            <input type="text" class="form-control modern-input"
                                   name="barcode"
                                   placeholder="123456789012">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Personne de contact</label>
                            <input type="text" class="form-control modern-input"
                                   name="contactPerson"
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
                                   placeholder="01 23 45 67 89">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" class="form-control modern-input"
                                   name="email"
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
                                      placeholder="123 Avenue des Champs-Élysées"></textarea>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Ville</label>
                            <input type="text" class="form-control modern-input"
                                   name="city"
                                   placeholder="Paris">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Pays</label>
                            <select class="form-select modern-input" name="country">
                                <option value="France" selected>France</option>
                                <option value="Belgique">Belgique</option>
                                <option value="Suisse">Suisse</option>
                                <option value="Allemagne">Allemagne</option>
                                <option value="Espagne">Espagne</option>
                                <option value="Italie">Italie</option>
                                <option value="Autre">Autre</option>
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
                                   value="10">
                            <small class="text-muted">Niveau à partir duquel une commande est suggérée</small>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Statut</label>
                            <div class="form-check form-switch mt-2">
                                <input class="form-check-input" type="checkbox"
                                       name="isActive" value="true" checked
                                       role="switch" id="flexSwitchCheckDefault">
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
                            <div class="d-flex justify-content-end gap-3">
                                <button type="reset" class="btn btn-modern btn-gradient-secondary">
                                    <i class="bi bi-x-circle me-2"></i>Réinitialiser
                                </button>
                                <button type="submit" class="btn btn-modern btn-gradient-primary">
                                    <i class="bi bi-check-circle me-2"></i>Enregistrer le fournisseur
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Sidebar - Aide -->
        <div class="col-lg-4">
            <div class="modern-card p-4 mb-4">
                <h5 class="mb-3">
                    <i class="bi bi-info-circle text-info me-2"></i>Conseils
                </h5>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <i class="bi bi-check-circle text-success me-2"></i>
                        Les champs marqués d'une * sont obligatoires
                    </li>
                    <li class="mb-2">
                        <i class="bi bi-phone text-primary me-2"></i>
                        Un numéro de téléphone est essentiel pour les commandes urgentes
                    </li>
                    <li class="mb-2">
                        <i class="bi bi-box text-warning me-2"></i>
                        Le niveau de réapprovisionnement optimise la gestion des stocks
                    </li>
                    <li class="mb-2">
                        <i class="bi bi-barcode text-secondary me-2"></i>
                        Le code barre facilite l'identification rapide
                    </li>
                </ul>
            </div>

            <div class="modern-card p-4">
                <h5 class="mb-3">
                    <i class="bi bi-lightning text-warning me-2"></i>Actions rapides
                </h5>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/suppliers"
                       class="btn btn-outline-primary text-start">
                        <i class="bi bi-list me-2"></i>Voir tous les fournisseurs
                    </a>
                    <a href="${pageContext.request.contextPath}/purchase/create"
                       class="btn btn-outline-success text-start">
                        <i class="bi bi-cart-plus me-2"></i>Nouvelle commande
                    </a>
                    <a href="${pageContext.request.contextPath}/inventory/add"
                       class="btn btn-outline-info text-start">
                        <i class="bi bi-box-seam me-2"></i>Nouveau lot
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

    // Focus sur le premier champ
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelector('input[name="supplierName"]').focus();
    });
</script>