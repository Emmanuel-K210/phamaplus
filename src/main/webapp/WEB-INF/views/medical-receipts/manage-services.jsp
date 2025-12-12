<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-tags text-primary me-2"></i>Gestion des Services Médicaux
                    </h2>
                    <p class="text-muted mb-0">
                        Configurez les types de prestations médicales disponibles
                    </p>
                </div>
                <button type="button" class="btn btn-modern btn-gradient-primary"
                        data-bs-toggle="modal" data-bs-target="#addServiceModal">
                    <i class="bi bi-plus-circle me-2"></i>Ajouter un Service
                </button>
            </div>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show modern-card mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            <strong>Succès !</strong> ${fn:escapeXml(param.success)}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show modern-card mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <strong>Erreur !</strong> ${fn:escapeXml(param.error)}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Statistiques -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1" id="totalServices">${fn:length(serviceTypes)}</h3>
                        <p class="mb-0 opacity-75">Services Totaux</p>
                    </div>
                    <i class="bi bi-tags stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1" id="activeServices">
                            <c:set var="activeCount" value="0" />
                            <c:forEach var="service" items="${serviceTypes}">
                                <c:if test="${service.isActive}">
                                    <c:set var="activeCount" value="${activeCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${activeCount}
                        </h3>
                        <p class="mb-0 opacity-75">Services Actifs</p>
                    </div>
                    <i class="bi bi-toggle-on stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1" id="consultationServices">
                            <c:set var="consultationCount" value="0" />
                            <c:forEach var="service" items="${serviceTypes}">
                                <c:if test="${service.serviceCategory == 'Consultation'}">
                                    <c:set var="consultationCount" value="${consultationCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${consultationCount}
                        </h3>
                        <p class="mb-0 opacity-75">Consultations</p>
                    </div>
                    <i class="bi bi-file-medical stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1" id="examenServices">
                            <c:set var="examenCount" value="0" />
                            <c:forEach var="service" items="${serviceTypes}">
                                <c:if test="${service.serviceCategory == 'Examen'}">
                                    <c:set var="examenCount" value="${examenCount + 1}" />
                                </c:if>
                            </c:forEach>
                            ${examenCount}
                        </h3>
                        <p class="mb-0 opacity-75">Examens</p>
                    </div>
                    <i class="bi bi-clipboard-pulse stat-icon"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Filtres -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="modern-card p-4">
                <div class="row g-3">
                    <div class="col-md-3">
                        <input type="text" class="form-control modern-input"
                               id="searchServices" placeholder="Rechercher un service...">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" id="filterCategory">
                            <option value="">Toutes les catégories</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${fn:escapeXml(category)}">${fn:escapeXml(category)}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select modern-input" id="filterStatus">
                            <option value="">Tous les statuts</option>
                            <option value="active">Actifs seulement</option>
                            <option value="inactive">Inactifs seulement</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button type="button" class="btn btn-modern btn-outline-secondary w-100"
                                onclick="resetFilters()">
                            <i class="bi bi-arrow-clockwise me-2"></i>Réinitialiser
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tableau des services -->
    <div class="row">
        <div class="col-12">
            <div class="modern-card p-0">
                <div class="table-responsive">
                    <table class="table modern-table mb-0" id="servicesTable">
                        <thead>
                        <tr>
                            <th><i class="bi bi-hash me-2"></i>Code</th>
                            <th><i class="bi bi-file-medical me-2"></i>Service</th>
                            <th><i class="bi bi-tags me-2"></i>Catégorie</th>
                            <th><i class="bi bi-cash me-2"></i>Prix</th>
                            <th><i class="bi bi-toggle-on me-2"></i>Statut</th>
                            <th><i class="bi bi-calendar me-2"></i>Créé le</th>
                            <th class="text-center"><i class="bi bi-gear me-2"></i>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty serviceTypes}">
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="bi bi-file-medical display-1 text-muted d-block mb-3"></i>
                                        <h5 class="text-muted">Aucun service médical configuré</h5>
                                        <button type="button" class="btn btn-modern btn-gradient-primary mt-3"
                                                data-bs-toggle="modal" data-bs-target="#addServiceModal">
                                            <i class="bi bi-plus-circle me-2"></i>Ajouter votre premier service
                                        </button>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="service" items="${serviceTypes}">
                                    <tr data-service-id="${service.serviceId}"
                                        data-service-name="${fn:escapeXml(service.serviceName)}"
                                        data-service-category="${fn:escapeXml(service.serviceCategory)}"
                                        data-service-status="${service.isActive ? 'active' : 'inactive'}">
                                        <td>
                                                <span class="badge badge-modern bg-primary">
                                                        ${fn:escapeXml(service.serviceCode)}
                                                </span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-start">
                                                <div class="me-3">
                                                    <div class="bg-primary bg-opacity-10 rounded-circle p-2">
                                                        <i class="bi bi-file-medical text-primary"></i>
                                                    </div>
                                                </div>
                                                <div>
                                                    <strong>${fn:escapeXml(service.serviceName)}</strong>
                                                    <c:if test="${not empty service.description}">
                                                        <br>
                                                        <small class="text-muted">
                                                                ${fn:escapeXml(service.description)}
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                                <span class="badge badge-modern bg-info">
                                                        ${fn:escapeXml(service.serviceCategory)}
                                                </span>
                                        </td>
                                        <td>
                                            <strong class="text-success">
                                                <fmt:formatNumber value="${service.defaultPrice}" pattern="#,##0" /> F CFA
                                            </strong>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${service.isActive}">
                                                        <span class="badge badge-modern bg-success">
                                                            <i class="bi bi-check-circle me-1"></i>Actif
                                                        </span>
                                                </c:when>
                                                <c:otherwise>
                                                        <span class="badge badge-modern bg-danger">
                                                            <i class="bi bi-x-circle me-1"></i>Inactif
                                                        </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty service.createdAt}">
                                                    <fmt:formatDate value="${service.createdAtAsDate}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <button type="button" class="btn btn-outline-primary btn-edit-service"
                                                        data-service-id="${service.serviceId}"
                                                        data-service-code="${fn:escapeXml(service.serviceCode)}"
                                                        data-service-name="${fn:escapeXml(service.serviceName)}"
                                                        data-service-category="${fn:escapeXml(service.serviceCategory)}"
                                                        data-default-price="${service.defaultPrice}"
                                                        data-is-active="${service.isActive}"
                                                        data-description="${fn:escapeXml(service.description)}">
                                                    <i class="bi bi-pencil"></i> Modifier
                                                </button>

                                                <c:choose>
                                                    <c:when test="${service.isActive}">
                                                        <button type="button" class="btn btn-outline-warning btn-toggle-service"
                                                                data-service-id="${service.serviceId}"
                                                                data-action="deactivate">
                                                            <i class="bi bi-toggle-off"></i> Désactiver
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn btn-outline-success btn-toggle-service"
                                                                data-service-id="${service.serviceId}"
                                                                data-action="activate">
                                                            <i class="bi bi-toggle-on"></i> Activer
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>

                                                <button type="button" class="btn btn-outline-danger btn-delete-service"
                                                        data-service-id="${service.serviceId}"
                                                        data-service-name="${fn:escapeXml(service.serviceName)}">
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

                <!-- Pagination (si nécessaire) -->
                <c:if test="${fn:length(serviceTypes) > 10}">
                    <div class="p-4 border-top">
                        <div class="d-flex justify-content-between align-items-center">
                            <p class="mb-0 text-muted">
                                Affichage de <strong id="visibleServices">${fn:length(serviceTypes)}</strong> services
                            </p>
                            <nav aria-label="Navigation des pages">
                                <ul class="pagination mb-0" id="servicesPagination">
                                    <!-- Généré par JavaScript -->
                                </ul>
                            </nav>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- ============================================= -->
<!-- MODAL : Ajouter un service -->
<!-- ============================================= -->
<div class="modal fade" id="addServiceModal" tabindex="-1" aria-labelledby="addServiceModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-gradient-primary text-white">
                <h5 class="modal-title" id="addServiceModalLabel">
                    <i class="bi bi-plus-circle me-2"></i>Nouveau Service Médical
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form id="addServiceForm" action="${pageContext.request.contextPath}/medical-receipts/services/create" method="post">
                <div class="modal-body">
                    <div class="row g-3">
                        <!-- Code du service -->
                        <div class="col-md-6">
                            <label for="serviceCode" class="form-label fw-bold">
                                Code du Service <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control modern-input"
                                   id="serviceCode" name="serviceCode" required
                                   placeholder="Ex: OPHT, GYN, ECHO..."
                                   pattern="[A-Z-]{2,10}"
                                   title="2-10 lettres majuscules ou tirets">
                            <div class="invalid-feedback" id="codeFeedback">
                                Veuillez entrer un code valide (2-10 majuscules)
                            </div>
                            <div class="form-text">Code unique en majuscules (ex: OPHT, GYN)</div>
                        </div>

                        <!-- Nom du service -->
                        <div class="col-md-6">
                            <label for="serviceName" class="form-label fw-bold">
                                Nom du Service <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control modern-input"
                                   id="serviceName" name="serviceName" required
                                   placeholder="Ex: Ophtamo, Gynéco, Écho...">
                            <div class="invalid-feedback">
                                Veuillez entrer le nom du service
                            </div>
                        </div>

                        <!-- Catégorie -->
                        <div class="col-md-6">
                            <label for="serviceCategory" class="form-label fw-bold">
                                Catégorie <span class="text-danger">*</span>
                            </label>
                            <select class="form-select modern-input" id="serviceCategory" name="serviceCategory" required>
                                <option value="">Sélectionnez une catégorie</option>
                                <option value="Consultation">Consultation</option>
                                <option value="Examen">Examen</option>
                                <option value="Analyse">Analyse</option>
                                <option value="Traitement">Traitement</option>
                                <option value="Vaccination">Vaccination</option>
                                <option value="Chirurgie">Chirurgie</option>
                                <option value="Divers">Divers</option>
                                <option value="Autre">Autre</option>
                            </select>
                            <div class="invalid-feedback">
                                Veuillez sélectionner une catégorie
                            </div>
                        </div>

                        <!-- Prix par défaut -->
                        <div class="col-md-6">
                            <label for="defaultPrice" class="form-label fw-bold">
                                Prix par défaut (F CFA) <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" class="form-control modern-input"
                                       id="defaultPrice" name="defaultPrice" required
                                       min="0" step="100" value="0"
                                       placeholder="Prix en F CFA">
                                <span class="input-group-text">F CFA</span>
                            </div>
                            <div class="invalid-feedback">
                                Veuillez entrer un prix valide
                            </div>
                        </div>

                        <!-- Statut actif -->
                        <div class="col-md-6">
                            <div class="form-check form-switch mt-4">
                                <input class="form-check-input" type="checkbox"
                                       id="isActive" name="isActive" checked>
                                <label class="form-check-label fw-bold" for="isActive">
                                    <i class="bi bi-toggle-on me-1"></i>Service Actif
                                </label>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="col-12">
                            <label for="description" class="form-label fw-bold">Description</label>
                            <textarea class="form-control modern-input"
                                      id="description" name="description"
                                      rows="3" placeholder="Description détaillée du service..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-2"></i>Annuler
                    </button>
                    <button type="submit" class="btn btn-modern btn-gradient-primary" id="submitAddService">
                        <i class="bi bi-check-circle me-2"></i>Enregistrer le Service
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ============================================= -->
<!-- MODAL : Modifier un service -->
<!-- ============================================= -->
<div class="modal fade" id="editServiceModal" tabindex="-1" aria-labelledby="editServiceModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-gradient-warning text-dark">
                <h5 class="modal-title" id="editServiceModalLabel">
                    <i class="bi bi-pencil-square me-2"></i>Modifier le Service
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form id="editServiceForm" action="${pageContext.request.contextPath}/medical-receipts/services/update" method="post">
                <input type="hidden" id="editServiceId" name="serviceId">

                <div class="modal-body">
                    <div class="row g-3">
                        <!-- Code du service (non modifiable) -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Code du Service</label>
                            <input type="text" class="form-control modern-input bg-light"
                                   id="editServiceCode" readonly>
                            <div class="form-text">Le code ne peut pas être modifié</div>
                        </div>

                        <!-- Nom du service -->
                        <div class="col-md-6">
                            <label for="editServiceName" class="form-label fw-bold">
                                Nom du Service <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control modern-input"
                                   id="editServiceName" name="serviceName" required>
                            <div class="invalid-feedback">
                                Veuillez entrer le nom du service
                            </div>
                        </div>

                        <!-- Catégorie -->
                        <div class="col-md-6">
                            <label for="editServiceCategory" class="form-label fw-bold">
                                Catégorie <span class="text-danger">*</span>
                            </label>
                            <select class="form-select modern-input" id="editServiceCategory" name="serviceCategory" required>
                                <option value="">Sélectionnez une catégorie</option>
                                <option value="Consultation">Consultation</option>
                                <option value="Examen">Examen</option>
                                <option value="Analyse">Analyse</option>
                                <option value="Traitement">Traitement</option>
                                <option value="Vaccination">Vaccination</option>
                                <option value="Chirurgie">Chirurgie</option>
                                <option value="Divers">Divers</option>
                                <option value="Autre">Autre</option>
                            </select>
                            <div class="invalid-feedback">
                                Veuillez sélectionner une catégorie
                            </div>
                        </div>

                        <!-- Prix par défaut -->
                        <div class="col-md-6">
                            <label for="editDefaultPrice" class="form-label fw-bold">
                                Prix par défaut (F CFA) <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" class="form-control modern-input"
                                       id="editDefaultPrice" name="defaultPrice" required
                                       min="0" step="100">
                                <span class="input-group-text">F CFA</span>
                            </div>
                            <div class="invalid-feedback">
                                Veuillez entrer un prix valide
                            </div>
                        </div>

                        <!-- Statut actif -->
                        <div class="col-md-6">
                            <div class="form-check form-switch mt-4">
                                <input class="form-check-input" type="checkbox"
                                       id="editIsActive" name="isActive">
                                <label class="form-check-label fw-bold" for="editIsActive">
                                    <i class="bi bi-toggle-on me-1"></i>Service Actif
                                </label>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="col-12">
                            <label for="editDescription" class="form-label fw-bold">Description</label>
                            <textarea class="form-control modern-input"
                                      id="editDescription" name="description"
                                      rows="3"></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-2"></i>Annuler
                    </button>
                    <button type="submit" class="btn btn-modern btn-gradient-warning" id="submitEditService">
                        <i class="bi bi-check-circle me-2"></i>Mettre à jour
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ============================================= -->
<!-- MODAL : Confirmation suppression -->
<!-- ============================================= -->
<div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-gradient-danger text-white">
                <h5 class="modal-title" id="confirmDeleteModalLabel">
                    <i class="bi bi-exclamation-triangle me-2"></i>Confirmation de suppression
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body text-center">
                <i class="bi bi-trash text-danger display-4 mb-3"></i>
                <h5 class="mb-3">Êtes-vous sûr ?</h5>
                <p class="mb-0" id="deleteConfirmText">
                    Vous allez supprimer le service <strong id="serviceToDeleteName"></strong>.
                    Cette action est irréversible.
                </p>
                <p class="text-danger mt-2">
                    <i class="bi bi-warning me-1"></i>
                    Les reçus utilisant ce service seront affectés.
                </p>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-2"></i>Annuler
                </button>
                <button type="button" class="btn btn-modern btn-gradient-danger" id="confirmDeleteBtn">
                    <i class="bi bi-trash me-2"></i>Supprimer définitivement
                </button>
            </div>
        </div>
    </div>
</div>

<!-- ============================================= -->
<!-- STYLES -->
<!-- ============================================= -->
<style>
    .stat-card {
        border-radius: 15px;
        font-size:1rem;
        word-break: break-word;
        overflow-wrap: break-word;
        padding: 1rem;
        color: white;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        max-height: 120px;
        width: 100%;



    }

    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
    }

    .stat-icon {
        font-size: 100%;
        opacity: 0.3;
    }

    .modern-card {
        border-radius: 15px;
        border: 1px solid #e9ecef;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        transition: box-shadow 0.3s ease;
        background-color: white;
    }

    .modern-card:hover {
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    }

    .modern-input {
        border: 2px solid #e9ecef;
        border-radius: 8px;
        transition: all 0.3s ease;
        padding: 0.75rem 1rem;
    }

    .modern-input:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        outline: none;
    }

    .btn-modern {
        border-radius: 10px;
        font-weight: 600;
        padding: 0.75rem 1.5rem;
        transition: all 0.3s ease;
        border: none;
    }

    .btn-gradient-primary {
        background: var(--primary-gradient);
        color: white;
    }

    .btn-gradient-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        color: white;
    }

    .btn-gradient-warning {
        background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);
        color: #212529;
    }

    .btn-gradient-danger {
        background: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
        color: white;
    }

    .badge-modern {
        padding: 0.5rem 0.75rem;
        border-radius: 8px;
        font-weight: 500;
        font-size: 0.875rem;
    }

    .modern-table {
        border-collapse: separate;
        border-spacing: 0;
        width: 100%;
    }

    .modern-table thead th {
        background-color: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
        padding: 1rem;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.85rem;
        letter-spacing: 0.5px;
        position: sticky;
        top: 0;
        z-index: 10;
    }

    .modern-table tbody tr {
        transition: all 0.3s ease;
    }

    .modern-table tbody tr:hover {
        background-color: #f8f9fa;
    }

    .modern-table td {
        padding: 1rem;
        vertical-align: middle;
        border-bottom: 1px solid #f0f0f0;
    }

    .modal-header {
        border-radius: 15px 15px 0 0;
    }

    .modal-content {
        border-radius: 15px;
        border: none;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
    }

    .btn-group-sm .btn {
        padding: 0.375rem 0.75rem;
        transition: all 0.2s ease;
        border-radius: 6px;
    }

    .btn-group-sm .btn:hover {
        transform: scale(1.05);
    }

    .form-check-input:checked {
        background-color: #667eea;
        border-color: #667eea;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .modal.fade .modal-dialog {
        animation: fadeIn 0.3s ease-out;
    }

    .service-row-hidden {
        display: none;
    }

    .highlight-new {
        animation: highlight 2s ease;
    }

    @keyframes highlight {
        0% { background-color: #e7f4e4; }
        100% { background-color: transparent; }
    }
</style>

<!-- ============================================= -->
<!-- JAVASCRIPT -->
<!-- ============================================= -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Variables globales
        let servicesTable = document.getElementById('servicesTable');
        let currentServiceToDelete = null;

        // =============================================
        // FILTRES ET RECHERCHE
        // =============================================
        function filterServices() {
            const searchTerm = document.getElementById('searchServices').value.toLowerCase();
            const categoryFilter = document.getElementById('filterCategory').value;
            const statusFilter = document.getElementById('filterStatus').value;

            let visibleCount = 0;

            document.querySelectorAll('#servicesTable tbody tr[data-service-id]').forEach(row => {
                const serviceName = row.querySelector('td:nth-child(2) strong').textContent.toLowerCase();
                const serviceCategory = row.dataset.serviceCategory;
                const serviceStatus = row.dataset.serviceStatus;

                let showRow = true;

                // Filtre par recherche
                if (searchTerm && !serviceName.includes(searchTerm)) {
                    showRow = false;
                }

                // Filtre par catégorie
                if (categoryFilter && serviceCategory !== categoryFilter) {
                    showRow = false;
                }

                // Filtre par statut
                if (statusFilter === 'active' && serviceStatus !== 'active') {
                    showRow = false;
                } else if (statusFilter === 'inactive' && serviceStatus !== 'inactive') {
                    showRow = false;
                }

                if (showRow) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            // Mettre à jour le compteur
            document.getElementById('visibleServices').textContent = visibleCount;

            // Gérer l'affichage si aucun résultat
            const emptyRow = document.querySelector('#servicesTable tbody tr:not([data-service-id])');
            if (emptyRow) {
                if (visibleCount === 0 && (searchTerm || categoryFilter || statusFilter)) {
                    emptyRow.style.display = '';
                    emptyRow.innerHTML = `
                    <td colspan="7" class="text-center py-5">
                        <i class="bi bi-search display-1 text-muted d-block mb-3"></i>
                        <h5 class="text-muted">Aucun service ne correspond aux critères</h5>
                        <button type="button" class="btn btn-modern btn-outline-primary mt-3" onclick="resetFilters()">
                            <i class="bi bi-arrow-clockwise me-2"></i>Réinitialiser les filtres
                        </button>
                    </td>
                `;
                } else {
                    emptyRow.style.display = 'none';
                }
            }
        }

        // Événements de filtrage
        document.getElementById('searchServices').addEventListener('input', filterServices);
        document.getElementById('filterCategory').addEventListener('change', filterServices);
        document.getElementById('filterStatus').addEventListener('change', filterServices);

        // Réinitialiser les filtres
        window.resetFilters = function() {
            document.getElementById('searchServices').value = '';
            document.getElementById('filterCategory').value = '';
            document.getElementById('filterStatus').value = '';
            filterServices();
        };

        // =============================================
        // GESTION DU FORMULAIRE D'AJOUT
        // =============================================
        const addServiceForm = document.getElementById('addServiceForm');
        if (addServiceForm) {
            // Validation du code de service
            const serviceCodeInput = document.getElementById('serviceCode');
            serviceCodeInput.addEventListener('blur', function() {
                const code = this.value.trim().toUpperCase();
                this.value = code;

                if (code.length >= 2) {
                    // Vérifier si le code existe déjà
                    fetch('${pageContext.request.contextPath}/medical-receipts/services/check-code?code=' + encodeURIComponent(code))
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Erreur réseau');
                            }
                            return response.json();
                        })
                        .then(data => {
                            if (data.exists) {
                                this.classList.add('is-invalid');
                                document.getElementById('codeFeedback').textContent = 'Ce code existe déjà';
                            } else {
                                this.classList.remove('is-invalid');
                                this.classList.add('is-valid');
                            }
                        })
                        .catch(error => {
                            console.error('Erreur de vérification:', error);
                        });
                }
            });

            // Soumission du formulaire
            addServiceForm.addEventListener('submit', function(e) {
                e.preventDefault();

                // Validation côté client
                if (!this.checkValidity()) {
                    this.classList.add('was-validated');
                    return;
                }

                // Désactiver le bouton pendant l'envoi
                const submitBtn = document.getElementById('submitAddService');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Enregistrement...';
                submitBtn.disabled = true;

                // Envoyer les données
                const formData = new FormData(this);

                fetch(this.action, {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Erreur réseau: ' + response.status);
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            // Afficher message de succès
                            showAlert('Succès', 'Service créé avec succès', 'success');

                            // Fermer le modal
                            const modal = bootstrap.Modal.getInstance(document.getElementById('addServiceModal'));
                            modal.hide();

                            // Réinitialiser le formulaire
                            addServiceForm.reset();
                            addServiceForm.classList.remove('was-validated');

                            // Recharger la page après un délai
                            setTimeout(() => {
                                location.reload();
                            }, 1500);
                        } else {
                            showAlert('Erreur', data.message || 'Erreur lors de la création', 'error');
                            submitBtn.innerHTML = originalText;
                            submitBtn.disabled = false;
                        }
                    })
                    .catch(error => {
                        console.error('Erreur:', error);
                        showAlert('Erreur', 'Une erreur est survenue lors de la création', 'error');
                        submitBtn.innerHTML = originalText;
                        submitBtn.disabled = false;
                    });
            });

            // Réinitialiser le formulaire quand le modal se ferme
            document.getElementById('addServiceModal').addEventListener('hidden.bs.modal', function() {
                addServiceForm.reset();
                addServiceForm.classList.remove('was-validated');
                document.getElementById('serviceCode').classList.remove('is-valid', 'is-invalid');
            });
        }

        // =============================================
        // GESTION DU FORMULAIRE DE MODIFICATION
        // =============================================
        // Événements pour les boutons modifier
        document.querySelectorAll('.btn-edit-service').forEach(button => {
            button.addEventListener('click', function() {
                const serviceId = this.dataset.serviceId;
                const serviceCode = this.dataset.serviceCode;
                const serviceName = this.dataset.serviceName;
                const serviceCategory = this.dataset.serviceCategory;
                const defaultPrice = this.dataset.defaultPrice;
                const isActive = this.dataset.isActive === 'true';
                const description = this.dataset.description || '';

                // Remplir le formulaire d'édition
                document.getElementById('editServiceId').value = serviceId;
                document.getElementById('editServiceCode').value = serviceCode;
                document.getElementById('editServiceName').value = serviceName;
                document.getElementById('editServiceCategory').value = serviceCategory;
                document.getElementById('editDefaultPrice').value = defaultPrice;
                document.getElementById('editIsActive').checked = isActive;
                document.getElementById('editDescription').value = description;

                // Afficher le modal
                const editModal = new bootstrap.Modal(document.getElementById('editServiceModal'));
                editModal.show();
            });
        });

        // Soumission du formulaire de modification
        const editServiceForm = document.getElementById('editServiceForm');
        if (editServiceForm) {
            editServiceForm.addEventListener('submit', function(e) {
                e.preventDefault();

                // Validation
                if (!this.checkValidity()) {
                    this.classList.add('was-validated');
                    return;
                }

                // Désactiver le bouton
                const submitBtn = document.getElementById('submitEditService');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Mise à jour...';
                submitBtn.disabled = true;

                // Envoyer les données
                const formData = new FormData(this);

                fetch(this.action, {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showAlert('Succès', 'Service mis à jour avec succès', 'success');

                            // Fermer le modal
                            const modal = bootstrap.Modal.getInstance(document.getElementById('editServiceModal'));
                            modal.hide();

                            // Recharger la page
                            setTimeout(() => {
                                location.reload();
                            }, 1500);
                        } else {
                            showAlert('Erreur', data.message || 'Erreur lors de la mise à jour', 'error');
                            submitBtn.innerHTML = originalText;
                            submitBtn.disabled = false;
                        }
                    })
                    .catch(error => {
                        console.error('Erreur:', error);
                        showAlert('Erreur', 'Une erreur est survenue', 'error');
                        submitBtn.innerHTML = originalText;
                        submitBtn.disabled = false;
                    });
            });
        }

        // =============================================
        // ACTIVATION/DÉSACTIVATION DES SERVICES
        // =============================================
        document.querySelectorAll('.btn-toggle-service').forEach(button => {
            button.addEventListener('click', function() {
                const serviceId = this.dataset.serviceId;
                const action = this.dataset.action;
                const serviceName = this.closest('tr').querySelector('td:nth-child(2) strong').textContent;

                const actionText = action === 'activate' ? 'activer' : 'désactiver';
                const actionTitle = action === 'activate' ? 'Activation' : 'Désactivation';

                if (confirm(`Voulez-vous vraiment ${actionText} le service "${serviceName}" ?`)) {
                    // Afficher un indicateur de chargement
                    const originalHTML = this.innerHTML;
                    this.innerHTML = '<span class="spinner-border spinner-border-sm"></span>';
                    this.disabled = true;

                    fetch('${pageContext.request.contextPath}/medical-receipts/services/toggle', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        body: `id=${serviceId}&action=${action}`
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                showAlert('Succès', `Service ${actionText} avec succès`, 'success');
                                setTimeout(() => {
                                    location.reload();
                                }, 1500);
                            } else {
                                showAlert('Erreur', data.message || 'Erreur lors de l\'opération', 'error');
                                this.innerHTML = originalHTML;
                                this.disabled = false;
                            }
                        })
                        .catch(error => {
                            console.error('Erreur:', error);
                            showAlert('Erreur', 'Une erreur est survenue', 'error');
                            this.innerHTML = originalHTML;
                            this.disabled = false;
                        });
                }
            });
        });

        // =============================================
        // SUPPRESSION DES SERVICES
        // =============================================
        document.querySelectorAll('.btn-delete-service').forEach(button => {
            button.addEventListener('click', function() {
                currentServiceToDelete = {
                    id: this.dataset.serviceId,
                    name: this.dataset.serviceName
                };

                // Afficher le nom dans le modal de confirmation
                document.getElementById('serviceToDeleteName').textContent = currentServiceToDelete.name;

                // Afficher le modal
                const deleteModal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
                deleteModal.show();
            });
        });

        // Confirmation de suppression
        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            if (!currentServiceToDelete) return;

            // Désactiver le bouton
            this.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Suppression...';
            this.disabled = true;

            fetch('${pageContext.request.contextPath}/medical-receipts/services/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: `id=${currentServiceToDelete.id}`
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showAlert('Succès', 'Service supprimé avec succès', 'success');

                        // Fermer le modal
                        const modal = bootstrap.Modal.getInstance(document.getElementById('confirmDeleteModal'));
                        modal.hide();

                        // Recharger la page
                        setTimeout(() => {
                            location.reload();
                        }, 1500);
                    } else {
                        showAlert('Erreur', data.message || 'Erreur lors de la suppression', 'error');
                        this.innerHTML = '<i class="bi bi-trash me-2"></i>Supprimer définitivement';
                        this.disabled = false;
                    }
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    showAlert('Erreur', 'Une erreur est survenue', 'error');
                    this.innerHTML = '<i class="bi bi-trash me-2"></i>Supprimer définitivement';
                    this.disabled = false;
                });
        });

        // Réinitialiser quand le modal de suppression se ferme
        document.getElementById('confirmDeleteModal').addEventListener('hidden.bs.modal', function() {
            const btn = document.getElementById('confirmDeleteBtn');
            btn.innerHTML = '<i class="bi bi-trash me-2"></i>Supprimer définitivement';
            btn.disabled = false;
            currentServiceToDelete = null;
        });

        // =============================================
        // FONCTIONS UTILITAIRES
        // =============================================
        function showAlert(title, message, type) {
            // Supprimer les anciennes alertes
            document.querySelectorAll('.alert-dismissible').forEach(alert => {
                const bsAlert = bootstrap.Alert.getInstance(alert);
                if (bsAlert) {
                    bsAlert.close();
                } else {
                    alert.remove();
                }
            });

            const alertClass = type === 'success' ? 'alert-success' :
                type === 'warning' ? 'alert-warning' : 'alert-danger';

            const alertDiv = document.createElement('div');
            alertDiv.className = `alert ${alertClass} alert-dismissible fade show modern-card`;
            alertDiv.innerHTML = `
            <div class="d-flex align-items-center">
                <i class="bi ${type eq 'success' ? 'bi-check-circle-fill' :
                               type eq 'warning' ? 'bi-exclamation-triangle-fill' :
                               'bi-exclamation-triangle-fill'} fs-4 me-3"></i>
                <div>
                    <h5 class="alert-heading mb-1">${title}</h5>
                    <p class="mb-0">${message}</p>
                </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

            const container = document.querySelector('.container-fluid');
            if (container) {
                container.insertBefore(alertDiv, container.firstChild);

                // Fermer automatiquement après 5 secondes
                setTimeout(() => {
                    if (alertDiv.parentNode) {
                        const bsAlert = bootstrap.Alert.getInstance(alertDiv);
                        if (bsAlert) {
                            bsAlert.close();
                        }
                    }
                }, 5000);
            }
        }

        // Initialiser les tooltips Bootstrap
        const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        tooltipTriggerList.forEach(tooltipTriggerEl => {
            new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Initialiser les filtres
        filterServices();
    });
</script>