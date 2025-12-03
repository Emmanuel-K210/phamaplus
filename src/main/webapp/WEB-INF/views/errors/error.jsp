<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Erreur | PharmaPlus</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        .error-container {
            min-height: 70vh;
            padding: 40px 0;
        }
        .error-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            font-family: monospace;
            font-size: 0.9rem;
            max-height: 300px;
            overflow-y: auto;
        }
        .error-stack {
            display: none;
            margin-top: 20px;
        }
        .error-icon {
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.1); opacity: 0.7; }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body>
<div class="container error-container">
    <div class="text-center mb-5">
        <div class="error-icon">
            <i class="bi bi-bug" style="font-size: 5rem; color: #dc3545;"></i>
        </div>
        <h1 class="display-4 text-danger mt-3">
            <i class="bi bi-exclamation-triangle"></i> Oups !
        </h1>
        <p class="lead text-muted">
            Une erreur inattendue s'est produite dans le système.
        </p>
        <p class="text-muted">
            Notre équipe technique a été notifiée et travaille à résoudre le problème.
        </p>
    </div>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-danger text-white">
                    <i class="bi bi-info-circle"></i> Détails de l'erreur
                    <button class="btn btn-sm btn-light float-end" onclick="toggleStack()">
                        <i class="bi bi-code-slash"></i> Afficher la stack trace
                    </button>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <strong><i class="bi bi-chat-square-text"></i> Message :</strong>
                        <div class="alert alert-warning mt-2">
                            ${pageContext.exception.message}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong><i class="bi bi-link"></i> URL :</strong>
                            <p class="text-muted">${pageContext.errorData.requestURI}</p>
                        </div>
                        <div class="col-md-6">
                            <strong><i class="bi bi-code"></i> Code d'erreur :</strong>
                            <p class="text-muted">${pageContext.errorData.statusCode}</p>
                        </div>
                    </div>

                    <div id="errorStack" class="error-stack">
                        <strong><i class="bi bi-list-nested"></i> Stack Trace :</strong>
                        <div class="error-details mt-2">
                            <%
                                if (exception != null) {
                                    java.io.PrintWriter pw = new java.io.PrintWriter(out);
                                    exception.printStackTrace(pw);
                                }
                            %>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <div class="alert alert-info">
                            <i class="bi bi-lightbulb"></i>
                            <strong>Solution rapide :</strong> Essayez de rafraîchir la page ou de revenir à l'accueil.
                        </div>

                        <div class="d-grid gap-3 d-md-flex justify-content-md-center">
                            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                                <i class="bi bi-house-door"></i> Accueil
                            </a>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary">
                                <i class="bi bi-capsule"></i> Produits
                            </a>
                            <button onclick="history.back()" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> Retour
                            </button>
                            <button onclick="location.reload()" class="btn btn-outline-success">
                                <i class="bi bi-arrow-clockwise"></i> Rafraîchir
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-footer text-muted text-center">
                    <small>
                        <i class="bi bi-clock-history"></i>
                        Heure : <%= new java.util.Date() %> |
                        <i class="bi bi-server"></i>
                        PharmaPlus v1.0
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleStack() {
        const stack = document.getElementById('errorStack');
        stack.style.display = stack.style.display === 'none' || stack.style.display === '' ? 'block' : 'none';
    }

    // Affiche l'erreur dans la console pour le débogage
    console.error("PharmaPlus Error:", {
        message: "${pageContext.exception.message}",
        url: "${pageContext.errorData.requestURI}",
        status: ${pageContext.errorData.statusCode}
    });
</script>
</body>
</html>