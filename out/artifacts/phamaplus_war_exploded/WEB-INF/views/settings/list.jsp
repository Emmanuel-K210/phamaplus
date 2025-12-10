<%-- /WEB-INF/views/settings/list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="fr_FR"/>
<fmt:setBundle basename="messages"/>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-gear-fill text-primary me-2"></i>Paramètres de l'Application
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-sliders me-1"></i>
                        Configurez les paramètres système de PharmaPlus
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary" onclick="window.location.reload()">
                        <i class="bi bi-arrow-clockwise me-2"></i>Actualiser
                    </button>
                    <button type="submit" form="settingsForm" class="btn btn-primary">
                        <i class="bi bi-save me-2"></i>Sauvegarder
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Messages de feedback -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
                ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Statistiques rapides -->
    <div class="row mb-4">
        <div class="col-md-3 col-sm-6 mb-3">
            <div class="card border-primary">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <i class="bi bi-gear text-primary fs-1"></i>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h5 class="card-title mb-0">${parameters.size()}</h5>
                            <p class="text-muted mb-0">Paramètres</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 col-sm-6 mb-3">
            <div class="card border-success">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <i class="bi bi-check-circle text-success fs-1"></i>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h5 class="card-title mb-0">
                                <c:set var="configuredCount" value="0"/>
                                <c:forEach var="param" items="${parameters}">
                                    <c:if test="${not empty param.parameterValue}">
                                        <c:set var="configuredCount" value="${configuredCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${configuredCount}
                            </h5>
                            <p class="text-muted mb-0">Configurés</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 col-sm-6 mb-3">
            <div class="card border-warning">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <i class="bi bi-exclamation-circle text-warning fs-1"></i>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h5 class="card-title mb-0">${parameters.size() - configuredCount}</h5>
                            <p class="text-muted mb-0">À configurer</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3 col-sm-6 mb-3">
            <div class="card border-info">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <i class="bi bi-clock-history text-info fs-1"></i>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h5 class="card-title mb-0">
                                <fmt:formatDate value="${now}" pattern="HH:mm"/>
                            </h5>
                            <p class="text-muted mb-0">Dernière vue</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Navigation par catégorie -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/settings"
                           class="btn ${empty param.category ? 'btn-primary' : 'btn-outline-primary'}">
                            <i class="bi bi-grid me-1"></i>Tous
                        </a>

                        <c:forEach var="category" items="${categories}">
                            <a href="${pageContext.request.contextPath}/settings?category=${category}"
                               class="btn ${param.category == category ? 'btn-primary' : 'btn-outline-primary'}">
                                <c:choose>
                                    <c:when test="${category == 'GENERAL'}">
                                        <i class="bi bi-building me-1"></i>Général
                                    </c:when>
                                    <c:when test="${category == 'UI'}">
                                        <i class="bi bi-display me-1"></i>Interface
                                    </c:when>
                                    <c:when test="${category == 'SECURITY'}">
                                        <i class="bi bi-shield-lock me-1"></i>Sécurité
                                    </c:when>
                                    <c:when test="${category == 'FINANCIAL'}">
                                        <i class="bi bi-currency-exchange me-1"></i>Financier
                                    </c:when>
                                    <c:when test="${category == 'NOTIFICATION'}">
                                        <i class="bi bi-bell me-1"></i>Notifications
                                    </c:when>
                                    <c:when test="${category == 'FEATURE'}">
                                        <i class="bi bi-toggle-on me-1"></i>Fonctionnalités
                                    </c:when>
                                    <c:when test="${category == 'BUSINESS'}">
                                        <i class="bi bi-briefcase me-1"></i>Métier
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-gear me-1"></i>${category}
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Formulaire principal -->
    <div class="row">
        <div class="col-12">
            <form id="settingsForm" method="post" action="${pageContext.request.contextPath}/settings/save">
                <input type="hidden" name="category" value="${param.category}">

                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">
                            <i class="bi bi-list-check me-2"></i>
                            Liste des paramètres
                            <c:if test="${not empty param.category}">
                                - Catégorie: ${param.category}
                            </c:if>
                        </h5>
                    </div>

                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th width="25%">Paramètre</th>
                                    <th width="10%">Type</th>
                                    <th width="15%">Catégorie</th>
                                    <th width="40%">Valeur</th>
                                    <th width="10%">Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="param" items="${parameters}">
                                    <c:if test="${empty param.category or param.category == param.category}">
                                        <tr>
                                            <td>
                                                <div>
                                                    <strong class="d-block">${param.parameterKey}</strong>
                                                    <c:if test="${not empty param.description}">
                                                        <small class="text-muted">${param.description}</small>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                    <span class="badge
                                                        ${param.parameterType == 'STRING' ? 'bg-info' :
                                                          param.parameterType == 'INTEGER' ? 'bg-primary' :
                                                          param.parameterType == 'BOOLEAN' ? 'bg-success' :
                                                          param.parameterType == 'DECIMAL' ? 'bg-warning' : 'bg-secondary'}">
                                                            ${param.parameterType}
                                                    </span>
                                            </td>
                                            <td>
                                                    <span class="badge bg-light text-dark">
                                                            ${param.category}
                                                    </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${param.parameterType == 'BOOLEAN'}">
                                                        <div class="form-check form-switch">
                                                            <input type="checkbox"
                                                                   class="form-check-input"
                                                                   name="${param.parameterKey}"
                                                                   value="true"
                                                                   id="switch_${param.parameterKey}"
                                                                ${param.parameterValue == 'true' ? 'checked' : ''}>
                                                            <label class="form-check-label ms-2" for="switch_${param.parameterKey}">
                                                                    ${param.parameterValue == 'true' ? 'Activé' : 'Désactivé'}
                                                            </label>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${param.parameterType == 'INTEGER'}">
                                                        <input type="number"
                                                               class="form-control"
                                                               name="${param.parameterKey}"
                                                               value="${param.parameterValue}"
                                                               step="1">
                                                    </c:when>

                                                    <c:when test="${param.parameterType == 'DECIMAL'}">
                                                        <input type="number"
                                                               class="form-control"
                                                               name="${param.parameterKey}"
                                                               value="${param.parameterValue}"
                                                               step="0.01">
                                                    </c:when>

                                                    <c:when test="${param.parameterKey == 'ui.theme'}">
                                                        <select class="form-select" name="${param.parameterKey}">
                                                            <option value="light" ${param.parameterValue == 'light' ? 'selected' : ''}>
                                                                <i class="bi bi-sun"></i> Mode clair
                                                            </option>
                                                            <option value="dark" ${param.parameterValue == 'dark' ? 'selected' : ''}>
                                                                <i class="bi bi-moon"></i> Mode sombre
                                                            </option>
                                                            <option value="auto" ${param.parameterValue == 'auto' ? 'selected' : ''}>
                                                                <i class="bi bi-circle-half"></i> Auto
                                                            </option>
                                                        </select>
                                                    </c:when>

                                                    <c:when test="${param.parameterKey == 'ui.language'}">
                                                        <select class="form-select" name="${param.parameterKey}">
                                                            <option value="fr" ${param.parameterValue == 'fr' ? 'selected' : ''}>
                                                                🇫🇷 Français
                                                            </option>
                                                            <option value="en" ${param.parameterValue == 'en' ? 'selected' : ''}>
                                                                🇬🇧 English
                                                            </option>
                                                            <option value="mg" ${param.parameterValue == 'mg' ? 'selected' : ''}>
                                                                🇲🇬 Malagasy
                                                            </option>
                                                        </select>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <input type="text"
                                                               class="form-control"
                                                               name="${param.parameterKey}"
                                                               value="${param.parameterValue}">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <button type="button"
                                                            class="btn btn-outline-warning"
                                                            onclick="resetParameter('${param.parameterKey}')"
                                                            title="Réinitialiser">
                                                        <i class="bi bi-arrow-counterclockwise"></i>
                                                    </button>
                                                    <button type="button"
                                                            class="btn btn-outline-info"
                                                            onclick="showInfo('${param.parameterKey}', '${param.parameterType}', '${param.category}')"
                                                            title="Information">
                                                        <i class="bi bi-info-circle"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Actions du formulaire -->
                    <div class="card-footer">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex gap-2">
                                <button type="reset" class="btn btn-outline-secondary">
                                    <i class="bi bi-x-circle me-2"></i>Annuler les modifications
                                </button>
                                <button type="button" class="btn btn-outline-warning"
                                        onclick="showResetConfirmation()">
                                    <i class="bi bi-arrow-counterclockwise me-2"></i>Tout réinitialiser
                                </button>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-outline-success"
                                        onclick="exportSettings()">
                                    <i class="bi bi-download me-2"></i>Exporter
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-save me-2"></i>Sauvegarder les modifications
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Informations supplémentaires -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="alert alert-info">
                <div class="d-flex">
                    <div class="flex-shrink-0">
                        <i class="bi bi-info-circle-fill fs-4"></i>
                    </div>
                    <div class="flex-grow-1 ms-3">
                        <h5 class="alert-heading">Information</h5>
                        <p class="mb-0">
                            Certains paramètres nécessitent un redémarrage de l'application pour prendre effet.
                            Les modifications sont automatiquement sauvegardées dans la base de données.
                        </p>
                        <hr>
                        <small class="text-muted">
                            <i class="bi bi-clock me-1"></i>
                            Dernière mise à jour:
                            <span id="currentTime">
                                <jsp:useBean id="now" class="java.util.Date"/>
                                <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </span>
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal de confirmation pour réinitialisation -->
<div class="modal fade" id="resetConfirmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-exclamation-triangle text-warning me-2"></i>
                    Confirmation de réinitialisation
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir réinitialiser tous les paramètres aux valeurs par défaut ?</p>
                <p class="text-danger">
                    <i class="bi bi-exclamation-circle me-1"></i>
                    Cette action est irréversible et affectera le comportement de l'application.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-warning" onclick="confirmResetAll()">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>Réinitialiser
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal d'information paramètre -->
<div class="modal fade" id="infoModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="infoModalTitle">
                    <i class="bi bi-info-circle text-info me-2"></i>
                    Information du paramètre
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <strong>Clé :</strong>
                    <code id="infoKey" class="ms-2"></code>
                </div>
                <div class="mb-3">
                    <strong>Type :</strong>
                    <span id="infoType" class="badge ms-2"></span>
                </div>
                <div class="mb-3">
                    <strong>Catégorie :</strong>
                    <span id="infoCategory" class="badge bg-light text-dark ms-2"></span>
                </div>
                <div class="mb-3">
                    <strong>Valeur actuelle :</strong>
                    <code id="infoValue" class="ms-2"></code>
                </div>
                <div>
                    <strong>Description :</strong>
                    <p id="infoDescription" class="mt-2 text-muted mb-0"></p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Initialisation
    document.addEventListener('DOMContentLoaded', function() {
        // Mettre à jour l'heure en temps réel
        updateCurrentTime();
        setInterval(updateCurrentTime, 1000);

        // Marquer les champs modifiés
        document.querySelectorAll('input, select').forEach(function(input) {
            const originalValue = input.value;

            input.addEventListener('change', function() {
                if (this.value !== originalValue) {
                    this.closest('tr').classList.add('table-warning');
                } else {
                    this.closest('tr').classList.remove('table-warning');
                }
            });
        });

        // Validation du formulaire
        document.getElementById('settingsForm').addEventListener('submit', function(e) {
            let isValid = true;
            const errors = [];

            // Validation des nombres
            document.querySelectorAll('input[type="number"]').forEach(function(input) {
                const value = parseFloat(input.value);
                if (isNaN(value)) {
                    isValid = false;
                    input.classList.add('is-invalid');
                    errors.push(`"${input.name}" doit être un nombre`);
                } else {
                    input.classList.remove('is-invalid');
                }
            });

            if (!isValid) {
                e.preventDefault();
                showAlert('Veuillez corriger les erreurs :<br>' + errors.join('<br>'), 'danger');
            } else {
                showAlert('Sauvegarde en cours...', 'info');
            }
        });
    });

    // Mettre à jour l'heure affichée
    function updateCurrentTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('fr-FR', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
        const dateString = now.toLocaleDateString('fr-FR');
        document.getElementById('currentTime').textContent = dateString + ' ' + timeString;
    }

    // Réinitialiser un paramètre spécifique
    function resetParameter(paramKey) {
        if (confirm(`Réinitialiser le paramètre "${paramKey}" à sa valeur par défaut ?`)) {
            const input = document.querySelector(`[name="${paramKey}"]`);
            if (!input) return;

            // Valeurs par défaut selon le type
            const defaultValue = getDefaultValue(paramKey, input.type);

            if (input.type === 'checkbox') {
                input.checked = defaultValue === 'true';
                input.dispatchEvent(new Event('change'));
            } else {
                input.value = defaultValue;
                input.dispatchEvent(new Event('change'));
            }

            showAlert(`Paramètre "${paramKey}" réinitialisé`, 'success');
        }
    }

    // Obtenir la valeur par défaut d'un paramètre
    function getDefaultValue(paramKey, inputType) {
        const defaults = {
            // Général
            'app.name': 'PharmaPlus',
            'app.version': '1.0.0',
            'company.name': 'OneMaster Pharma',
            'company.address': '',
            'company.phone': '',
            'company.email': '',

            // UI
            'ui.theme': 'light',
            'ui.language': 'fr',
            'ui.date_format': 'dd/MM/yyyy',
            'ui.time_format': 'HH:mm',
            'pagination.items_per_page': '20',

            // Financier
            'financial.default_currency': 'MGA',
            'financial.vat_rate': '0.2',

            // Sécurité
            'security.session_timeout': '30',
            'security.password_min_length': '8',
            'security.login_attempts': '3',

            // Notifications
            'notification.stock_alert': 'true',
            'notification.expiry_alert_days': '30',
            'notification.email.enabled': 'false',

            // Fonctionnalités
            'feature.auto_save': 'true',
            'feature.export_enabled': 'true',

            // Métier
            'business.working_hours_start': '08:00',
            'business.working_hours_end': '18:00',
            'business.default_payment_method': 'CASH'
        };

        const value = defaults[paramKey] || '';

        // Pour les cases à cocher
        if (inputType === 'checkbox') {
            return value === 'true' ? 'true' : 'false';
        }

        return value;
    }

    // Afficher les informations d'un paramètre
    function showInfo(paramKey, paramType, paramCategory) {
        const input = document.querySelector(`[name="${paramKey}"]`);
        if (!input) return;

        const value = input.type === 'checkbox' ? (input.checked ? 'true' : 'false') : input.value;

        document.getElementById('infoKey').textContent = paramKey;
        document.getElementById('infoType').textContent = paramType;
        document.getElementById('infoCategory').textContent = paramCategory;
        document.getElementById('infoValue').textContent = value;

        // Trouver la description (du petit texte sous le paramètre)
        const row = input.closest('tr');
        const description = row.querySelector('small.text-muted');
        document.getElementById('infoDescription').textContent =
            description ? description.textContent : 'Aucune description disponible';

        // Définir la couleur du badge selon le type
        const typeBadge = document.getElementById('infoType');
        typeBadge.className = 'badge ' +
            (paramType === 'STRING' ? 'bg-info' :
                paramType === 'INTEGER' ? 'bg-primary' :
                    paramType === 'BOOLEAN' ? 'bg-success' :
                        paramType === 'DECIMAL' ? 'bg-warning' : 'bg-secondary');

        const modal = new bootstrap.Modal(document.getElementById('infoModal'));
        modal.show();
    }

    // Afficher la confirmation de réinitialisation
    function showResetConfirmation() {
        const modal = new bootstrap.Modal(document.getElementById('resetConfirmModal'));
        modal.show();
    }

    // Confirmer la réinitialisation totale
    function confirmResetAll() {
        fetch('${pageContext.request.contextPath}/settings/reset', {
            method: 'POST'
        })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    showAlert('Erreur lors de la réinitialisation', 'danger');
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                showAlert('Erreur lors de la réinitialisation', 'danger');
            });
    }

    // Exporter les paramètres
    function exportSettings() {
        const form = document.getElementById('settingsForm');
        const formData = new FormData(form);
        const params = {};

        formData.forEach((value, key) => {
            params[key] = value;
        });

        const json = JSON.stringify(params, null, 2);
        const blob = new Blob([json], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');

        a.href = url;
        const today = new Date();
        const dateString = today.toISOString().split('T')[0];
        a.download = 'pharmaplus-settings-' + dateString + '.json';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);

        showAlert('Paramètres exportés avec succès', 'success');
    }

    // Afficher une alerte
    function showAlert(message, type) {
        // Créer l'alerte
        const alertId = 'alert-' + Date.now();
        const alertHtml = `
            <div id="${alertId}" class="alert alert-${type} alert-dismissible fade show position-fixed top-0 end-0 m-3"
                 style="z-index: 9999; max-width: 400px;" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;

        // Ajouter au document
        document.body.insertAdjacentHTML('beforeend', alertHtml);

        // Supprimer automatiquement après 5 secondes
        setTimeout(() => {
            const alertElement = document.getElementById(alertId);
            if (alertElement) {
                alertElement.remove();
            }
        }, 5000);
    }

    // Importer des paramètres
    function importSettings() {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = '.json';

        input.onchange = function(e) {
            const file = e.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = function(event) {
                try {
                    const settings = JSON.parse(event.target.result);

                    // Appliquer les paramètres
                    Object.keys(settings).forEach(key => {
                        const input = document.querySelector(`[name="${key}"]`);
                        if (input) {
                            if (input.type === 'checkbox') {
                                input.checked = settings[key] === 'true' || settings[key] === true;
                            } else {
                                input.value = settings[key];
                            }
                            input.dispatchEvent(new Event('change'));
                        }
                    });

                    showAlert('Paramètres importés avec succès', 'success');

                    // Soumettre le formulaire après 2 secondes
                    setTimeout(() => {
                        document.getElementById('settingsForm').submit();
                    }, 2000);

                } catch (error) {
                    showAlert('Erreur lors de l\'import: ' + error.message, 'danger');
                }
            };

            reader.readAsText(file);
        };

        input.click();
    }
</script>

<style>
    /* Styles personnalisés */
    .table-hover tbody tr:hover {
        background-color: rgba(0, 123, 255, 0.05);
    }

    .table-warning {
        background-color: rgba(255, 193, 7, 0.1) !important;
    }

    .form-check-input:checked {
        background-color: #0d6efd;
        border-color: #0d6efd;
    }

    .form-check-input:focus {
        border-color: #86b7fe;
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
    }

    .form-control:focus, .form-select:focus {
        border-color: #86b7fe;
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
    }

    /* Animation pour les modifications */
    @keyframes highlight {
        0% { background-color: rgba(255, 193, 7, 0.3); }
        100% { background-color: transparent; }
    }

    tr.modified {
        animation: highlight 2s ease-out;
    }

    /* Badges */
    .badge {
        font-size: 0.85em;
        padding: 0.35em 0.65em;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.9rem;
        }

        .btn-group-sm .btn {
            padding: 0.25rem 0.5rem;
        }

        .card-title {
            font-size: 1.1rem;
        }
    }
</style>