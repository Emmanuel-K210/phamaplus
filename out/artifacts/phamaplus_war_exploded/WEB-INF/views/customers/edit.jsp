<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-pencil text-primary me-2"></i>Modifier le Client
                    </h2>
                    <p class="text-muted mb-0">
                        Modifiez les informations de ${customer.fullName}
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/customers" class="btn btn-outline-secondary">
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
                <form action="${pageContext.request.contextPath}/customers/edit" method="post" id="customerForm">
                    <input type="hidden" name="customerId" value="${customer.customerId}">

                    <!-- Informations personnelles -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-person-badge text-primary me-2"></i>Informations Personnelles
                            </h5>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Prénom <span class="text-danger">*</span></label>
                            <input type="text" class="form-control modern-input"
                                   name="firstName" required
                                   value="${customer.firstName}"
                                   placeholder="Jean">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Nom <span class="text-danger">*</span></label>
                            <input type="text" class="form-control modern-input"
                                   name="lastName" required
                                   value="${customer.lastName}"
                                   placeholder="Dupont">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Téléphone <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control modern-input"
                                   name="phone" required
                                   value="${customer.phone}"
                                   placeholder="0612345678">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" class="form-control modern-input"
                                   name="email"
                                   value="${customer.email}"
                                   placeholder="jean.dupont@example.com">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Date de naissance</label>
                            <input type="date" class="form-control modern-input"
                                   name="dateOfBirth"
                                   value="${customer.dateOfBirth}">
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
                                      placeholder="123 Rue de la République, 75001 Paris">${customer.address}</textarea>
                        </div>
                    </div>

                    <!-- Allergies -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-exclamation-triangle text-warning me-2"></i>Allergies
                            </h5>
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label fw-bold">Allergies connues</label>
                            <textarea class="form-control modern-input"
                                      name="allergies" rows="3"
                                      placeholder="Listez les allergies du client (ex: Pénicilline, Aspirine, etc.)">${customer.allergies}</textarea>
                            <small class="text-muted">Important pour la sécurité des prescriptions</small>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="d-flex justify-content-between">
                                <button type="button" class="btn btn-modern btn-gradient-danger"
                                        onclick="confirmDelete(${customer.customerId})">
                                    <i class="bi bi-trash me-2"></i>Supprimer
                                </button>
                                <div class="d-flex gap-3">
                                    <a href="${pageContext.request.contextPath}/customers" class="btn btn-modern btn-gradient-secondary">
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
                    <i class="bi bi-info-circle text-info me-2"></i>Informations du client
                </h5>
                <div class="mb-3">
                    <div class="d-flex align-items-center mb-2">
                        <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                            <i class="bi bi-person text-primary"></i>
                        </div>
                        <div>
                            <strong>${customer.fullName}</strong>
                            <br>
                            <small class="text-muted">ID: #${customer.customerId}</small>
                        </div>
                    </div>
                </div>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <i class="bi bi-telephone text-primary me-2"></i>
                        <strong>Téléphone :</strong> ${customer.phone}
                    </li>
                    <c:if test="${not empty customer.email}">
                        <li class="mb-2">
                            <i class="bi bi-envelope text-primary me-2"></i>
                            <strong>Email :</strong> ${customer.email}
                        </li>
                    </c:if>
                    <c:if test="${not empty customer.dateOfBirth}">
                        <li class="mb-2">
                            <i class="bi bi-calendar text-primary me-2"></i>
                            <strong>Date naissance :</strong> ${customer.dateOfBirth}
                        </li>
                    </c:if>
                    <c:if test="${not empty customer.createdAt}">
                        <li class="mb-2">
                            <i class="bi bi-clock text-primary me-2"></i>
                            <strong>Créé le :</strong> ${customer.createdAt}
                        </li>
                    </c:if>
                </ul>
            </div>

            <div class="modern-card p-4">
                <h5 class="mb-3">
                    <i class="bi bi-lightning text-warning me-2"></i>Actions rapides
                </h5>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/sales/create?customerId=${customer.customerId}"
                       class="btn btn-outline-success text-start">
                        <i class="bi bi-cart-plus me-2"></i>Nouvelle vente
                    </a>
                    <a href="${pageContext.request.contextPath}/prescriptions/create?customerId=${customer.customerId}"
                       class="btn btn-outline-info text-start">
                        <i class="bi bi-file-medical me-2"></i>Nouvelle ordonnance
                    </a>
                    <a href="${pageContext.request.contextPath}/customers"
                       class="btn btn-outline-primary text-start">
                        <i class="bi bi-list me-2"></i>Voir tous les clients
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Validation du formulaire
    document.getElementById('customerForm').addEventListener('submit', function(e) {
        const firstName = document.querySelector('input[name="firstName"]').value.trim();
        const lastName = document.querySelector('input[name="lastName"]').value.trim();
        const phone = document.querySelector('input[name="phone"]').value.trim();

        if (!firstName || !lastName) {
            e.preventDefault();
            alert('Le prénom et le nom sont obligatoires');
            return false;
        }

        if (!phone || !/^[0-9\-\+\s\(\)]{10,}$/.test(phone)) {
            e.preventDefault();
            alert('Veuillez entrer un numéro de téléphone valide (minimum 10 chiffres)');
            return false;
        }

        return true;
    });

    function confirmDelete(customerId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer ce client ? Cette action est irréversible.')) {
            window.location.href = '${pageContext.request.contextPath}/customers/delete?id=' + customerId;
        }
    }

    // Focus sur le premier champ
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelector('input[name="firstName"]').focus();
    });
</script>