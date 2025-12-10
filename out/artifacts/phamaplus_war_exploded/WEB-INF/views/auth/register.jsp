<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - PharmaPlus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        body {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }

        .register-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 30px;
            padding: 3rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 500px;
            width: 100%;
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo-section {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin-bottom: 1rem;
            box-shadow: 0 10px 30px rgba(17, 153, 142, 0.3);
        }

        .register-title {
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .form-control {
            border-radius: 15px;
            border: 2px solid rgba(17, 153, 142, 0.2);
            padding: 0.8rem 1.2rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: #11998e;
            box-shadow: 0 0 0 4px rgba(17, 153, 142, 0.1);
        }

        .btn-register {
            width: 100%;
            padding: 1rem;
            border-radius: 15px;
            border: none;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(17, 153, 142, 0.4);
        }

        .login-link {
            text-align: center;
            margin-top: 2rem;
        }

        .login-link a {
            color: #11998e;
            text-decoration: none;
            font-weight: 600;
        }

        .alert-modern {
            border-radius: 15px;
            border: none;
            padding: 1rem 1.2rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>

<div class="register-card">
    <div class="logo-section">
        <div class="logo-icon">
            <i class="bi bi-person-plus-fill"></i>
        </div>
        <h1 class="register-title">Créer un compte</h1>
        <p class="text-muted">Rejoignez PharmaPlus aujourd'hui</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-modern">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateForm()">
        <div class="mb-3">
            <label for="fullName" class="form-label">
                <i class="bi bi-person me-2"></i>Nom complet
            </label>
            <input type="text" class="form-control" id="fullName" name="fullName"
                   placeholder="Votre nom complet" required>
        </div>

        <div class="mb-3">
            <label for="username" class="form-label">
                <i class="bi bi-at me-2"></i>Nom d'utilisateur
            </label>
            <input type="text" class="form-control" id="username" name="username"
                   placeholder="Choisir un nom d'utilisateur" required>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label">
                <i class="bi bi-lock me-2"></i>Mot de passe
            </label>
            <input type="password" class="form-control" id="password" name="password"
                   placeholder="Créer un mot de passe" required minlength="6">
            <div class="form-text">Au moins 6 caractères</div>
        </div>

        <div class="mb-4">
            <label for="confirmPassword" class="form-label">
                <i class="bi bi-lock-fill me-2"></i>Confirmer le mot de passe
            </label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                   placeholder="Confirmer votre mot de passe" required>
        </div>

        <div class="form-check mb-4">
            <input class="form-check-input" type="checkbox" id="terms" required>
            <label class="form-check-label" for="terms">
                J'accepte les <a href="#" class="text-decoration-none">conditions d'utilisation</a>
            </label>
        </div>

        <button type="submit" class="btn btn-register">
            <i class="bi bi-person-check me-2"></i>Créer mon compte
        </button>
    </form>

    <div class="login-link">
        <p class="mb-0">Vous avez déjà un compte ?
            <a href="${pageContext.request.contextPath}/login">
                <i class="bi bi-box-arrow-in-right me-1"></i>Se connecter
            </a>
        </p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function validateForm() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            alert('Les mots de passe ne correspondent pas !');
            return false;
        }

        return true;
    }
</script>
</body>
</html>