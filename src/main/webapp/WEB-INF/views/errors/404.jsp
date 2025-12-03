<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>404 - Page Non Trouvée | PharmaPlus</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            line-height: 1;
        }
        .error-animation {
            animation: bounce 2s infinite;
        }
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }
        .error-card {
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border-radius: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="error-container">
        <div class="error-card p-5 text-center">
            <div class="error-animation">
                <i class="bi bi-search" style="font-size: 6rem; color: #667eea;"></i>
            </div>

            <h1 class="error-code mt-4">404</h1>

            <h2 class="mt-3 mb-3">
                <i class="bi bi-exclamation-triangle-fill text-warning"></i>
                Page Non Trouvée
            </h2>

            <p class="lead text-muted mb-4">
                Oops ! La page que vous recherchez semble avoir disparu...
                Comme un médicament mal rangé !
            </p>

            <div class="alert alert-warning mb-4">
                <i class="bi bi-lightbulb"></i>
                <strong>Conseil :</strong> Vérifiez l'URL ou utilisez la recherche pour trouver ce que vous cherchez.
            </div>

            <div class="row g-3">
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary w-100">
                        <i class="bi bi-house-door"></i> Accueil
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary w-100">
                        <i class="bi bi-capsule"></i> Produits
                    </a>
                </div>
                <div class="col-md-4">
                    <button onclick="history.back()" class="btn btn-outline-secondary w-100">
                        <i class="bi bi-arrow-left"></i> Retour
                    </button>
                </div>
            </div>

            <div class="mt-5 pt-4 border-top">
                <p class="text-muted small">
                    <i class="bi bi-info-circle"></i>
                    Si vous pensez qu'il s'agit d'une erreur, contactez l'administrateur du système.
                </p>
                <p class="small text-muted">
                    <i class="bi bi-clock-history"></i>
                    Heure de l'erreur : <%= new java.util.Date() %>
                </p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>