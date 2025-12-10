<div class="navbar navbar-expand-lg navbar-dark bg-gradient-primary mb-4 shadow">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard">
            <i class="bi bi-speedometer2 me-2"></i> PharmaPlus Dashboard
        </a>
        <div class="navbar-nav ms-auto">
            <div class="d-flex align-items-center text-white">
                <div class="me-3 text-end">
                    <div class="small">Bonjour, <strong>Pharmacien</strong></div>
                    <div class="small" id="currentDate">${java.time.LocalDate.now()}</div>
                </div>
                <div class="dropdown">
                    <a href="#" class="text-white dropdown-toggle" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle fs-4"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profil">
                            <i class="bi bi-person"></i> Mon profil
                        </a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/settings">
                            <i class="bi bi-gear"></i> Paramètres
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right"></i> Déconnexion
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
