<%-- /WEB-INF/views/customers/list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="fr_FR"/>

<style>
    /* Styles MODERNES et COHÉRENTS avec le layout */
    .customer-avatar {
        width: 45px;
        height: 45px;
        border-radius: 12px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 1rem;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.2);
    }

    .customer-card {
        transition: all 0.3s ease;
        border: 1px solid rgba(0,0,0,0.05);
        border-radius: 16px;
        overflow: hidden;
    }

    .customer-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        border-color: rgba(102, 126, 234, 0.2);
    }

    .status-badge {
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
        letter-spacing: 0.3px;
    }

    .action-hover {
        opacity: 0.6;
        transition: all 0.2s;
    }

    .action-hover:hover {
        opacity: 1;
        transform: scale(1.1);
    }

    .highlight-row {
        animation: highlightFade 2s ease-out;
    }

    @keyframes highlightFade {
        0% { background-color: rgba(102, 126, 234, 0.1); }
        100% { background-color: transparent; }
    }

    .stat-icon {
        width: 50px;
        height: 50px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
    }
</style>

<div class="customers-container fade-in-up">
    <!-- ========== HEADER HÉRO ========== -->
    <div class="row mb-5">
        <div class="col-12">
            <div class="modern-card p-4">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="d-flex align-items-center">
                            <div class="rounded-3 p-3 me-3" style="background: linear-gradient(135deg, #667eea20 0%, #764ba220 100%);">
                                <i class="bi bi-people-fill text-primary fs-2"></i>
                            </div>
                            <div>
                                <h1 class="fw-bold mb-1">Gestion des Clients</h1>
                                <p class="text-muted mb-0">
                                    <span class="fw-bold text-primary">${not empty totalCustomers ? totalCustomers : 0}</span> clients enregistrés dans votre pharmacie
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="${pageContext.request.contextPath}/customers/add"
                           class="btn btn-modern btn-gradient-primary px-4 py-2">
                            <i class="bi bi-person-plus-fill me-2"></i>Nouveau Client
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== STATISTIQUES EN GRID ========== -->
    <div class="row g-4 mb-5">
        <div class="col-xl-3 col-md-6">
            <div class="modern-card p-4">
                <div class="d-flex align-items-center">
                    <div class="stat-icon me-3" style="background: linear-gradient(135deg, #667eea20 0%, #764ba220 100%);">
                        <i class="bi bi-people-fill text-primary"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold mb-0">${not empty totalCustomers ? totalCustomers : 0}</h3>
                        <p class="text-muted mb-0">Clients totaux</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="modern-card p-4">
                <div class="d-flex align-items-center">
                    <div class="stat-icon me-3" style="background: linear-gradient(135deg, #11998e20 0%, #38ef7d20 100%);">
                        <i class="bi bi-envelope-fill text-success"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold mb-0">${not empty customersWithEmail ? customersWithEmail : 0}</h3>
                        <p class="text-muted mb-0">Avec email</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="modern-card p-4">
                <div class="d-flex align-items-center">
                    <div class="stat-icon me-3" style="background: linear-gradient(135deg, #f7971e20 0%, #ffd20020 100%);">
                        <i class="bi bi-exclamation-triangle-fill text-warning"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold mb-0">${not empty customersWithAllergies ? customersWithAllergies : 0}</h3>
                        <p class="text-muted mb-0">Avec allergies</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="modern-card p-4">
                <div class="d-flex align-items-center">
                    <div class="stat-icon me-3" style="background: linear-gradient(135deg, #4facfe20 0%, #00f2fe20 100%);">
                        <i class="bi bi-file-medical-fill text-info"></i>
                    </div>
                    <div>
                        <h3 class="fw-bold mb-0">${not empty customersWithPrescriptions ? customersWithPrescriptions : 0}</h3>
                        <p class="text-muted mb-0">Ordonnances</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== BARRE DE RECHERCHE AVANCÉE ========== -->
    <div class="modern-card mb-5">
        <div class="card-body p-4">
            <div class="row g-3">
                <div class="col-md-8">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0">
                            <i class="bi bi-search text-primary"></i>
                        </span>
                        <input type="text"
                               class="form-control modern-input border-start-0"
                               id="searchInput"
                               placeholder="Rechercher un client par nom, prénom, téléphone ou email..."
                               value="${param.search}">
                        <button class="btn btn-modern btn-gradient-primary" onclick="performSearch()">
                            <i class="bi bi-search me-2"></i>Rechercher
                        </button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="d-flex gap-2">
                        <button class="btn btn-modern btn-outline-secondary w-50" onclick="exportToPDF()">
                            <i class="bi bi-file-earmark-pdf me-2"></i>PDF
                        </button>
                        <button class="btn btn-modern btn-outline-success w-50" onclick="exportToExcel()">
                            <i class="bi bi-file-earmark-excel me-2"></i>Excel
                        </button>
                    </div>
                </div>
            </div>

            <!-- Filtres rapides -->
            <div class="row mt-4">
                <div class="col-12">
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/customers"
                           class="btn btn-sm ${empty param.filter ? 'btn-primary' : 'btn-outline-primary'}">
                            Tous les clients
                        </a>
                        <a href="${pageContext.request.contextPath}/customers?filter=with_email"
                           class="btn btn-sm ${param.filter == 'with_email' ? 'btn-success' : 'btn-outline-success'}">
                            <i class="bi bi-envelope me-1"></i>Avec email
                        </a>
                        <a href="${pageContext.request.contextPath}/customers?filter=with_allergies"
                           class="btn btn-sm ${param.filter == 'with_allergies' ? 'btn-warning' : 'btn-outline-warning'}">
                            <i class="bi bi-exclamation-triangle me-1"></i>Avec allergies
                        </a>
                        <a href="${pageContext.request.contextPath}/customers?filter=recent"
                           class="btn btn-sm ${param.filter == 'recent' ? 'btn-info' : 'btn-outline-info'}">
                            <i class="bi bi-clock-history me-1"></i>Récents
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========== TABLEAU MODERNE ========== -->
    <div class="modern-card">
        <div class="card-header bg-transparent border-0 p-4">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-bold">
                    <i class="bi bi-list-columns me-2"></i>Liste des Clients
                    <span class="badge-modern bg-primary ms-2">${not empty customers ? customers.size() : 0}</span>
                </h5>
                <div class="d-flex gap-2">
                    <button class="btn btn-sm btn-modern btn-outline-secondary" onclick="refreshPage()">
                        <i class="bi bi-arrow-clockwise"></i>
                    </button>
                    <button class="btn btn-sm btn-modern btn-outline-primary" onclick="printTable()">
                        <i class="bi bi-printer"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="modern-table">
                    <thead>
                    <tr>
                        <th class="ps-4">CLIENT</th>
                        <th>CONTACT</th>
                        <th>INFORMATIONS</th>
                        <th>STATUS</th>
                        <th class="text-center pe-4">ACTIONS</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty customers}">
                            <tr>
                                <td colspan="5" class="text-center py-5">
                                    <div class="text-center py-5">
                                        <i class="bi bi-people display-1 text-muted mb-4"></i>
                                        <h4 class="text-muted mb-3">Aucun client trouvé</h4>
                                        <p class="text-muted mb-4">Commencez par ajouter votre premier client</p>
                                        <a href="${pageContext.request.contextPath}/customers/add"
                                           class="btn btn-modern btn-gradient-primary px-4">
                                            <i class="bi bi-person-plus me-2"></i>Ajouter un client
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="customer" items="${customers}" varStatus="status">
                                <tr class="customer-row ${status.index == 0 ? 'highlight-row' : ''}">
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <div class="customer-avatar me-3">
                                                    ${customer.firstName.substring(0,1)}${customer.lastName.substring(0,1)}
                                            </div>
                                            <div>
                                                <div class="fw-bold">${customer.firstName} ${customer.lastName}</div>
                                                <div class="text-muted small">
                                                    ID: #${customer.customerId}
                                                    <c:if test="${not empty customer.dateOfBirth}">
                                                        • ${customer.age} ans
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column">
                                            <c:if test="${not empty customer.phone}">
                                                <div class="mb-1">
                                                    <i class="bi bi-telephone text-muted me-2"></i>
                                                    <span class="fw-medium">${customer.phone}</span>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty customer.email}">
                                                <div>
                                                    <i class="bi bi-envelope text-muted me-2"></i>
                                                    <a href="mailto:${customer.email}" class="text-decoration-none">
                                                            ${customer.email}
                                                    </a>
                                                </div>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column">
                                            <div class="mb-1">
                                                <i class="bi bi-calendar text-muted me-2"></i>
                                                <c:choose>
                                                    <c:when test="${not empty customer.dateOfBirth}">
                                                        <fmt:formatDate value="${customer.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Non renseigné</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <i class="bi bi-house text-muted me-2"></i>
                                                <c:choose>
                                                    <c:when test="${not empty customer.address}">
                                                            <span class="text-truncate d-inline-block" style="max-width: 200px;">
                                                                    ${customer.address}
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column gap-1">
                                                <span class="status-badge ${not empty customer.allergies ? 'bg-warning bg-opacity-10 text-warning' : 'bg-success bg-opacity-10 text-success'}">
                                                    <i class="bi ${not empty customer.allergies ? 'bi-exclamation-triangle' : 'bi-check-circle'} me-1"></i>
                                                    ${not empty customer.allergies ? 'Allergies' : 'Aucune allergie'}
                                                </span>
                                            <c:if test="${not empty customer.createdAt}">
                                                <small class="text-muted">
                                                    Inscrit le <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy"/>
                                                </small>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="text-center pe-4">
                                        <div class="d-flex justify-content-center gap-1">
                                            <!-- Vente rapide -->
                                            <a href="${pageContext.request.contextPath}/sales/create?customerId=${customer.customerId}"
                                               class="action-hover action-btn btn btn-success btn-sm"
                                               data-bs-toggle="tooltip" title="Nouvelle vente">
                                                <i class="bi bi-cart-plus"></i>
                                            </a>

                                            <!-- Voir détails -->
                                            <a href="${pageContext.request.contextPath}/customers/view?id=${customer.customerId}"
                                               class="action-hover action-btn btn btn-info btn-sm"
                                               data-bs-toggle="tooltip" title="Voir détails">
                                                <i class="bi bi-eye"></i>
                                            </a>

                                            <!-- Modifier -->
                                            <a href="${pageContext.request.contextPath}/customers/edit?id=${customer.customerId}"
                                               class="action-hover action-btn btn btn-primary btn-sm"
                                               data-bs-toggle="tooltip" title="Modifier">
                                                <i class="bi bi-pencil"></i>
                                            </a>

                                            <!-- Supprimer -->
                                            <button onclick="showDeleteModal(${customer.customerId})"
                                                    class="action-hover action-btn btn btn-danger btn-sm"
                                                    data-bs-toggle="tooltip" title="Supprimer">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${not empty customers and customers.size() > 0}">
                <div class="card-footer bg-transparent border-0 p-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="text-muted">
                            Affichage de <strong>${customers.size()}</strong> client(s)
                        </div>
                        <nav>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- ========== MODAL DE SUPPRESSION ========== -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content modern-card border-0">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title text-danger">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>Confirmation
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body py-4 text-center">
                <div class="mb-4">
                    <i class="bi bi-person-x-fill text-danger display-4"></i>
                </div>
                <h5 class="mb-3">Supprimer ce client ?</h5>
                <p class="text-muted">Cette action est irréversible. Toutes les données associées seront supprimées.</p>
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-modern btn-outline-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-2"></i>Annuler
                </button>
                <a href="#" class="btn btn-modern btn-gradient-danger" id="confirmDeleteBtn">
                    <i class="bi bi-trash me-2"></i>Supprimer définitivement
                </a>
            </div>
        </div>
    </div>
</div>

<!-- ========== JAVASCRIPT SÉCURISÉ ========== -->
<script>
    // Initialisation au chargement
    document.addEventListener('DOMContentLoaded', function() {
        // Initialiser les tooltips
        initTooltips();

        // Initialiser la recherche
        initSearch();
    });

    // Tooltips Bootstrap
    function initTooltips() {
        var tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        tooltips.forEach(function(el) {
            new bootstrap.Tooltip(el);
        });
    }

    // Recherche avec délai
    function initSearch() {
        var searchInput = document.getElementById('searchInput');
        var searchTimer;

        if (searchInput) {
            searchInput.addEventListener('keyup', function(e) {
                if (e.key === 'Enter') {
                    performSearch();
                } else {
                    clearTimeout(searchTimer);
                    searchTimer = setTimeout(performSearch, 500);
                }
            });
        }
    }

    // Exécuter la recherche
    function performSearch() {
        var searchInput = document.getElementById('searchInput');
        var searchValue = searchInput.value.trim();

        if (searchValue.length > 0) {
            window.location.href = '${pageContext.request.contextPath}/customers?search=' + encodeURIComponent(searchValue);
        } else {
            window.location.href = '${pageContext.request.contextPath}/customers';
        }
    }

    // Modal de suppression SÉCURISÉ
    function showDeleteModal(customerId) {
        var deleteBtn = document.getElementById('confirmDeleteBtn');

        // Construction SÉCURISÉE de l'URL (pas de template literals avec variables JSP)
        deleteBtn.href = '${pageContext.request.contextPath}/customers/delete?id=' + customerId;

        // Afficher le modal
        var modal = new bootstrap.Modal(document.getElementById('deleteModal'));
        modal.show();
    }

    // Export PDF (simulé)
    function exportToPDF() {
        alert('Export PDF - Fonctionnalité à implémenter');
        // window.location.href = '${pageContext.request.contextPath}/customers/export?format=pdf';
    }

    // Export Excel (simulé)
    function exportToExcel() {
        alert('Export Excel - Fonctionnalité à implémenter');
        // window.location.href = '${pageContext.request.contextPath}/customers/export?format=excel';
    }

    // Imprimer
    function printTable() {
        window.print();
    }

    // Rafraîchir
    function refreshPage() {
        window.location.reload();
    }

    // Animation d'entrée
    setTimeout(function() {
        document.querySelector('.customers-container').classList.add('fade-in-up');
    }, 100);
</script>