<%-- /WEB-INF/views/settings/list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-gear text-primary me-2"></i>Paramètres de l'Application
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-sliders me-1"></i>
                        Configurez les paramètres système
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-modern btn-gradient-secondary"
                            onclick="resetAllSettings()">
                        <i class="bi bi-arrow-counterclockwise me-2"></i>Réinitialiser
                    </button>
                    <button type="submit" form="settingsForm" class="btn btn-modern btn-gradient-primary">
                        <i class="bi bi-save me-2"></i>Sauvegarder
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show modern-card mb-4">
            <i class="bi bi-check-circle-fill me-2"></i>${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show modern-card mb-4">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Navigation par catégorie -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="modern-card">
                <div class="d-flex flex-wrap gap-2 p-3">
                    <a href="${pageContext.request.contextPath}/settings"
                       class="btn btn-modern ${empty param.category ? 'btn-gradient-primary' : 'btn-outline-primary'}">
                        <i class="bi bi-grid me-1"></i>Tous
                    </a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/settings/${cat.toLowerCase()}"
                           class="btn btn-modern ${param.category == cat ? 'btn-gradient-primary' : 'btn-outline-primary'}">
                            <c:choose>
                                <c:when test="${cat == 'GENERAL'}"><i class="bi bi-building me-1"></i>Général</c:when>
                                <c:when test="${cat == 'UI'}"><i class="bi bi-display me-1"></i>Interface</c:when>
                                <c:when test="${cat == 'SECURITY'}"><i class="bi bi-shield-lock me-1"></i>Sécurité</c:when>
                                <c:when test="${cat == 'FINANCIAL'}"><i class="bi bi-currency-exchange me-1"></i>Financier</c:when>
                                <c:when test="${cat == 'NOTIFICATION'}"><i class="bi bi-bell me-1"></i>Notifications</c:when>
                                <c:when test="${cat == 'FEATURE'}"><i class="bi bi-toggle-on me-1"></i>Fonctionnalités</c:when>
                                <c:when test="${cat == 'BUSINESS'}"><i class="bi bi-briefcase me-1"></i>Métier</c:when>
                                <c:otherwise><i class="bi bi-gear me-1"></i>${cat}</c:otherwise>
                            </c:choose>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Formulaire des paramètres -->
    <div class="row">
        <div class="col-12">
            <form id="settingsForm" method="post" action="${pageContext.request.contextPath}/settings/save">
                <div class="modern-card">
                    <div class="table-responsive">
                        <table class="table modern-table mb-0">
                            <thead>
                            <tr>
                                <th width="25%">Paramètre</th>
                                <th width="10%">Type</th>
                                <th width="15%">Catégorie</th>
                                <th width="40%">Valeur</th>
                                <th width="10%">Valeur par défaut</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="param" items="${parameters}">
                                <tr>
                                    <td>
                                        <div>
                                            <strong>${param.parameterKey}</strong>
                                            <c:if test="${not empty param.description}">
                                                <br>
                                                <small class="text-muted">${param.description}</small>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge badge-modern
                                            ${param.parameterType == 'STRING' ? 'bg-info' :
                                              param.parameterType == 'INTEGER' ? 'bg-primary' :
                                              param.parameterType == 'BOOLEAN' ? 'bg-success' :
                                              param.parameterType == 'DECIMAL' ? 'bg-warning' : 'bg-secondary'}">
                                                ${param.parameterType}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge badge-modern bg-light text-dark">
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
                                                        ${param.parameterValue == 'true' ? 'checked' : ''}
                                                           style="transform: scale(1.2);">
                                                    <label class="form-check-label ms-2">
                                                            ${param.parameterValue == 'true' ? 'Activé' : 'Désactivé'}
                                                    </label>
                                                </div>
                                            </c:when>
                                            <c:when test="${param.parameterType == 'INTEGER'}">
                                                <input type="number"
                                                       class="form-control modern-input"
                                                       name="${param.parameterKey}"
                                                       value="${param.parameterValue}"
                                                       step="1">
                                            </c:when>
                                            <c:when test="${param.parameterType == 'DECIMAL'}">
                                                <input type="number"
                                                       class="form-control modern-input"
                                                       name="${param.parameterKey}"
                                                       value="${param.parameterValue}"
                                                       step="0.01">
                                            </c:when>
                                            <c:when test="${param.parameterKey == 'ui.theme'}">
                                                <select class="form-select modern-input"
                                                        name="${param.parameterKey}">
                                                    <option value="light" ${param.parameterValue == 'light' ? 'selected' : ''}>Clair</option>
                                                    <option value="dark" ${param.parameterValue == 'dark' ? 'selected' : ''}>Sombre</option>
                                                    <option value="auto" ${param.parameterValue == 'auto' ? 'selected' : ''}>Auto</option>
                                                </select>
                                            </c:when>
                                            <c:when test="${param.parameterKey == 'ui.language'}">
                                                <select class="form-select modern-input"
                                                        name="${param.parameterKey}">
                                                    <option value="fr" ${param.parameterValue == 'fr' ? 'selected' : ''}>Français</option>
                                                    <option value="en" ${param.parameterValue == 'en' ? 'selected' : ''}>English</option>
                                                    <option value="mg" ${param.parameterValue == 'mg' ? 'selected' : ''}>Malagasy</option>
                                                </select>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="text"
                                                       class="form-control modern-input"
                                                       name="${param.parameterKey}"
                                                       value="${param.parameterValue}">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <button type="button"
                                                class="btn btn-sm btn-outline-warning"
                                                onclick="resetParameter('${param.parameterKey}', '${param.parameterType}')"
                                                title="Réinitialiser">
                                            <i class="bi bi-arrow-counterclockwise"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Actions -->
                    <div class="p-4 border-top">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-modern btn-gradient-secondary"
                                        onclick="exportSettings()">
                                    <i class="bi bi-download me-2"></i>Exporter les paramètres
                                </button>
                                <button type="button" class="btn btn-modern btn-gradient-warning"
                                        onclick="importSettings()">
                                    <i class="bi bi-upload me-2"></i>Importer des paramètres
                                </button>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="reset" class="btn btn-modern btn-outline-secondary">
                                    <i class="bi bi-x-circle me-2"></i>Annuler les modifications
                                </button>
                                <button type="submit" class="btn btn-modern btn-gradient-primary">
                                    <i class="bi bi-save me-2"></i>Sauvegarder tous les paramètres
                                </button>
                            </div>
                        </div>

                        <!-- Import/Export Section (cachée par défaut) -->
                        <div id="importExportSection" class="mt-4" style="display: none;">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="modern-card p-3">
                                        <h6 class="mb-3">
                                            <i class="bi bi-download me-2"></i>Exporter les paramètres
                                        </h6>
                                        <p class="text-muted small mb-3">
                                            Téléchargez tous les paramètres actuels dans un fichier JSON.
                                        </p>
                                        <div class="d-flex gap-2">
                                            <button type="button" class="btn btn-sm btn-outline-primary"
                                                    onclick="exportSettingsJSON()">
                                                <i class="bi bi-filetype-json me-1"></i>Exporter en JSON
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-success"
                                                    onclick="exportSettingsCSV()">
                                                <i class="bi bi-filetype-csv me-1"></i>Exporter en CSV
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="modern-card p-3">
                                        <h6 class="mb-3">
                                            <i class="bi bi-upload me-2"></i>Importer des paramètres
                                        </h6>
                                        <p class="text-muted small mb-3">
                                            Importez des paramètres depuis un fichier JSON.
                                        </p>
                                        <div class="mb-3">
                                            <input type="file" id="settingsFile" class="form-control"
                                                   accept=".json,.csv">
                                        </div>
                                        <div class="d-flex gap-2">
                                            <button type="button" class="btn btn-sm btn-outline-warning"
                                                    onclick="importSettingsFile()">
                                                <i class="bi bi-upload me-1"></i>Importer le fichier
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-info"
                                                    onclick="showSampleSettings()">
                                                <i class="bi bi-eye me-1"></i>Voir un exemple
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Informations -->
                        <div class="mt-4 pt-3 border-top">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-info-circle text-primary me-2"></i>
                                        <div>
                                            <small class="text-muted">
                                                <strong>Note :</strong> Certains paramètres nécessitent un redémarrage
                                                de l'application pour prendre effet.
                                            </small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 text-end">
                                    <small class="text-muted">
                                        <i class="bi bi-clock me-1"></i>
                                        Dernière mise à jour :
                                        <span id="lastUpdateTime">
                                            <jsp:useBean id="now" class="java.util.Date"/>
                                            <fmt:formatDate value="${now}" pattern="HH:mm:ss"/>
                                        </span>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal d'avertissement pour la réinitialisation -->
<div class="modal fade" id="resetConfirmModal" tabindex="-1" aria-hidden="true">
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
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="includeAdvanced">
                    <label class="form-check-label" for="includeAdvanced">
                        Inclure les paramètres avancés
                    </label>
                </div>
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

<!-- Modal d'aperçu JSON -->
<div class="modal fade" id="jsonPreviewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-filetype-json text-info me-2"></i>
                    Aperçu des paramètres
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <pre id="jsonPreview" class="p-3 bg-light rounded" style="max-height: 400px; overflow-y: auto;"></pre>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                <button type="button" class="btn btn-primary" onclick="copyToClipboard()">
                    <i class="bi bi-clipboard me-1"></i>Copier
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal d'import -->
<div class="modal fade" id="importModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-cloud-upload text-success me-2"></i>
                    Importation des paramètres
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="importProgress" class="mb-3" style="display: none;">
                    <div class="progress" style="height: 20px;">
                        <div id="importProgressBar" class="progress-bar progress-bar-striped progress-bar-animated"
                             role="progressbar" style="width: 0%"></div>
                    </div>
                    <small id="importStatus" class="text-muted mt-1 d-block"></small>
                </div>
                <div id="importForm">
                    <p class="text-muted mb-3">
                        Sélectionnez un fichier JSON contenant les paramètres à importer.
                    </p>
                    <div class="mb-3">
                        <label class="form-label">Fichier de paramètres</label>
                        <input type="file" class="form-control" id="importFile" accept=".json">
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="overwriteExisting">
                        <label class="form-check-label" for="overwriteExisting">
                            Écraser les paramètres existants
                        </label>
                    </div>
                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        <small>
                            L'importation modifie immédiatement les paramètres. Assurez-vous que le fichier
                            provient d'une source fiable.
                        </small>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-success" onclick="startImport()">
                    <i class="bi bi-upload me-1"></i>Importer
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Initialiser les tooltips Bootstrap
    document.addEventListener('DOMContentLoaded', function() {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Mettre à jour l'heure
        updateTime();
        setInterval(updateTime, 60000); // Mise à jour toutes les minutes
    });

    // Mettre à jour l'heure d'affichage
    function updateTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString('fr-FR', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
        document.getElementById('lastUpdateTime').textContent = timeString;
    }

    // Réinitialiser tous les paramètres
    function resetAllSettings() {
        const modal = new bootstrap.Modal(document.getElementById('resetConfirmModal'));
        modal.show();
    }

    // Confirmer la réinitialisation
    function confirmResetAll() {
        const includeAdvanced = document.getElementById('includeAdvanced').checked;
        const url = '${pageContext.request.contextPath}/settings/reset' +
            (includeAdvanced ? '?advanced=true' : '');

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert('Erreur lors de la réinitialisation');
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                alert('Erreur lors de la réinitialisation');
            });
    }

    // Réinitialiser un paramètre spécifique
    function resetParameter(paramKey, paramType) {
        if (confirm(`Réinitialiser le paramètre "${paramKey}" à sa valeur par défaut ?`)) {
            // Trouver l'élément d'entrée
            const input = document.querySelector(`[name="${paramKey}"]`);
            if (!input) return;

            // Définir la valeur par défaut selon le type
            let defaultValue;
            switch(paramType) {
                case 'BOOLEAN':
                    defaultValue = 'false';
                    input.checked = false;
                    break;
                case 'INTEGER':
                    defaultValue = '0';
                    break;
                case 'DECIMAL':
                    defaultValue = '0.0';
                    break;
                default:
                    defaultValue = '';
            }

            if (input.type === 'checkbox') {
                input.checked = defaultValue === 'true';
            } else {
                input.value = defaultValue;
            }

            // Mettre à jour l'affichage
            updateParameterDisplay(paramKey, defaultValue);

            // Afficher un message
            showToast(`Paramètre "${paramKey}" réinitialisé`, 'success');
        }
    }

    // Mettre à jour l'affichage d'un paramètre
    function updateParameterDisplay(paramKey, value) {
        const row = document.querySelector(`[name="${paramKey}"]`).closest('tr');
        if (!row) return;

        const label = row.querySelector('.form-check-label');
        if (label && label.textContent.includes('Activé') || label.textContent.includes('Désactivé')) {
            label.textContent = value === 'true' ? 'Activé' : 'Désactivé';
        }
    }

    // Afficher/masquer la section import/export
    function toggleImportExport() {
        const section = document.getElementById('importExportSection');
        section.style.display = section.style.display === 'none' ? 'block' : 'none';
    }

    // Exporter les paramètres en JSON
    function exportSettingsJSON() {
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
        a.download = `pharmaplus-settings-${new Date().toISOString().split('T')[0]}.json`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);

        showToast('Paramètres exportés avec succès', 'success');
    }

    // Exporter les paramètres en CSV
    function exportSettingsCSV() {
        const rows = document.querySelectorAll('tbody tr');
        let csv = 'Clé,Catégorie,Type,Valeur,Description\n';

        rows.forEach(row => {
            const key = row.querySelector('strong').textContent;
            const category = row.querySelectorAll('td')[2].textContent.trim();
            const type = row.querySelectorAll('td')[1].textContent.trim();
            const input = row.querySelector('input, select');
            const value = input ?
                (input.type === 'checkbox' ? input.checked : input.value) : '';
            const description = row.querySelector('small') ?
                row.querySelector('small').textContent : '';

            csv += `"${key}","${category}","${type}","${value}","${description}"\n`;
        });

        const blob = new Blob([csv], { type: 'text/csv' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');

        a.href = url;
        a.download = `pharmaplus-settings-${new Date().toISOString().split('T')[0]}.csv`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);

        showToast('Paramètres exportés en CSV', 'success');
    }

    // Importer les paramètres
    function importSettings() {
        const modal = new bootstrap.Modal(document.getElementById('importModal'));
        modal.show();
    }

    // Démarrer l'importation
    function startImport() {
        const fileInput = document.getElementById('importFile');
        const file = fileInput.files[0];

        if (!file) {
            alert('Veuillez sélectionner un fichier');
            return;
        }

        const reader = new FileReader();
        const progressBar = document.getElementById('importProgressBar');
        const importStatus = document.getElementById('importStatus');
        const importProgress = document.getElementById('importProgress');
        const importForm = document.getElementById('importForm');

        importForm.style.display = 'none';
        importProgress.style.display = 'block';
        importStatus.textContent = 'Lecture du fichier...';
        progressBar.style.width = '25%';

        reader.onload = function(e) {
            try {
                importStatus.textContent = 'Analyse du JSON...';
                progressBar.style.width = '50%';

                const settings = JSON.parse(e.target.result);

                importStatus.textContent = 'Application des paramètres...';
                progressBar.style.width = '75%';

                // Appliquer les paramètres au formulaire
                applySettingsToForm(settings);

                importStatus.textContent = 'Terminé !';
                progressBar.style.width = '100%';
                progressBar.classList.remove('progress-bar-animated');

                setTimeout(() => {
                    modal.hide();
                    showToast('Paramètres importés avec succès', 'success');
                    document.getElementById('settingsForm').submit();
                }, 1000);

            } catch (error) {
                importStatus.textContent = 'Erreur: ' + error.message;
                progressBar.style.width = '100%';
                progressBar.classList.add('bg-danger');

                setTimeout(() => {
                    importForm.style.display = 'block';
                    importProgress.style.display = 'none';
                    progressBar.classList.remove('bg-danger');
                    progressBar.classList.add('progress-bar-animated');
                }, 2000);
            }
        };

        reader.readAsText(file);
    }

    // Appliquer les paramètres au formulaire
    function applySettingsToForm(settings) {
        Object.keys(settings).forEach(key => {
            const input = document.querySelector(`[name="${key}"]`);
            if (input) {
                if (input.type === 'checkbox') {
                    input.checked = settings[key] === 'true' || settings[key] === true;
                } else {
                    input.value = settings[key];
                }
                updateParameterDisplay(key, settings[key]);
            }
        });
    }

    // Afficher un exemple de configuration
    function showSampleSettings() {
        const sampleSettings = {
            "app.name": "PharmaPlus",
            "app.version": "1.0.0",
            "company.name": "Ma Pharmacie",
            "company.address": "123 Rue Principale",
            "company.phone": "032 12 345 67",
            "company.email": "contact@pharmacie.mg",
            "pagination.items_per_page": "20",
            "ui.theme": "light",
            "ui.language": "fr",
            "financial.vat_rate": "0.2",
            "financial.default_currency": "MGA"
        };

        document.getElementById('jsonPreview').textContent =
            JSON.stringify(sampleSettings, null, 2);

        const modal = new bootstrap.Modal(document.getElementById('jsonPreviewModal'));
        modal.show();
    }

    // Copier dans le presse-papier
    function copyToClipboard() {
        const text = document.getElementById('jsonPreview').textContent;
        navigator.clipboard.writeText(text).then(() => {
            showToast('Copié dans le presse-papier', 'success');
        });
    }

    // Afficher une notification toast
    function showToast(message, type = 'info') {
        // Créer le toast
        const toastId = 'toast-' + Date.now();
        const toastHtml = `
            <div id="${toastId}" class="toast align-items-center border-0 ${type === 'success' ? 'bg-success' : 'bg-info'}"
                 role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body text-white">
                        <i class="bi ${type === 'success' ? 'bi-check-circle' : 'bi-info-circle'} me-2"></i>
                        ${message}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto"
                            data-bs-dismiss="toast"></button>
                </div>
            </div>
        `;

        // Ajouter au conteneur de toasts
        let toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            document.body.appendChild(toastContainer);
        }

        toastContainer.innerHTML += toastHtml;

        // Afficher le toast
        const toastElement = document.getElementById(toastId);
        const toast = new bootstrap.Toast(toastElement, {
            autohide: true,
            delay: 3000
        });
        toast.show();

        // Nettoyer après fermeture
        toastElement.addEventListener('hidden.bs.toast', function () {
            toastElement.remove();
        });
    }

    // Validation du formulaire
    document.getElementById('settingsForm').addEventListener('submit', function(e) {
        let isValid = true;
        const requiredFields = document.querySelectorAll('[data-required="true"]');

        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                isValid = false;
                field.classList.add('is-invalid');
                showToast(`Le champ "${field.name}" est requis`, 'warning');
            } else {
                field.classList.remove('is-invalid');
            }
        });

        if (!isValid) {
            e.preventDefault();
            showToast('Veuillez corriger les erreurs dans le formulaire', 'warning');
        } else {
            showToast('Sauvegarde en cours...', 'info');
        }
    });

    // Validation en temps réel pour les nombres
    document.querySelectorAll('input[type="number"]').forEach(input => {
        input.addEventListener('change', function() {
            const min = parseFloat(this.min) || -Infinity;
            const max = parseFloat(this.max) || Infinity;
            const value = parseFloat(this.value);

            if (isNaN(value) || value < min || value > max) {
                this.classList.add('is-invalid');
                showToast(`La valeur doit être entre ${min} et ${max}`, 'warning');
            } else {
                this.classList.remove('is-invalid');
            }
        });
    });

    // Sauvegarde automatique optionnelle
    let saveTimeout;
    document.getElementById('settingsForm').addEventListener('input', function() {
        clearTimeout(saveTimeout);

        // Vérifier si la sauvegarde automatique est activée
        const autoSaveInput = document.querySelector('[name="feature.auto_save"]');
        if (autoSaveInput && autoSaveInput.checked) {
            saveTimeout = setTimeout(() => {
                const formData = new FormData(this);
                fetch(this.action, {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                })
                    .then(response => {
                        if (response.ok) {
                            showToast('Sauvegarde automatique réussie', 'success');
                        }
                    })
                    .catch(error => {
                        console.error('Erreur de sauvegarde automatique:', error);
                    });
            }, 2000); // 2 secondes de délai
        }
    });

    // Réinitialiser l'heure d'affichage lors de la modification
    document.querySelectorAll('input, select').forEach(element => {
        element.addEventListener('change', updateTime);
    });
</script>

<style>
    /* Styles pour les paramètres */
    .form-switch .form-check-input:checked {
        background-color: #0d6efd;
        border-color: #0d6efd;
    }

    .form-switch .form-check-input:focus {
        border-color: #86b7fe;
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
    }

    .modern-input:focus {
        border-color: #86b7fe;
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
    }

    /* Styles pour les badges */
    .badge-modern {
        padding: 0.35rem 0.65rem;
        font-weight: 500;
        font-size: 0.75rem;
        border-radius: 0.375rem;
    }

    /* Animation pour les changements */
    @keyframes highlight {
        0% { background-color: rgba(13, 110, 253, 0.1); }
        100% { background-color: transparent; }
    }

    tr.changed {
        animation: highlight 2s ease-out;
    }

    /* Styles pour le JSON preview */
    pre#jsonPreview {
        font-family: 'Courier New', monospace;
        font-size: 0.875rem;
        line-height: 1.4;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.875rem;
        }

        .btn-group-sm .btn {
            padding: 0.2rem 0.4rem;
            font-size: 0.75rem;
        }

        .stat-card h3 {
            font-size: 1.25rem;
        }
    }
</style>