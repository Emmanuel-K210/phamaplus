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

    .modern-input:read-only {
        background: #f1f5f9;
        border-color: #cbd5e0;
        color: #64748b;
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

    .btn-modern.btn-gradient-warning {
        background: var(--warning-gradient);
        color: white;
    }

    .btn-modern.btn-gradient-warning:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 24px rgba(244, 107, 69, 0.4);
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

    /* Tabs Modern */
    .nav-tabs-modern {
        border-bottom: 2px solid #e2e8f0;
        margin-bottom: 2rem;
    }

    .nav-tabs-modern .nav-link {
        border: none;
        border-radius: 12px 12px 0 0;
        padding: 1rem 1.5rem;
        font-weight: 600;
        color: #718096;
        background: #f8fafc;
        margin-right: 0.5rem;
        transition: all 0.3s ease;
        border-bottom: 2px solid transparent;
    }

    .nav-tabs-modern .nav-link:hover {
        color: #667eea;
        background: rgba(102, 126, 234, 0.05);
    }

    .nav-tabs-modern .nav-link.active {
        color: #667eea;
        background: white;
        border-bottom: 2px solid #667eea;
        box-shadow: 0 -4px 12px rgba(102, 126, 234, 0.1);
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

    /* Warning Box Modern */
    .warning-box-modern {
        background: linear-gradient(135deg, rgba(244, 107, 69, 0.05), rgba(238, 168, 73, 0.05));
        border-radius: 16px;
        padding: 1.5rem;
        margin-bottom: 2rem;
        border: 1px solid rgba(244, 107, 69, 0.2);
        position: relative;
        overflow: hidden;
    }

    .warning-box-modern:before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 4px;
        height: 100%;
        background: var(--warning-gradient);
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

        .nav-tabs-modern .nav-link {
            padding: 0.75rem 1rem;
            font-size: 0.9rem;
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
                        <i class="bi bi-person-gear fs-4"
                           style="background: var(--primary-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"></i>
                    </div>
                    <div>
                        <h1 class="h3 fw-bold text-gray-800 mb-1">
                            Modifier l'Utilisateur
                        </h1>
                        <p class="text-muted mb-0">
                            Mettez à jour les informations de ${user.fullName}
                        </p>
                    </div>
                </div>

                <!-- User Summary -->
                <div class="d-flex flex-wrap align-items-center gap-3 mt-4">
                    <div class="user-avatar" style="width: 50px; height: 50px; background: var(--primary-gradient); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 1.2rem;">
                        ${user.fullName.substring(0,1).toUpperCase()}
                    </div>
                    <div>
                        <div class="fw-bold">${user.username}</div>
                        <div class="d-flex flex-wrap gap-2">
                            <span class="badge bg-secondary">${user.role}</span>
                            <span class="badge ${user.active ? 'bg-success' : 'bg-danger'}">
                                ${user.active ? 'Actif' : 'Inactif'}
                            </span>
                        </div>
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

    <c:if test="${not empty success}">
        <div class="modern-card mb-4 border-left-4 border-left-success">
            <div class="card-body d-flex align-items-start">
                <div class="bg-success bg-opacity-10 p-2 rounded-circle me-3">
                    <i class="bi bi-check-circle-fill text-success"></i>
                </div>
                <div>
                    <h6 class="fw-bold mb-1">Succès !</h6>
                    <p class="mb-0">${success}</p>
                </div>
                <button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.style.display='none'"></button>
            </div>
        </div>
    </c:if>

    <!-- Tabs -->
    <ul class="nav nav-tabs-modern mb-4" id="userTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="profile-tab" data-bs-toggle="tab"
                    data-bs-target="#profile" type="button" role="tab">
                <i class="bi bi-person me-2"></i>Profil
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="password-tab" data-bs-toggle="tab"
                    data-bs-target="#password" type="button" role="tab">
                <i class="bi bi-key me-2"></i>Mot de passe
            </button>
        </li>
    </ul>

    <div class="tab-content" id="userTabsContent">
        <!-- Onglet Profil -->
        <div class="tab-pane fade show active" id="profile" role="tabpanel">
            <form method="POST" action="${pageContext.request.contextPath}/users?action=update"
                  class="needs-validation" novalidate>
                <input type="hidden" name="id" value="${user.id}">

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
                                           required
                                           readonly>
                                </div>
                                <small class="form-text text-muted mt-2 d-flex align-items-center">
                                    <i class="bi bi-lock me-1"></i>
                                    Non modifiable après création
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

                <!-- Account Status -->
                <div class="modern-card mb-5">
                    <div class="card-body">
                        <h4 class="form-section-title">
                            Statut du Compte
                        </h4>

                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label d-block mb-3">
                                    <i class="bi bi-toggle-on me-2 text-primary"></i>
                                    Activation du compte
                                </label>

                                <div id="statusToggle" class="status-toggle-modern ${user.active ? 'active' : 'inactive'}">
                                    <div class="form-check form-switch mb-0">
                                        <input class="form-check-input"
                                               type="checkbox"
                                               role="switch"
                                               id="active"
                                               name="active"
                                               value="true"
                                        ${user.active ? 'checked' : ''}
                                               onchange="updateStatusToggle(this.checked)"
                                               style="width: 3.5em; height: 1.8em;">
                                        <label class="form-check-label fw-semibold ms-3" for="active">
                                            <div class="d-flex align-items-center">
                                                <c:choose>
                                                    <c:when test="${user.active}">
                                                        <i class="bi bi-toggle-on me-2 fs-5 text-success"></i>
                                                        <span>Compte actif</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-toggle-off me-2 fs-5 text-danger"></i>
                                                        <span>Compte inactif</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <small class="text-muted d-block mt-1">
                                                ${user.active ?
                                                        'L\'utilisateur peut se connecter au système' :
                                                        'L\'utilisateur ne peut pas se connecter au système'}
                                            </small>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="btn-group-modern">
                    <button type="submit" class="btn btn-modern btn-gradient-primary">
                        <i class="bi bi-save me-2"></i>
                        Mettre à jour
                    </button>
                </div>
            </form>
        </div>

        <!-- Onglet Mot de passe -->
        <div class="tab-pane fade" id="password" role="tabpanel">
            <div class="warning-box-modern mb-5">
                <div class="d-flex">
                    <div class="flex-shrink-0 me-3">
                        <div class="bg-warning bg-opacity-10 p-2 rounded-circle">
                            <i class="bi bi-exclamation-triangle-fill text-warning"></i>
                        </div>
                    </div>
                    <div class="flex-grow-1">
                        <h5 class="fw-bold mb-2">Attention importante !</h5>
                        <p class="mb-0">
                            Cette action réinitialisera <strong>immédiatement</strong> le mot de passe de ${user.fullName}.
                            L'utilisateur devra utiliser le nouveau mot de passe lors de sa prochaine connexion.
                        </p>
                    </div>
                </div>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/users?action=resetPassword"
                  class="needs-validation" novalidate>
                <input type="hidden" name="id" value="${user.id}">

                <div class="modern-card mb-5">
                    <div class="card-body">
                        <h4 class="form-section-title">
                            Réinitialisation du Mot de Passe
                        </h4>

                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <label for="newPassword" class="form-label required-field">
                                    <i class="bi bi-key me-2 text-primary"></i>
                                    Nouveau mot de passe
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0">
                                        <i class="bi bi-lock text-primary"></i>
                                    </span>
                                    <input type="password"
                                           class="form-control modern-input border-start-0"
                                           id="newPassword"
                                           name="newPassword"
                                           placeholder="●●●●●●●●"
                                           minlength="6"
                                           required>
                                </div>
                                <div class="invalid-feedback d-flex align-items-center mt-2">
                                    <i class="bi bi-x-circle-fill me-2"></i>
                                    Minimum 6 caractères - sécurité renforcée
                                </div>
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
                                           name="confirmPassword"
                                           placeholder="●●●●●●●●"
                                           required>
                                </div>
                                <div id="passwordMatchFeedback" class="invalid-feedback d-flex align-items-center mt-2" style="display: none;">
                                    <i class="bi bi-x-circle-fill me-2"></i>
                                    Les mots de passe ne correspondent pas
                                </div>
                            </div>
                        </div>

                        <!-- Security Tips -->
                        <div class="modern-card border-0 bg-light p-4 mt-4">
                            <h6 class="fw-bold mb-3">
                                <i class="bi bi-shield-check me-2 text-primary"></i>
                                Conseils de sécurité :
                            </h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <ul class="list-unstyled mb-0">
                                        <li class="mb-2">
                                            <i class="bi bi-check-circle text-success me-2"></i>
                                            <small>Minimum 8 caractères</small>
                                        </li>
                                        <li class="mb-2">
                                            <i class="bi bi-check-circle text-success me-2"></i>
                                            <small>Majuscules et minuscules</small>
                                        </li>
                                        <li>
                                            <i class="bi bi-check-circle text-success me-2"></i>
                                            <small>Chiffres et symboles</small>
                                        </li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <ul class="list-unstyled mb-0">
                                        <li class="mb-2">
                                            <i class="bi bi-x-circle text-danger me-2"></i>
                                            <small>Évitez les mots courants</small>
                                        </li>
                                        <li class="mb-2">
                                            <i class="bi bi-x-circle text-danger me-2"></i>
                                            <small>Pas d'informations personnelles</small>
                                        </li>
                                        <li>
                                            <i class="bi bi-x-circle text-danger me-2"></i>
                                            <small>Pas de séquences simples</small>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="btn-group-modern">
                    <button type="button" onclick="switchTab('profile-tab')"
                            class="btn btn-outline-modern btn-modern">
                        <i class="bi bi-arrow-left me-2"></i>Retour au profil
                    </button>
                    <button type="submit" class="btn btn-modern btn-gradient-warning">
                        <i class="bi bi-arrow-repeat me-2"></i>
                        Réinitialiser le mot de passe
                    </button>
                </div>
            </form>
        </div>
    </div>
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
            description.textContent = 'L\'utilisateur peut se connecter au système';
        } else {
            toggleDiv.className = 'status-toggle-modern inactive';
            icon.className = 'bi bi-toggle-off me-2 fs-5 text-danger';
            label.textContent = 'Compte inactif';
            description.textContent = 'L\'utilisateur ne peut pas se connecter au système';
        }
    }

    function switchTab(tabId) {
        const tab = document.getElementById(tabId);
        if (tab) {
            const tabInstance = new bootstrap.Tab(tab);
            tabInstance.show();
        }
    }

    function checkPasswordMatch() {
        const newPassword = document.getElementById('newPassword')?.value;
        const confirmPassword = document.getElementById('confirmPassword')?.value;
        const feedback = document.getElementById('passwordMatchFeedback');

        if (!newPassword || !confirmPassword) return;

        if (newPassword !== confirmPassword) {
            feedback.style.display = 'flex';
            document.getElementById('confirmPassword').classList.add('is-invalid');
        } else {
            feedback.style.display = 'none';
            document.getElementById('confirmPassword').classList.remove('is-invalid');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        // Initialize role selection
        const userRole = '${user.role}';
        if (userRole) {
            const roleInput = document.getElementById('role');
            if (roleInput) {
                roleInput.value = userRole;
                document.querySelectorAll('.role-card-modern').forEach(card => {
                    if (card.textContent.includes(userRole)) {
                        card.classList.add('selected');
                    }
                });
            }
        }

        // Check password match
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const newPasswordInput = document.getElementById('newPassword');

        if (confirmPasswordInput && newPasswordInput) {
            confirmPasswordInput.addEventListener('input', checkPasswordMatch);
            newPasswordInput.addEventListener('input', checkPasswordMatch);
        }

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

    // Submit validation for password reset
    const passwordForm = document.querySelector('form[action*="resetPassword"]');
    if (passwordForm) {
        passwordForm.addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword')?.value;
            const confirmPassword = document.getElementById('confirmPassword')?.value;

            if (newPassword !== confirmPassword) {
                e.preventDefault();
                e.stopPropagation();
                document.getElementById('passwordMatchFeedback').style.display = 'flex';
                document.getElementById('confirmPassword').classList.add('is-invalid');
            }
        });
    }
</script>