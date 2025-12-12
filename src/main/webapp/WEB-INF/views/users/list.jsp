<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Désactiver le cache pour cette page --%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>

<div class="container-fluid px-4">
    <!-- Header avec titre et bouton -->
    <div class="d-flex justify-content-between align-items-center py-3 mb-4">
        <div>
            <h1 class="h3 mb-2 text-gray-800">
                <i class="bi bi-people me-2 text-primary"></i>
                Gestion des Utilisateurs
            </h1>
            <p class="text-muted mb-0">
                Gérez et administrez tous les utilisateurs du système PharmaPlus
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/users?action=new"
           class="btn btn-primary d-flex align-items-center">
            <i class="bi bi-plus-lg me-2"></i>
            <span>Nouvel Utilisateur</span>
        </a>
    </div>

    <!-- Messages de succès/erreur -->
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Cartes de statistiques -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs fw-bold text-primary text-uppercase mb-1">
                                Total Utilisateurs
                            </div>
                            <div class="h5 mb-0 fw-bold text-gray-800">
                                <c:out value="${userCount}" default="0" />
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-people fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs fw-bold text-success text-uppercase mb-1">
                                Utilisateurs Actifs
                            </div>
                            <div class="h5 mb-0 fw-bold text-gray-800">
                                <c:out value="${activeCount}" default="0" />
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-check-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs fw-bold text-info text-uppercase mb-1">
                                Administrateurs
                            </div>
                            <div class="h5 mb-0 fw-bold text-gray-800">
                                <c:out value="${adminCount}" default="0" />
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-shield-check fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs fw-bold text-warning text-uppercase mb-1">
                                Comptes Inactifs
                            </div>
                            <div class="h5 mb-0 fw-bold text-gray-800">
                                <c:out value="${inactiveCount}" default="0" />
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-x-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filtres et recherche -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 fw-bold text-primary">
                <i class="bi bi-funnel me-2"></i>Filtres de recherche
            </h6>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label small fw-bold text-muted">Recherche</label>
                    <div class="input-group">
                        <span class="input-group-text bg-transparent border-end-0">
                            <i class="bi bi-search text-muted"></i>
                        </span>
                        <input type="text" class="form-control border-start-0" id="searchInput"
                               placeholder="Rechercher par nom, utilisateur ou rôle...">
                    </div>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted">Rôle</label>
                    <select id="roleFilter" class="form-select">
                        <option value="">Tous les rôles</option>
                        <option value="ADMIN">Administrateur</option>
                        <option value="PHARMACIST">Pharmacien</option>
                        <option value="CASHIER">Caissier</option>
                        <option value="MANAGER">Manager</option>
                        <option value="ASSISTANT">Assistant</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted">Statut</label>
                    <select id="statusFilter" class="form-select">
                        <option value="">Tous les statuts</option>
                        <option value="active">Actif</option>
                        <option value="inactive">Inactif</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="button" onclick="resetFilters()" class="btn btn-outline-secondary w-100">
                        <i class="bi bi-arrow-counterclockwise me-1"></i>Réinitialiser
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Table des utilisateurs -->
    <div class="card shadow">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 fw-bold text-primary">
                <i class="bi bi-list-ul me-2"></i>Liste des Utilisateurs
                <span class="badge bg-primary ms-2"><c:out value="${userCount}" default="0" /></span>
            </h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover" id="usersTable">
                    <thead class="table-light">
                    <tr>
                        <th class="text-nowrap">
                            <i class="bi bi-hash me-1"></i>#
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-person me-1"></i>Utilisateur
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-person-vcard me-1"></i>Nom Complet
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-shield me-1"></i>Rôle
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-toggle-on me-1"></i>Statut
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-gear me-1"></i>Actions
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${users}" varStatus="status">
                        <tr class="user-row"
                            data-role="${user.role}"
                            data-status="${user.active ? 'active' : 'inactive'}"
                            data-search="${user.username} ${user.fullName} ${user.role}">
                            <td>
                                <span class="fw-bold text-primary">${status.index + 1}</span>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="user-avatar me-3" style="width: 40px; height: 40px; background-color: #667eea; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold;">
                                            ${user.fullName.substring(0,1).toUpperCase()}
                                    </div>
                                    <div>
                                        <div class="fw-bold">${user.username}</div>

                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="fw-medium">${user.fullName}</div>
                            </td>
                            <td>
                                <span class="badge
                                    <c:choose>
                                        <c:when test="${user.role eq 'ADMIN'}">bg-danger</c:when>
                                        <c:when test="${user.role eq 'PHARMACIST'}">bg-primary</c:when>
                                        <c:when test="${user.role eq 'CASHIER'}">bg-info</c:when>
                                        <c:when test="${user.role eq 'MANAGER'}">bg-success</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>">
                                        ${user.role}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.active}">
                                        <span class="badge bg-success bg-opacity-10 text-success border border-success">
                                            <i class="bi bi-check-circle-fill me-1"></i>Actif
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger">
                                            <i class="bi bi-x-circle-fill me-1"></i>Inactif
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/users?action=edit&id=${user.id}"
                                       class="btn btn-sm btn-outline-warning"
                                       data-bs-toggle="tooltip"
                                       title="Modifier">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <c:choose>
                                        <c:when test="${user.active}">
                                            <button type="button"
                                                    class="btn btn-sm btn-outline-danger"
                                                    onclick="toggleStatus(${user.id}, false)"
                                                    data-bs-toggle="tooltip"
                                                    title="Désactiver">
                                                <i class="bi bi-toggle-on"></i>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button"
                                                    class="btn btn-sm btn-outline-success"
                                                    onclick="toggleStatus(${user.id}, true)"
                                                    data-bs-toggle="tooltip"
                                                    title="Activer">
                                                <i class="bi bi-toggle-off"></i>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty users}">
                    <div class="text-center py-5">
                        <div class="mb-3">
                            <i class="bi bi-people display-1 text-muted"></i>
                        </div>
                        <h5 class="text-muted mb-2">Aucun utilisateur trouvé</h5>
                        <p class="text-muted mb-4">
                            Commencez par créer votre premier utilisateur
                        </p>
                        <a href="${pageContext.request.contextPath}/users?action=new"
                           class="btn btn-primary">
                            <i class="bi bi-plus-circle me-2"></i>Créer un utilisateur
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
        <c:if test="${userCount > 10}">
            <div class="card-footer bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="small text-muted">
                        Affichage de <span class="fw-bold"><c:out value="${userCount}" default="0" /></span> utilisateur(s)
                    </div>
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item disabled">
                                <a class="page-link" href="#" tabindex="-1">Précédent</a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#">Suivant</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </c:if>
    </div>
</div>

<style>
    .card {
        border: 1px solid #e3e6f0;
        border-radius: 0.5rem;
    }

    .card-header {
        border-bottom: 1px solid #e3e6f0;
        background-color: #f8f9fc;
    }

    .table td, .table th {
        vertical-align: middle;
        padding: 0.75rem;
    }

    .border-left-primary {
        border-left: 0.25rem solid #4e73df !important;
    }

    .border-left-success {
        border-left: 0.25rem solid #1cc88a !important;
    }

    .border-left-info {
        border-left: 0.25rem solid #36b9cc !important;
    }

    .border-left-warning {
        border-left: 0.25rem solid #f6c23e !important;
    }

    .shadow {
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15) !important;
    }

    .btn-sm {
        padding: 0.25rem 0.5rem;
        font-size: 0.75rem;
    }

    .badge {
        padding: 0.35em 0.65em;
        font-weight: 500;
    }

    .user-row {
        transition: background-color 0.2s;
    }

    .user-row:hover {
        background-color: rgba(0, 0, 0, 0.02);
    }
</style>

<script>
    // Variables pour les filtres
    let currentSearch = '';
    let currentRole = '';
    let currentStatus = '';

    // Fonction pour appliquer tous les filtres
    function applyFilters() {
        const rows = document.querySelectorAll('.user-row');
        let visibleCount = 0;

        rows.forEach(row => {
            const searchData = row.getAttribute('data-search').toLowerCase();
            const role = row.getAttribute('data-role');
            const status = row.getAttribute('data-status');

            let shouldShow = true;

            // Filtre de recherche
            if (currentSearch && !searchData.includes(currentSearch.toLowerCase())) {
                shouldShow = false;
            }

            // Filtre par rôle
            if (currentRole && role !== currentRole) {
                shouldShow = false;
            }

            // Filtre par statut
            if (currentStatus && status !== currentStatus) {
                shouldShow = false;
            }

            if (shouldShow) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Filtrage de la table
    document.getElementById('searchInput').addEventListener('input', function () {
        currentSearch = this.value.trim();
        applyFilters();
    });

    // Filtre par rôle
    document.getElementById('roleFilter').addEventListener('change', function () {
        currentRole = this.value;
        applyFilters();
    });

    // Filtre par statut
    document.getElementById('statusFilter').addEventListener('change', function () {
        currentStatus = this.value;
        applyFilters();
    });

    // Réinitialiser les filtres
    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('roleFilter').value = '';
        document.getElementById('statusFilter').value = '';

        currentSearch = '';
        currentRole = '';
        currentStatus = '';

        applyFilters();
    }

    // Fonction pour basculer le statut
    function toggleStatus(userId, activate) {
        const message = activate ?
            'Voulez-vous activer cet utilisateur ?' :
            'Voulez-vous désactiver cet utilisateur ?';

        if (confirm(message)) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/users';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'toggleStatus';
            form.appendChild(actionInput);

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = userId;
            form.appendChild(idInput);

            const activeInput = document.createElement('input');
            activeInput.type = 'hidden';
            activeInput.name = 'active';
            activeInput.value = activate;
            form.appendChild(activeInput);

            document.body.appendChild(form);
            form.submit();
        }
    }

    // Initialiser les tooltips
    document.addEventListener('DOMContentLoaded', function() {
        const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        tooltips.forEach(tooltip => new bootstrap.Tooltip(tooltip));

        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
</script>