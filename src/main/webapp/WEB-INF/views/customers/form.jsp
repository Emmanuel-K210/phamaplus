<%-- /WEB-INF/views/customers/add.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-person-plus text-primary me-2"></i>Ajouter un Client
                    </h2>
                    <p class="text-muted mb-0">
                        Enregistrez les informations d'un nouveau client
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/customers" class="btn btn-modern btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Retour à la liste
                </a>
            </div>
        </div>
    </div>

    <!-- Messages d'erreur -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show modern-card mb-4">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Formulaire -->
    <div class="row">
        <div class="col-lg-8 mx-auto">
            <div class="modern-card p-4">
                <form id="customerForm" method="post" action="${pageContext.request.contextPath}/customers/add">

                    <!-- Informations personnelles -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-2 mb-3">
                            <i class="bi bi-person me-2"></i>Informations Personnelles
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="lastName" class="form-label">
                                    Nom <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control modern-input"
                                       id="lastName" name="lastName"
                                       value="${customer.lastName}"
                                       required>
                                <div class="invalid-feedback">
                                    Veuillez saisir le nom du client
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="firstName" class="form-label">
                                    Prénom <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control modern-input"
                                       id="firstName" name="firstName"
                                       value="${customer.firstName}"
                                       required>
                                <div class="invalid-feedback">
                                    Veuillez saisir le prénom du client
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="dateOfBirth" class="form-label">
                                    Date de Naissance
                                </label>
                                <input type="date" class="form-control modern-input"
                                       id="dateOfBirth" name="dateOfBirth"
                                       value="${customer.dateOfBirth}"
                                       max="<%= java.time.LocalDate.now() %>">
                                <small class="text-muted">L'âge sera calculé automatiquement</small>
                            </div>
                        </div>
                    </div>

                    <!-- Coordonnées -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-2 mb-3">
                            <i class="bi bi-telephone me-2"></i>Coordonnées
                        </h5>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="phone" class="form-label">
                                    Téléphone <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="bi bi-telephone"></i>
                                    </span>
                                    <input type="tel" class="form-control modern-input"
                                           id="phone" name="phone"
                                           value="${customer.phone}"
                                           placeholder="032 12 345 67"
                                           required>
                                </div>
                                <div id="phoneError" class="text-danger small mt-1"></div>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label">
                                    Email
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="bi bi-envelope"></i>
                                    </span>
                                    <input type="email" class="form-control modern-input"
                                           id="email" name="email"
                                           value="${customer.email}"
                                           placeholder="client@example.com">
                                </div>
                                <div id="emailError" class="text-danger small mt-1"></div>
                            </div>

                            <div class="col-12">
                                <label for="address" class="form-label">
                                    Adresse Complète
                                </label>
                                <textarea class="form-control modern-input"
                                          id="address" name="address"
                                          rows="2"
                                          placeholder="Numéro, rue, quartier, ville...">${customer.address}</textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Informations médicales -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-2 mb-3">
                            <i class="bi bi-heart-pulse me-2"></i>Informations Médicales
                        </h5>

                        <div class="row g-3">
                            <div class="col-12">
                                <label for="allergies" class="form-label">
                                    Allergies Connues
                                </label>
                                <textarea class="form-control modern-input"
                                          id="allergies" name="allergies"
                                          rows="3"
                                          placeholder="Listez les allergies connues du client (médicaments, substances, etc.)">${customer.allergies}</textarea>
                                <small class="text-muted">
                                    <i class="bi bi-info-circle me-1"></i>
                                    Ces informations sont importantes pour la sécurité du client
                                </small>
                            </div>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="d-flex justify-content-between pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/customers"
                           class="btn btn-modern btn-outline-secondary">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <div class="d-flex gap-2">
                            <button type="reset" class="btn btn-modern btn-outline-warning">
                                <i class="bi bi-arrow-counterclockwise me-2"></i>Réinitialiser
                            </button>
                            <button type="submit" class="btn btn-modern btn-gradient-primary">
                                <i class="bi bi-save me-2"></i>Enregistrer le Client
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Aide et informations -->
            <div class="modern-card p-3 mt-3">
                <h6 class="mb-2">
                    <i class="bi bi-info-circle text-info me-2"></i>Informations
                </h6>
                <ul class="small text-muted mb-0">
                    <li>Les champs marqués d'une <span class="text-danger">*</span> sont obligatoires</li>
                    <li>Le numéro de téléphone sera vérifié en temps réel pour éviter les doublons</li>
                    <li>L'email du client sera utilisé pour les communications futures (facultatif)</li>
                    <li>Les informations médicales sont confidentielles et sécurisées</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    // Validation du formulaire
    document.getElementById('customerForm').addEventListener('submit', function(e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        this.classList.add('was-validated');
    });

    // Vérification de l'email en temps réel
    let emailTimeout;
    document.getElementById('email').addEventListener('input', function() {
        clearTimeout(emailTimeout);
        const email = this.value;
        const errorDiv = document.getElementById('emailError');

        if (email.length < 3) {
            errorDiv.textContent = '';
            return;
        }

        emailTimeout = setTimeout(() => {
            fetch('${pageContext.request.contextPath}/customers/check-email?email=' + encodeURIComponent(email))
                .then(response => response.json())
                .then(data => {
                    if (data.exists) {
                        errorDiv.textContent = '⚠️ Cet email est déjà utilisé';
                        this.classList.add('is-invalid');
                    } else {
                        errorDiv.textContent = '';
                        this.classList.remove('is-invalid');
                    }
                });
        }, 500);
    });

    // Vérification du téléphone en temps réel
    let phoneTimeout;
    document.getElementById('phone').addEventListener('input', function() {
        clearTimeout(phoneTimeout);
        const phone = this.value;
        const errorDiv = document.getElementById('phoneError');

        if (phone.length < 3) {
            errorDiv.textContent = '';
            return;
        }

        phoneTimeout = setTimeout(() => {
            fetch('${pageContext.request.contextPath}/customers/check-phone?phone=' + encodeURIComponent(phone))
                .then(response => response.json())
                .then(data => {
                    if (data.exists) {
                        errorDiv.textContent = '⚠️ Ce numéro est déjà utilisé';
                        this.classList.add('is-invalid');
                    } else {
                        errorDiv.textContent = '';
                        this.classList.remove('is-invalid');
                    }
                });
        }, 500);
    });

    // Formatage automatique du téléphone
    document.getElementById('phone').addEventListener('input', function() {
        let value = this.value.replace(/\D/g, '');
        if (value.length > 0) {
            value = value.match(/.{1,3}/g).join(' ');
        }
        this.value = value;
    });
</script>

<style>
    .was-validated .form-control:invalid {
        border-color: #dc3545;
    }

    .was-validated .form-control:valid {
        border-color: #198754;
    }
</style>