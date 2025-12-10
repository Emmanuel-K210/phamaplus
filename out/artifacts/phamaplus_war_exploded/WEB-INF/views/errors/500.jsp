<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>405 - Méthode Non Autorisée | PharmaPlus</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        .error-container {
            min-height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-code {
            font-size: 8rem;
            font-weight: bold;
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            line-height: 1;
        }
        .error-icon {
            animation: shake 0.5s infinite alternate;
        }
        @keyframes shake {
            from { transform: rotate(-10deg); }
            to { transform: rotate(10deg); }
        }
        .method-list {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="error-container">
        <div class="error-card p-5 text-center" style="max-width: 800px;">
            <div class="error-icon">
                <i class="bi bi-slash-circle" style="font-size: 6rem; color: #dc3545;"></i>
            </div>

            <h1 class="error-code mt-4">405</h1>

            <h2 class="mt-3 mb-3">
                <i class="bi bi-x-octagon-fill text-danger"></i>
                Méthode Non Autorisée
            </h2>

            <p class="lead text-muted mb-4">
                La méthode HTTP utilisée n'est pas autorisée pour cette ressource.
                <br>
                <small>C'est comme essayer de vendre un médicament sans ordonnance !</small>
            </p>

            <div class="alert alert-danger mb-4">
                <i class="bi bi-exclamation-octagon"></i>
                <strong>Erreur :</strong> Nous Rencontrons un probleme interne
                <code class="fw-bold">${pageContext.errorData.requestMethod}</code>
                <span> Nous sommes actuellement entrain de le resourde si le problème persiste contacter l'equipe de dévelloppement</span>.
            </div>

            <div class="method-list mb-4">
                <h5 class="mb-3">
                    <i class="bi bi-check2-circle text-success"></i>
                    Méthodes autorisées pour cette ressource :
                </h5>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <span class="badge bg-success fs-6 p-2">
                        <i class="bi bi-eye"></i> GET
                    </span>
                    <span class="badge bg-primary fs-6 p-2">
                        <i class="bi bi-plus-circle"></i> POST
                    </span>
                    <span class="badge bg-warning fs-6 p-2">
                        <i class="bi bi-pencil"></i> PUT
                    </span>
                    <span class="badge bg-danger fs-6 p-2">
                        <i class="bi bi-trash"></i> DELETE
                    </span>
                </div>
            </div>

            <div class="row g-3">
                <div class="col-md-6">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary w-100">
                        <i class="bi bi-house-door"></i> Retour à l'accueil
                    </a>
                </div>
                <div class="col-md-6">
                    <button onclick="history.back()" class="btn btn-outline-danger w-100">
                        <i class="bi bi-arrow-counterclockwise"></i> Réessayer
                    </button>
                </div>
            </div>

            <div class="mt-5 pt-4 border-top">
                <div class="row">
                    <div class="col-md-6 text-start">
                        <p class="small text-muted">
                            <i class="bi bi-link"></i>
                            URL demandée : <br>
                            <code>${pageContext.errorData.requestURI}</code>
                        </p>
                    </div>
                    <div class="col-md-6 text-end">
                        <p class="small text-muted">
                            <i class="bi bi-clock-history"></i>
                            Heure : <%= new java.util.Date() %>
                        </p>
                        <p class="small text-muted">
                            <i class="bi bi-shield-check"></i>
                            PharmaPlus Security System
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>