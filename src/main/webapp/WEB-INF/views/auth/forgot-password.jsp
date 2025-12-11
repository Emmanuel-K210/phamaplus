<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - PharmaPlus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #0d6efd 0%, #38ef7d 100%);
        }

        body {
            background: var(--success-gradient);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
        }

        .auth-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            transition: transform 0.3s;
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
        }

        .auth-card:hover {
            transform: translateY(-5px);
        }

        .auth-header {
            background: var(--success-gradient);
            padding: 2.5rem;
            color: white;
            text-align: center;
        }

        .auth-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }

        .auth-icon i {
            font-size: 2.5rem;
        }

        .auth-body {
            padding: 2rem;
        }

        .btn-auth {
            background: var(--success-gradient);
            border: none;
            color: white;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s;
            width: 100%;
        }

        .btn-auth:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            color: white;
        }

        .auth-input-group {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .auth-input-group .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            z-index: 10;
        }

        .auth-input {
            padding-left: 3rem !important;
            border-radius: 12px;
            border: 2px solid rgba(102, 126, 234, 0.2);
            transition: all 0.3s;
            height: 50px;
        }

        .auth-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .password-strength {
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            margin-top: 0.5rem;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            transition: width 0.3s;
        }

        .strength-weak { background: #f5576c; width: 25%; }
        .strength-fair { background: #f7971e; width: 50%; }
        .strength-good { background: #4facfe; width: 75%; }
        .strength-strong { background: #11998e; width: 100%; }

        /* Responsive */
        @media (max-width: 576px) {
            body {
                padding: 10px;
            }

            .auth-header {
                padding: 2rem 1.5rem;
            }

            .auth-body {
                padding: 1.5rem;
            }

            .auth-icon {
                width: 60px;
                height: 60px;
            }

            .auth-icon i {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-6">
            <div class="auth-card">
                <!-- Header -->
                <div class="auth-header">
                    <div class="auth-icon">
                        <i class="bi bi-key-fill"></i>
                    </div>
                    <h2 class="mb-2">Mot de passe oublié</h2>
                    <p class="opacity-90 mb-0">
                        Réinitialisez votre mot de passe en quelques étapes
                    </p>
                </div>

                <!-- Body -->
                <div class="auth-body">
                    <!-- Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <c:out value="${error}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>
                            <c:out value="${success}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>

                        <c:if test="${not empty username}">
                            <div class="alert alert-info">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-person-circle me-2 fs-4"></i>
                                    <div>
                                        <strong>Nom d'utilisateur :</strong> <c:out value="${username}" />
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:if>

                    <!-- Formulaire -->
                    <c:if test="${empty success}">
                        <form action="${pageContext.request.contextPath}/forgot-password" method="post" id="passwordForm">
                            <!-- Username -->
                            <div class="auth-input-group">
                                <i class="bi bi-person input-icon"></i>
                                <input type="text" class="form-control auth-input"
                                       name="username" required
                                       placeholder="Votre nom d'utilisateur"
                                       value="<c:out value='${param.username}' />">
                            </div>

                            <!-- Nouveau mot de passe -->
                            <div class="auth-input-group">
                                <i class="bi bi-lock input-icon"></i>
                                <input type="password" class="form-control auth-input"
                                       name="newPassword" required
                                       id="newPassword"
                                       placeholder="Nouveau mot de passe (6+ caractères)"
                                       oninput="checkPasswordStrength()">
                                <div class="password-strength">
                                    <div class="password-strength-bar" id="passwordStrengthBar"></div>
                                </div>
                                <small class="text-muted mt-1 d-block">
                                    <i class="bi bi-info-circle me-1"></i>
                                    Minimum 6 caractères
                                </small>
                            </div>

                            <!-- Confirmation -->
                            <div class="auth-input-group">
                                <i class="bi bi-lock-fill input-icon"></i>
                                <input type="password" class="form-control auth-input"
                                       name="confirmPassword" required
                                       id="confirmPassword"
                                       placeholder="Confirmez le mot de passe">
                                <small id="passwordMatch" class="text-muted mt-1"></small>
                            </div>

                            <!-- Boutons -->
                            <div class="d-grid gap-2 mt-4">
                                <button type="submit" class="btn btn-auth" id="submitBtn">
                                    <i class="bi bi-key me-2"></i>Réinitialiser le mot de passe
                                </button>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-2"></i>Retour à la connexion
                                </a>
                            </div>
                        </form>

                        <!-- Information -->
                        <div class="alert alert-light border mt-4">
                            <div class="d-flex">
                                <i class="bi bi-shield-check text-primary me-2"></i>
                                <div>
                                    <small class="text-muted">
                                        <strong>Sécurité :</strong> Pour des raisons de sécurité, évitez d'utiliser des mots de passe simples. Contactez l'administrateur si vous avez besoin d'assistance.
                                    </small>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Après succès -->
                    <c:if test="${not empty success}">
                        <div class="text-center">
                            <div class="mb-4">
                                <i class="bi bi-check-circle text-success" style="font-size: 3rem;"></i>
                            </div>
                            <h5 class="mb-3">Mot de passe mis à jour !</h5>
                            <p class="text-muted mb-4">
                                Votre mot de passe a été réinitialisé avec succès.
                            </p>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-auth">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Se connecter maintenant
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Vérification de la force du mot de passe
    function checkPasswordStrength() {
        const password = document.getElementById('newPassword').value;
        const bar = document.getElementById('passwordStrengthBar');
        let strength = 0;
        let className = '';

        if (password.length >= 6) strength++;
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;

        switch(strength) {
            case 0:
            case 1:
                className = 'strength-weak';
                break;
            case 2:
                className = 'strength-fair';
                break;
            case 3:
                className = 'strength-good';
                break;
            case 4:
            case 5:
                className = 'strength-strong';
                break;
        }

        bar.className = 'password-strength-bar ' + className;

        // Vérifier la correspondance
        checkPasswordMatch();
    }

    // Vérification de la correspondance des mots de passe
    function checkPasswordMatch() {
        const password = document.getElementById('newPassword').value;
        const confirm = document.getElementById('confirmPassword').value;
        const matchText = document.getElementById('passwordMatch');
        const submitBtn = document.getElementById('submitBtn');

        if (confirm.length === 0) {
            matchText.innerHTML = '';
            matchText.className = 'text-muted mt-1';
            submitBtn.disabled = false;
            return;
        }

        if (password === confirm) {
            matchText.innerHTML = '<i class="bi bi-check-circle text-success me-1"></i>Les mots de passe correspondent';
            matchText.className = 'text-success mt-1';
            submitBtn.disabled = false;
        } else {
            matchText.innerHTML = '<i class="bi bi-x-circle text-danger me-1"></i>Les mots de passe ne correspondent pas';
            matchText.className = 'text-danger mt-1';
            submitBtn.disabled = true;
        }
    }

    // Initialisation
    document.addEventListener('DOMContentLoaded', function() {
        // Initialiser les champs
        const confirmField = document.getElementById('confirmPassword');
        if (confirmField) {
            confirmField.addEventListener('input', checkPasswordMatch);
        }

        // Focus sur le premier champ
        const usernameField = document.querySelector('input[name="username"]');
        if (usernameField) {
            usernameField.focus();
        }

        // Validation du formulaire
        const form = document.getElementById('passwordForm');
        if (form) {
            form.addEventListener('submit', function(e) {
                const password = document.getElementById('newPassword').value;
                const confirm = document.getElementById('confirmPassword').value;

                if (password.length < 6) {
                    e.preventDefault();
                    alert('Le mot de passe doit contenir au moins 6 caractères');
                    return false;
                }

                if (password !== confirm) {
                    e.preventDefault();
                    alert('Les mots de passe ne correspondent pas');
                    return false;
                }

                // Désactiver le bouton pour éviter les doubles clics
                const submitBtn = document.getElementById('submitBtn');
                if (submitBtn) {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Traitement en cours...';
                }

                return true;
            });
        }
    });
</script>
</body>
</html>