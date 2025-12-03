<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - PharmaPlus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .login-container {
            max-width: 450px;
            width: 100%;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 30px;
            padding: 3rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
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
            width: 80px;
            height: 80px;
            background: var(--primary-gradient);
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            margin-bottom: 1rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .login-title {
            font-size: 2rem;
            font-weight: 700;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        .login-subtitle {
            color: #6c757d;
            font-size: 0.95rem;
        }

        .form-floating {
            margin-bottom: 1.5rem;
        }

        .form-control {
            border-radius: 15px;
            border: 2px solid rgba(102, 126, 234, 0.2);
            padding: 1rem 1.2rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .input-icon {
            position: absolute;
            right: 1.2rem;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            font-size: 1.2rem;
        }

        .btn-login {
            width: 100%;
            padding: 1rem;
            border-radius: 15px;
            border: none;
            background: var(--primary-gradient);
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn-login:hover::before {
            width: 400px;
            height: 400px;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }

        .divider {
            text-align: center;
            margin: 2rem 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 100%;
            height: 1px;
            background: linear-gradient(to right, transparent, #ddd, transparent);
        }

        .divider span {
            background: white;
            padding: 0 1rem;
            position: relative;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .register-link {
            text-align: center;
            margin-top: 2rem;
        }

        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }

        .register-link a:hover {
            color: #764ba2;
        }

        .alert-modern {
            border-radius: 15px;
            border: none;
            padding: 1rem 1.2rem;
            margin-bottom: 1.5rem;
        }

        .floating-shapes {
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            z-index: -1;
            overflow: hidden;
        }

        .shape {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            animation: float 20s infinite;
        }

        .shape:nth-child(1) {
            width: 100px;
            height: 100px;
            top: 10%;
            left: 20%;
            animation-delay: 0s;
        }

        .shape:nth-child(2) {
            width: 150px;
            height: 150px;
            top: 60%;
            left: 80%;
            animation-delay: 4s;
        }

        .shape:nth-child(3) {
            width: 80px;
            height: 80px;
            top: 80%;
            left: 10%;
            animation-delay: 2s;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0) rotate(0deg);
            }
            50% {
                transform: translateY(-20px) rotate(180deg);
            }
        }
    </style>
</head>
<body>

<div class="floating-shapes">
    <div class="shape"></div>
    <div class="shape"></div>
    <div class="shape"></div>
</div>

<div class="login-container">
    <div class="login-card">
        <div class="logo-section">
            <div class="logo-icon">
                <i class="bi bi-heart-pulse-fill"></i>
            </div>
            <h1 class="login-title">PharmaPlus</h1>
            <p class="login-subtitle">Connectez-vous à votre compte</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-modern" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    ${error}
            </div>
        </c:if>

        <c:if test="${not empty param.logout}">
            <div class="alert alert-success alert-modern" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                Déconnexion réussie
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="username" name="username"
                       placeholder="Nom d'utilisateur" required autofocus>
                <label for="username">
                    <i class="bi bi-person me-2"></i>Nom d'utilisateur
                </label>
            </div>

            <div class="form-floating mb-3">
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="Mot de passe" required>
                <label for="password">
                    <i class="bi bi-lock me-2"></i>Mot de passe
                </label>
            </div>

            <div class="form-check mb-4">
                <input class="form-check-input" type="checkbox" id="remember">
                <label class="form-check-label" for="remember">
                    Se souvenir de moi
                </label>
            </div>

            <button type="submit" class="btn btn-login">
                <i class="bi bi-box-arrow-in-right me-2"></i>Se connecter
            </button>

            <!-- Après le bouton de connexion -->
            <div class="d-flex justify-content-between align-items-center mt-3">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="remember" id="remember">
                    <label class="form-check-label" for="remember">
                        Se souvenir de moi
                    </label>
                </div>
                <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none">
                    <i class="bi bi-question-circle"></i> Mot de passe oublié ?
                </a>
            </div>
        </form>

        <div class="divider">
            <span>Ou</span>
        </div>

        <div class="register-link">
            <p class="mb-0">Vous n'avez pas de compte ?
                <a href="${pageContext.request.contextPath}/register">
                    Créer un compte <i class="bi bi-arrow-right"></i>
                </a>
            </p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>