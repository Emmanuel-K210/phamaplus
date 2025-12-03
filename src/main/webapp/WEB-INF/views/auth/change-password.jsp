<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-key text-primary me-2"></i>Changer le Mot de Passe
                    </h2>
                    <p class="text-muted mb-0">Mettez à jour votre mot de passe de sécurité</p>
                </div>
                <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Retour au Profil
                </a>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-6 mx-auto">
            <!-- Messages -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show modern-card mb-4">
                    <i class="bi bi-check-circle-fill me-2"></i>${param.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show modern-card mb-4">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Carte de sécurité -->
            <div class="modern-card p-4 mb-4">
                <div class="d-flex align-items-center mb-4">
                    <div class="bg-primary bg-opacity-10 rounded-circle p-3 me-3">
                        <i class="bi bi-shield-check text-primary" style="font-size: 2rem;"></i>
                    </div>
                    <div>
                        <h5 class="mb-1">Sécurité du Mot de Passe</h5>
                        <p class="mb-0 text-muted">Assurez-vous que votre compte reste sécurisé</p>
                    </div>
                </div>

                <div class="alert alert-info">
                    <strong><i class="bi bi-info-circle me-2"></i>Conseils de sécurité:</strong>
                    <ul class="mb-0 mt-2">
                        <li>Utilisez au moins 8 caractères</li>
                        <li>Mélangez majuscules, minuscules, chiffres et symboles</li>
                        <li>Évitez les informations personnelles évidentes</li>
                        <li>Ne réutilisez pas d'anciens mots de passe</li>
                    </ul>
                </div>
            </div>

            <!-- Formulaire -->
            <div class="modern-card p-4">
                <form action="${pageContext.request.contextPath}/change-password" method="post"
                      id="passwordForm" onsubmit="return validatePassword()">

                    <div class="mb-4">
                        <label for="currentPassword" class="form-label">
                            <i class="bi bi-lock me-1"></i>Mot de passe actuel <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-lock-fill"></i>
                            </span>
                            <input type="password" class="form-control modern-input"
                                   id="currentPassword" name="currentPassword"
                                   placeholder="Entrez votre mot de passe actuel" required>
                            <button class="btn btn-outline-secondary" type="button"
                                    onclick="togglePassword('currentPassword')">
                                <i class="bi bi-eye" id="currentPassword-icon"></i>
                            </button>
                        </div>
                    </div>

                    <hr class="my-4">

                    <div class="mb-4">
                        <label for="newPassword" class="form-label">
                            <i class="bi bi-key me-1"></i>Nouveau mot de passe <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-key-fill"></i>
                            </span>
                            <input type="password" class="form-control modern-input"
                                   id="newPassword" name="newPassword"
                                   placeholder="Entrez votre nouveau mot de passe"
                                   required minlength="6" oninput="checkPasswordStrength()">
                            <button class="btn btn-outline-secondary" type="button"
                                    onclick="togglePassword('newPassword')">
                                <i class="bi bi-eye" id="newPassword-icon"></i>
                            </button>
                        </div>

                        <!-- Indicateur de force du mot de passe -->
                        <div class="mt-3">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="small text-muted">Force du mot de passe:</span>
                                <span id="strengthText" class="small fw-bold"></span>
                            </div>
                            <div class="progress" style="height: 8px;">
                                <div id="strengthBar" class="progress-bar" role="progressbar"
                                     style="width: 0%"></div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label">
                            <i class="bi bi-shield-check me-1"></i>Confirmer le nouveau mot de passe <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-shield-check"></i>
                            </span>
                            <input type="password" class="form-control modern-input"
                                   id="confirmPassword" name="confirmPassword"
                                   placeholder="Confirmer votre nouveau mot de passe" required>
                            <button class="btn btn-outline-secondary" type="button"
                                    onclick="togglePassword('confirmPassword')">
                                <i class="bi bi-eye" id="confirmPassword-icon"></i>
                            </button>
                        </div>
                        <div id="passwordMatch" class="form-text"></div>
                    </div>

                    <div class="alert alert-warning d-flex align-items-center">
                        <i class="bi bi-exclamation-triangle fs-4 me-3"></i>
                        <div>
                            <strong>Important:</strong> Vous serez déconnecté après avoir changé votre mot de passe
                            et devrez vous reconnecter avec le nouveau mot de passe.
                        </div>
                    </div>

                    <div class="d-flex gap-3 justify-content-end pt-4 border-top mt-4">
                        <a href="${pageContext.request.contextPath}/profile"
                           class="btn btn-outline-secondary px-4">
                            <i class="bi bi-x-circle me-2"></i>Annuler
                        </a>
                        <button type="reset" class="btn btn-outline-warning px-4">
                            <i class="bi bi-arrow-counterclockwise me-2"></i>Réinitialiser
                        </button>
                        <button type="submit" class="btn btn-modern btn-gradient-success px-4">
                            <i class="bi bi-check-circle me-2"></i>Changer le Mot de Passe
                        </button>
                    </div>
                </form>
            </div>

            <!-- Historique de sécurité -->
            <div class="modern-card p-4 mt-4">
                <h5 class="mb-3">
                    <i class="bi bi-clock-history text-info me-2"></i>Historique de Sécurité
                </h5>
                <div class="list-group list-group-flush">
                    <div class="list-group-item px-0">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <i class="bi bi-shield-check text-success me-2"></i>
                                <strong>Dernière modification du mot de passe</strong>
                            </div>
                            <span class="text-muted">Il y a 30 jours</span>
                        </div>
                    </div>
                    <div class="list-group-item px-0">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <i class="bi bi-clock text-primary me-2"></i>
                                <strong>Dernière connexion</strong>
                            </div>
                            <span class="text-muted">Aujourd'hui à 14:30</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function togglePassword(fieldId) {
        const input = document.getElementById(fieldId);
        const icon = document.getElementById(fieldId + '-icon');

        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        }
    }

    function checkPasswordStrength() {
        const password = document.getElementById('newPassword').value;
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');

        let strength = 0;
        let text = '';
        let color = '';

        if (password.length >= 6) strength++;
        if (password.length >= 10) strength++;
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
        if (/\d/.test(password)) strength++;
        if (/[^a-zA-Z\d]/.test(password)) strength++;

        const percentage = (strength / 5) * 100;

        if (strength === 0) {
            text = '';
            color = '';
        } else if (strength <= 2) {
            text = 'Faible';
            color = 'bg-danger';
        } else if (strength <= 3) {
            text = 'Moyen';
            color = 'bg-warning';
        } else if (strength <= 4) {
            text = 'Bon';
            color = 'bg-info';
        } else {
            text = 'Excellent';
            color = 'bg-success';
        }

        strengthBar.style.width = percentage + '%';
        strengthBar.className = 'progress-bar ' + color;
        strengthText.textContent = text;
        strengthText.className = 'small fw-bold text-' + color.replace('bg-', '');
    }

    function validatePassword() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const matchDiv = document.getElementById('passwordMatch');

        if (newPassword !== confirmPassword) {
            matchDiv.innerHTML = '<i class="bi bi-x-circle text-danger me-1"></i>' +
                '<span class="text-danger">Les mots de passe ne correspondent pas</span>';
            return false;
        }

        return true;
    }

    // Vérifier la correspondance en temps réel
    document.getElementById('confirmPassword').addEventListener('input', function() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = this.value;
        const matchDiv = document.getElementById('passwordMatch');

        if (confirmPassword === '') {
            matchDiv.innerHTML = '';
        } else if (newPassword === confirmPassword) {
            matchDiv.innerHTML = '<i class="bi bi-check-circle text-success me-1"></i>' +
                '<span class="text-success">Les mots de passe correspondent</span>';
        } else {
            matchDiv.innerHTML = '<i class="bi bi-x-circle text-danger me-1"></i>' +
                '<span class="text-danger">Les mots de passe ne correspondent pas</span>';
        }
    });
</script>