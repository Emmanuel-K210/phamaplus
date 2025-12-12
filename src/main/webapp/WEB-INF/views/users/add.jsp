<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* Modern Gradient Colors */
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        --info-gradient: linear-gradient(135deg, #3a7bd5 0%, #00d2ff 100%);
        --warning-gradient: linear-gradient(135deg, #f46b45 0%, #eea849 100%);
        --danger-gradient: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
        --card-shadow: 0 8px 32px rgba(102, 126, 234, 0.1);
        --hover-shadow: 0 12px 48px rgba(102, 126, 234, 0.15);
    }

    .form-section {
        margin-bottom: 2.5rem;
        padding-bottom: 2.5rem;
        position: relative;
    }

    .form-section:not(:last-child):after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.3), transparent);
    }

    .form-section-title {
        color: #2d3748;
        font-weight: 700;
        margin-bottom: 1.75rem;
        padding-left: 0;
        position: relative;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 1.25rem;
    }

    .form-section-title:before {
        content: '';
        display: block;
        width: 4px;
        height: 24px;
        background: var(--primary-gradient);
        border-radius: 2px;
    }

    .required-field {
        font-weight: 600;
        color: #2d3748;
    }

    .required-field:after {
        content: " *";
        color: #f56565;
    }

    /* Modern Card Design */
    .modern-card {
        background: white;
        border-radius: 16px;
        border: 1px solid rgba(226, 232, 240, 0.8);
        box-shadow: var(--card-shadow);
        transition: all 0.3s ease;
        overflow: hidden;
    }

    .modern-card:hover {
        box-shadow: var(--hover-shadow);
        border-color: rgba(102, 126, 234, 0.3);
    }

    .modern-card .card-body {
        padding: 2rem;
    }

    /* Modern Input Styling */
    .modern-input {
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        padding: 0.875rem 1rem;
        font-size: 1rem;
        transition: all 0.3s ease;
        background: #f8fafc;
    }

    .modern-input:focus {
        border-color: #667eea;
        background: white;
        box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        outline: none;
    }

    /* Role Selection Grid - Modern */
    .role-grid-modern {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
        gap: 1rem;
        margin: 1.5rem 0;
    }

    .role-card-modern {
        background: white;
        border: 2px solid #e2e8f0;
        border-radius: 14px;
        padding: 1.5rem 1rem;
        cursor: pointer;
        transition: all 0.3s ease;
        text-align: center;
        position: relative;
        overflow: hidden;
    }

    .role-card-modern:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
    }

    .role-card-modern.selected {
        box-shadow: 0 8px 24px rgba(102, 126, 234, 0.2);
    }

    .role-card-modern.selected:after {
        content: '✓';
        position: absolute;
        top: 8px;
        right: 8px;
        width: 24px;
        height: 24px;
        background: #667eea;
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.875rem;
        font-weight: bold;
    }

    .role-card-modern .role-icon {
        font-size: 2.25rem;
        margin-bottom: 0.75rem;
    }

    .role-card-modern.role-admin .role-icon {
        background: var(--danger-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .role-card-modern.role-pharmacist .role-icon {
        background: var(--primary-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .role-card-modern.role-cashier .role-icon {
        background: var(--success-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .role-card-modern.role-manager .role-icon {
        background: var(--warning-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .role-card-modern.role-assistant .role-icon {
        background: var(--info-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .role-card-modern .role-name {
        font-weight: 600;
        color: #2d3748;
        font-size: 0.95rem;
        line-height: 1.4;
        margin-bottom: 0.5rem;
    }

    .role-card-modern .role-description {
        font-size: 0.8rem;
        color: #718096;
        line-height: 1.4;
    }

    /* Modern Button Group */
    .btn-group-modern {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
        margin-top: 3rem;
        padding-top: 2rem;
        border-top: 1px solid rgba(226, 232, 240, 0.8);
    }

    .btn-modern {
        border-radius: 12px;
        padding: 0.875rem 2rem;
        font-weight: 600;
        border: none;
        transition: all 0.3s ease;
    }

    .btn-modern.btn-gradient-primary {
        background: var(--primary-gradient);
        color: white;
    }

    .btn-modern.btn-gradient-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
    }

    .btn-modern.btn-outline-modern {
        background: white;
        border: 2px solid #e2e8f0;
        color: #4a5568;
    }

    .btn-modern.btn-outline-modern:hover {
        border-color: #667eea;
        color: #667eea;
        background: rgba(102, 126, 234, 0.05);
    }

    /* Page Header Modern */
    .page-header-modern {
        background: linear-gradient(135deg, #f8fafc 0%, #edf2f7 100%);
        border-radius: 20px;
        padding: 2rem;
        margin-bottom: 3rem;
        border: 1px solid rgba(226, 232, 240, 0.8);
        position: relative;
        overflow: hidden;
    }

    .page-header-modern:before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 4px;
        background: var(--primary-gradient);
    }

    /* Info Box Modern */
    .info-box-modern {
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
        border-radius: 16px;
        padding: 1.5rem;
        margin-bottom: 2rem;
        border: 1px solid rgba(102, 126, 234, 0.2);
        position: relative;
        overflow: hidden;
    }

    .info-box-modern:before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 4px;
        height: 100%;
        background: var(--primary-gradient);
    }

    /* Status Toggle Modern */
    .status-toggle-modern {
        background: white;
        border: 2px solid #e2e8f0;
        border-radius: 14px;
        padding: 1.5rem;
        margin-top: 1rem;
        transition: all 0.3s ease;
    }

    .status-toggle-modern.active {
        border-color: rgba(56, 239, 125, 0.3);
        background: linear-gradient(135deg, rgba(17, 153, 142, 0.03), rgba(56, 239, 125, 0.03));
    }

    .status-toggle-modern.inactive {
        border-color: rgba(245, 101, 101, 0.3);
        background: linear-gradient(135deg, rgba(245, 101, 101, 0.03), rgba(252, 129, 129, 0.03));
    }

    /* Form Validation Styling */
    .was-validated .modern-input:invalid {
        border-color: #fc8181;
        background: rgba(252, 129, 129, 0.05);
    }

    .was-validated .modern-input:valid {
        border-color: #48bb78;
    }

    .invalid-feedback {
        font-size: 0.875rem;
        color: #f56565;
        margin-top: 0.25rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    /* Password Strength Indicator */
    .password-strength {
        height: 4px;
        background: #e2e8f0;
        border-radius: 2px;
        margin-top: 0.5rem;
        overflow: hidden;
        position: relative;
    }

    .password-strength-bar {
        height: 100%;
        border-radius: 2px;
        transition: all 0.3s ease;
        width: 0;
    }

    .strength-weak { background: #f56565; }
    .strength-fair { background: #ed8936; }
    .strength-good { background: #48bb78; }
    .strength-strong { background: #38a169; }

    /* Responsive Design */
    @media (max-width: 768px) {
        .modern-card .card-body {
            padding: 1.5rem;
        }

        .role-grid-modern {
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
        }

        .btn-group-modern {
            flex-direction: column;
        }

        .btn-modern {
            width: 100%;
            justify-content: center;
        }

        .page-header-modern {
            padding: 1.5rem;
        }
    }

    @media (max-width: 480px) {
        .role-grid-modern {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="container-fluid">
    <!-- Modern Page Header -->
    <div class="page-header-modern mb-5">
        <div class="d-flex justify-content-between align-items-start">
            <div class="flex-grow-1">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-white p-2 rounded-circle shadow-sm me-3">
                        <i class="bi bi-person-plus-fill fs-4"
                           style="background: var(--primary-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"></i>
                    </div>
                    <div>
                        <h1 class="h3 fw-bold text-gray-800 mb-1">
                            Nouvel Utilisateur
                        </h1>
                        <p class="text-muted mb-0">
                            Créez un nouveau compte utilisateur pour le système PharmaPlus
                        </p>
                    </div>
                </div>

                <!-- Progress Indicator -->
                <div class="d-flex align-items-center mt-4">
                    <div class="d-flex align-items-center me-4">
                        <div class="bg-primary rounded-circle p-2 me-2">
                            <span class="text-white">1</span>
                        </div>
                        <span class="fw-medium">Informations de base</span>
                    </div>
                    <div class="me-4"><i class="bi bi-chevron-right text-gray-400"></i></div>
                    <div class="d-flex align-items-center">
                        <div class="bg-gray-200 rounded-circle p-2 me-2">
                            <span class="text-gray-500">2</span>
                        </div>
                        <span class="text-muted">Paramètres & validation</span>
                    </div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/users"
               class="btn btn-outline-modern btn-modern">
                <i class="bi bi-arrow-left me-2"></i>Retour
            </a>
        </div>
    </div>

    <!-- Error Messages -->
    <c:if test="${not empty error}">
        <div class="modern-card mb-4 border-left-4 border-left-danger">
            <div class="card-body d-flex align-items-start">
                <div class="bg-danger bg-opacity-10 p-2 rounded-circle me-3">
                    <i class="bi bi-exclamation-circle-fill text-danger"></i>
                </div>
                <div>
                    <h6 class="fw-bold mb-1">Erreur de validation</h6>
                    <p class="mb-0">${error}</p>
                </div>
                <button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.style.display='none'"></button>
            </div>
        </div>
    </c:if>

    <!-- Info Box -->
    <div class="info-box-modern mb-5">
        <div class="d-flex">
            <div class="flex-shrink-0 me-3">
                <div class="bg-primary bg-opacity-10 p-2 rounded-circle">
                    <i class="bi bi-shield-lock-fill text-primary"></i>
                </div>
            </div>
            <div class="flex-grow-1">
                <h5 class="fw-bold mb-2">Sécurité & Permissions</h5>
                <div class="row">
                    <div class="col-md-6">
                        <ul class="mb-0">
                            <li class="mb-2">
                                <i class="bi bi-asterisk text-danger me-2"></i>
                                <span class="text-muted">Champs obligatoires marqués d'une étoile</span>
                            </li>
                            <li class="mb-2">
                                <i class="bi bi-key-fill text-primary me-2"></i>
                                <span class="text-muted">Mot de passe minimum 8 caractères</span>
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <ul class="mb-0">
                            <li class="mb-2">
                                <i class="bi bi-shield-check text-success me-2"></i>
                                <span class="text-muted">Rôles définissent les permissions</span>
                            </li>
                            <li class="mb-2">
                                <i class="bi bi-person-check text-info me-2"></i>
                                <span class="text-muted">Activation immédiate après création</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Form -->
    <form method="post"
          action="${pageContext.request.contextPath}/users?action=create"
          id="userForm"
          class="needs-validation"
          novalidate>

        <!-- Basic Information -->
        <div class="modern-card mb-5">
            <div class="card-body">
                <h4 class="form-section-title">
                    Informations de Base
                </h4>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <label for="username" class="form-label required-field">
                            <i class="bi bi-person-badge me-2 text-primary"></i>
                            Nom d'utilisateur
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-at text-primary"></i>
                            </span>
                            <input type="text"
                                   class="form-control modern-input border-start-0"
                                   id="username"
                                   name="username"
                                   value="${user.username}"
                                   placeholder="ex: jean.dupont"
                                   minlength="3"
                                   required>
                        </div>
                        <div class="invalid-feedback d-flex align-items-center mt-2">
                            <i class="bi bi-x-circle-fill me-2"></i>
                            Minimum 3 caractères - utilisé pour se connecter
                        </div>
                        <small class="form-text text-muted mt-2 d-flex align-items-center">
                            <i class="bi bi-info-circle me-1"></i>
                            Unique et non modifiable après création
                        </small>
                    </div>

                    <div class="col-md-6 mb-4">
                        <label for="fullName" class="form-label required-field">
                            <i class="bi bi-person-vcard me-2 text-primary"></i>
                            Nom Complet
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-person-fill text-primary"></i>
                            </span>
                            <input type="text"
                                   class="form-control modern-input border-start-0"
                                   id="fullName"
                                   name="fullName"
                                   value="${user.fullName}"
                                   placeholder="Ex: Jean Dupont"
                                   required>
                        </div>
                        <div class="invalid-feedback d-flex align-items-center mt-2">
                            <i class="bi bi-x-circle-fill me-2"></i>
                            Veuillez saisir le nom complet
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <label for="password" class="form-label required-field">
                            <i class="bi bi-key me-2 text-primary"></i>
                            Mot de passe
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-lock text-primary"></i>
                            </span>
                            <input type="password"
                                   class="form-control modern-input border-start-0"
                                   id="password"
                                   name="password"
                                   placeholder="●●●●●●●●"
                                   minlength="6"
                                   required
                                   oninput="checkPasswordStrength()">
                        </div>
                        <div class="password-strength">
                            <div id="passwordStrengthBar" class="password-strength-bar"></div>
                        </div>
                        <div class="invalid-feedback d-flex align-items-center mt-2">
                            <i class="bi bi-x-circle-fill me-2"></i>
                            Minimum 6 caractères - sécurité renforcée
                        </div>
                        <small class="form-text text-muted mt-2 d-flex align-items-center">
                            <i class="bi bi-lightbulb me-1"></i>
                            Indice de force : faible → fort
                        </small>
                    </div>

                    <div class="col-md-6 mb-4">
                        <label for="confirmPassword" class="form-label required-field">
                            <i class="bi bi-key-fill me-2 text-primary"></i>
                            Confirmation
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-lock-fill text-primary"></i>
                            </span>
                            <input type="password"
                                   class="form-control modern-input border-start-0"
                                   id="confirmPassword"
                                   placeholder="●●●●●●●●"
                                   required>
                        </div>
                        <div id="passwordMatchFeedback" class="invalid-feedback d-flex align-items-center mt-2" style="display: none;">
                            <i class="bi bi-x-circle-fill me-2"></i>
                            Les mots de passe ne correspondent pas
                        </div>
                        <small class="form-text text-muted mt-2 d-flex align-items-center">
                            <i class="bi bi-check-circle me-1"></i>
                            Confirmez le mot de passe identique
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Role Selection -->
        <div class="modern-card mb-5">
            <div class="card-body">
                <h4 class="form-section-title">
                    Rôle & Permissions
                </h4>

                <div class="mb-4">
                    <label class="form-label required-field mb-3 d-block">
                        <i class="bi bi-shield me-2"></i>
                        Sélectionnez le rôle approprié
                    </label>

                    <div class="role-grid-modern">
                        <div class="role-card-modern role-admin" onclick="selectRole('ADMIN')">
                            <div class="role-icon">
                                <i class="bi bi-shield-check"></i>
                            </div>
                            <div class="role-name">Administrateur</div>
                            <div class="role-description">Accès complet au système</div>
                        </div>

                        <div class="role-card-modern role-pharmacist" onclick="selectRole('PHARMACIST')">
                            <div class="role-icon">
                                <i class="bi bi-capsule"></i>
                            </div>
                            <div class="role-name">Pharmacien</div>
                            <div class="role-description">Gestion produits et ordonnances</div>
                        </div>

                        <div class="role-card-modern role-cashier" onclick="selectRole('CASHIER')">
                            <div class="role-icon">
                                <i class="bi bi-cash-coin"></i>
                            </div>
                            <div class="role-name">Caissier</div>
                            <div class="role-description">Ventes et transactions</div>
                        </div>

                        <div class="role-card-modern role-manager" onclick="selectRole('MANAGER')">
                            <div class="role-icon">
                                <i class="bi bi-graph-up"></i>
                            </div>
                            <div class="role-name">Manager</div>
                            <div class="role-description">Supervision et rapports</div>
                        </div>

                        <div class="role-card-modern role-assistant" onclick="selectRole('ASSISTANT')">
                            <div class="role-icon">
                                <i class="bi bi-person-badge"></i>
                            </div>
                            <div class="role-name">Assistant</div>
                            <div class="role-description">Support et assistance</div>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="role" class="form-label required-field">
                        <i class="bi bi-pen me-2 text-primary"></i>
                        Rôle sélectionné
                    </label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0">
                            <i class="bi bi-person-gear text-primary"></i>
                        </span>
                        <input type="text"
                               class="form-control modern-input border-start-0"
                               id="role"
                               name="role"
                               value="${user.role}"
                               placeholder="Cliquez sur un rôle ci-dessus"
                               required
                               readonly>
                    </div>
                    <div class="invalid-feedback d-flex align-items-center mt-2">
                        <i class="bi bi-x-circle-fill me-2"></i>
                        Veuillez sélectionner un rôle pour l'utilisateur
                    </div>
                </div>
            </div>
        </div>

        <!-- Account Settings -->
        <div class="modern-card mb-5">
            <div class="card-body">
                <h4 class="form-section-title">
                    Paramètres du Compte
                </h4>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <label class="form-label d-block mb-3">
                            <i class="bi bi-toggle-on me-2 text-primary"></i>
                            Statut du compte
                        </label>

                        <div id="statusToggle" class="status-toggle-modern active">
                            <div class="form-check form-switch mb-0">
                                <input class="form-check-input"
                                       type="checkbox"
                                       role="switch"
                                       id="active"
                                       name="active"
                                       value="true"
                                       checked
                                       onchange="updateStatusToggle(this.checked)"
                                       style="width: 3.5em; height: 1.8em;">
                                <label class="form-check-label fw-semibold ms-3" for="active">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-toggle-on me-2 fs-5 text-success"></i>
                                        <span>Compte actif</span>
                                    </div>
                                    <small class="text-muted d-block mt-1">
                                        L'utilisateur peut se connecter immédiatement
                                    </small>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <label class="form-label d-block mb-3">
                            <i class="bi bi-info-circle me-2 text-primary"></i>
                            Informations complémentaires
                        </label>

                        <div class="modern-card border-0 bg-light p-3">
                            <div class="small text-muted">
                                <div class="mb-2">
                                    <i class="bi bi-clock-history me-2"></i>
                                    Créé automatiquement aujourd'hui
                                </div>
                                <div>
                                    <i class="bi bi-person-plus me-2"></i>
                                    Créé par ${sessionScope.fullName}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Form Actions -->
        <div class="btn-group-modern">
            <a href="${pageContext.request.contextPath}/users"
               class="btn btn-outline-modern btn-modern">
                <i class="bi bi-x-lg me-2"></i>Annuler
            </a>
            <button type="reset" class="btn btn-outline-modern btn-modern">
                <i class="bi bi-arrow-clockwise me-2"></i>Réinitialiser
            </button>
            <button type="submit" class="btn btn-modern btn-gradient-primary">
                <i class="bi bi-person-plus me-2"></i>
                Créer l'utilisateur
            </button>
        </div>
    </form>
</div>

<script>
    (function() {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    function selectRole(role) {
        document.getElementById('role').value = role;
        document.querySelectorAll('.role-card-modern').forEach(card => {
            card.classList.remove('selected');
        });
        event.currentTarget.classList.add('selected');
    }

    function updateStatusToggle(isActive) {
        const toggleDiv = document.getElementById('statusToggle');
        const icon = toggleDiv.querySelector('i');
        const label = toggleDiv.querySelector('span');
        const description = toggleDiv.querySelector('small');

        if (isActive) {
            toggleDiv.className = 'status-toggle-modern active';
            icon.className = 'bi bi-toggle-on me-2 fs-5 text-success';
            label.textContent = 'Compte actif';
            description.textContent = 'L\'utilisateur peut se connecter immédiatement';
        } else {
            toggleDiv.className = 'status-toggle-modern inactive';
            icon.className = 'bi bi-toggle-off me-2 fs-5 text-danger';
            label.textContent = 'Compte inactif';
            description.textContent = 'L\'utilisateur ne pourra pas se connecter';
        }
    }

    function checkPasswordStrength() {
        const password = document.getElementById('password').value;
        const strengthBar = document.getElementById('passwordStrengthBar');

        if (!password) {
            strengthBar.style.width = '0';
            strengthBar.className = 'password-strength-bar';
            return;
        }

        let strength = 0;
        if (password.length >= 6) strength++;
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;

        const percentages = ['0%', '25%', '50%', '75%', '100%'];
        const classes = ['strength-weak', 'strength-fair', 'strength-good', 'strength-strong', 'strength-strong'];

        strengthBar.style.width = percentages[Math.min(strength, 4)];
        strengthBar.className = 'password-strength-bar ' + classes[Math.min(strength, 4)];
    }

    function checkPasswordMatch() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const feedback = document.getElementById('passwordMatchFeedback');

        if (confirmPassword && password !== confirmPassword) {
            feedback.style.display = 'flex';
            document.getElementById('confirmPassword').classList.add('is-invalid');
        } else {
            feedback.style.display = 'none';
            document.getElementById('confirmPassword').classList.remove('is-invalid');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        // Check password match on input
        document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);
        document.getElementById('password').addEventListener('input', checkPasswordMatch);

        // Auto-hide alerts
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    });

    // Submit validation
    document.getElementById('userForm').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            e.preventDefault();
            e.stopPropagation();
            document.getElementById('passwordMatchFeedback').style.display = 'flex';
            document.getElementById('confirmPassword').classList.add('is-invalid');
        }
    });
</script>