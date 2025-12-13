<%-- WEB-INF/views/medical-receipts/list.jsp --%>
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
                <i class="bi bi-receipt-cutoff me-2 text-primary"></i>
                Reçus Médicaux
            </h1>
            <p class="text-muted mb-0">
                Gérez et suivez tous vos reçus médicaux en un seul endroit
            </p>
        </div>
            <div class="col-md-4 text-end">
            <a href="${pageContext.request.contextPath}/medical-receipts/new"
               class="btn btn-modern btn-gradient-primary px-4 py-2">
                <i class="bi bi-plus-lg me-2"></i>
                <span>Nouveau Reçu</span>
            </a>
            </div>
    </div>

    <!-- Messages de succès/erreur -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Cartes de statistiques -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs fw-bold text-primary text-uppercase mb-1">
                                Total Reçus
                            </div>
                            <div class="h5 mb-0 fw-bold text-gray-800">
                                <c:out value="${totalReceipts}" default="0" />
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-receipt fa-2x text-gray-300"></i>
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
                                Revenu Total
                            </div>
                            <div class="h5 mb-0 fw-bold text-gray-800">
                                <c:choose>
                                    <c:when test="${not empty totalRevenue}">
                                        <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="2" minFractionDigits="2" /> F CFA
                                    </c:when>
                                    <c:otherwise>0,00 F CFA</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-cash-stack fa-2x text-gray-300"></i>
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
                                Aujourd'hui
                            </div>
                            <div class="h5 mb-0 fw-bold text-gray-800">
                                <c:out value="${todayCount}" default="0" />
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-calendar-check fa-2x text-gray-300"></i>
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
                                7 Derniers Jours
                            </div>
                            <div class="h5 mb-0 fw-bold text-gray-800">
                                <c:out value="${weeklyCount}" default="0" />
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-graph-up fa-2x text-gray-300"></i>
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
                <i class="bi bi-funnel me-2"></i>Filtres
            </h6>
        </div>
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/medical-receipts"
                  class="row g-3">
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted">Date de début</label>
                    <input type="date" class="form-control" name="startDate"
                           value="${param.startDate}">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted">Date de fin</label>
                    <input type="date" class="form-control" name="endDate"
                           value="${param.endDate}">
                </div>
                <div class="col-md-4">
                    <label class="form-label small fw-bold text-muted">Recherche</label>
                    <input type="text" class="form-control" name="search"
                           placeholder="Rechercher par patient ou n° reçu..."
                           value="${param.search}">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <div class="d-flex gap-2 w-100">
                        <button type="submit" class="btn btn-gradient-primary flex-grow-1">
                            <i class="bi bi-search me-1"></i> Appliquer
                        </button>
                        <a href="${pageContext.request.contextPath}/medical-receipts"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-x-lg"></i>
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Table des reçus -->
    <div class="card shadow">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 fw-bold text-primary">
                <i class="bi bi-list-ul me-2"></i>Liste des Reçus
                <span class="badge bg-primary ms-2"><c:out value="${totalReceipts}" default="0" /></span>
            </h6>
            <div class="dropdown">
                <button class="btn btn-outline-primary dropdown-toggle" type="button"
                        data-bs-toggle="dropdown">
                    <i class="bi bi-download me-2"></i>Exporter
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#"><i class="bi bi-filetype-pdf me-2"></i>PDF</a></li>
                    <li><a class="dropdown-item" href="#"><i class="bi bi-filetype-csv me-2"></i>CSV</a></li>
                    <li><a class="dropdown-item" href="#"><i class="bi bi-filetype-xlsx me-2"></i>Excel</a></li>
                </ul>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover" id="receiptsTable">
                    <thead class="table-light">
                    <tr>
                        <th class="text-nowrap">
                            <i class="bi bi-hash me-1"></i>N° Reçu
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-person me-1"></i>Patient
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-calendar me-1"></i>Date
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-heart-pulse me-1"></i>Service
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-cash-coin me-1"></i>Montant
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-check-circle me-1"></i>Statut
                        </th>
                        <th class="text-nowrap">
                            <i class="bi bi-gear me-1"></i>Actions
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="receipt" items="${receipts}">
                        <tr>
                            <td>
                                <span class="fw-bold text-primary"><c:out value="${receipt.receiptNumber}" /></span>
                            </td>
                            <td>
                                <div class="fw-medium"><c:out value="${receipt.patientName}" /></div>
                                <c:if test="${not empty receipt.patientContact}">
                                    <small class="text-muted">
                                        <i class="bi bi-telephone me-1"></i><c:out value="${receipt.patientContact}" />
                                    </small>
                                </c:if>
                            </td>
                            <td>
                                <div class="text-nowrap">
                                    <i class="bi bi-clock me-1 text-muted"></i>
                                    <span class="fw-medium">
                                        <c:out value="${receipt.receiptDate}" />
                                    </span>
                                </div>
                            </td>
                            <td>
                                <span class="badge bg-light text-dark border">
                                    <i class="bi bi-activity me-1"></i><c:out value="${receipt.serviceType}" />
                                </span>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <span class="fw-bold text-success">
                                        <c:choose>
                                            <c:when test="${not empty receipt.amount}">
                                                <fmt:formatNumber value="${receipt.amount}" type="number" maxFractionDigits="2" minFractionDigits="2" /> FCFA
                                            </c:when>
                                            <c:otherwise>0,00 FCFA</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </td>
                            <td>
                                <span class="badge bg-success bg-opacity-10 text-success border border-success">
                                    <i class="bi bi-check-circle-fill me-1"></i>Payé
                                </span>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/medical-receipts/${receipt.receiptId}"
                                       class="btn btn-sm btn-outline-primary"
                                       data-bs-toggle="tooltip"
                                       title="Voir détails">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/medical-receipts/edit?id=${receipt.receiptId}"
                                       class="btn btn-sm btn-outline-warning"
                                       data-bs-toggle="tooltip"
                                       title="Modifier">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/medical-receipts/print?id=${receipt.receiptId}"
                                       class="btn btn-sm btn-outline-secondary"
                                       target="_blank"
                                       data-bs-toggle="tooltip"
                                       title="Imprimer">
                                        <i class="bi bi-printer"></i>
                                    </a>
                                    <button type="button"
                                            class="btn btn-sm btn-outline-danger"
                                            onclick="showDeleteModal('${receipt.receiptId}', '${receipt.receiptNumber}')"
                                            data-bs-toggle="tooltip"
                                            title="Supprimer">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty receipts}">
                    <div class="text-center py-5">
                        <div class="mb-3">
                            <i class="bi bi-receipt display-1 text-muted"></i>
                        </div>
                        <h5 class="text-muted mb-2">Aucun reçu trouvé</h5>
                        <p class="text-muted mb-4">
                            Commencez par créer votre premier reçu médical
                        </p>

                        <div class="col-md-4 text-end">
                        <a href="${pageContext.request.contextPath}/medical-receipts/new"
                           class="btn btn-modern btn-gradient-primary px-4 py-2">
                            <i class="bi bi-person-plus-fill me-2"></i>Créer un reçu
                        </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
        <c:if test="${totalReceipts > 10}">
            <div class="card-footer bg-light">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="small text-muted">
                        Affichage de <span class="fw-bold"><c:out value="${totalReceipts}" default="0" /></span> reçu(s)
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

<!-- Modal de suppression -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <div class="modal-title d-flex align-items-center">
                    <div class="bg-danger bg-opacity-10 p-2 rounded-circle me-3">
                        <i class="bi bi-exclamation-triangle-fill text-danger"></i>
                    </div>
                    <div>
                        <h5 class="mb-0">Confirmer la suppression</h5>
                        <p class="text-muted small mb-0">Action irréversible</p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body py-4">
                <p>Êtes-vous sûr de vouloir supprimer le reçu <strong id="receiptNumberToDelete"></strong> ?</p>
                <div class="alert alert-warning small mb-0">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Cette action supprimera définitivement le reçu et ne peut pas être annulée.
                </div>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                    Annuler
                </button>
                <form id="deleteForm" method="post" class="d-inline">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" id="receiptIdToDelete">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash me-2"></i>Supprimer
                    </button>
                </form>
            </div>
        </div>
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
</style>

<script>
    function showDeleteModal(id, receiptNumber) {
        document.getElementById('receiptIdToDelete').value = id;
        document.getElementById('receiptNumberToDelete').textContent = receiptNumber;
        document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/medical-receipts';

        const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
        modal.show();
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