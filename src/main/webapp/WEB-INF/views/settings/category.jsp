<%-- /WEB-INF/views/settings/category.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <c:choose>
                            <c:when test="${category == 'GENERAL'}"><i class="bi bi-building text-primary me-2"></i></c:when>
                            <c:when test="${category == 'UI'}"><i class="bi bi-display text-primary me-2"></i></c:when>
                            <c:when test="${category == 'SECURITY'}"><i class="bi bi-shield-lock text-primary me-2"></i></c:when>
                            <c:when test="${category == 'FINANCIAL'}"><i class="bi bi-currency-exchange text-primary me-2"></i></c:when>
                            <c:when test="${category == 'NOTIFICATION'}"><i class="bi bi-bell text-primary me-2"></i></c:when>
                            <c:when test="${category == 'ADVANCED'}"><i class="bi bi-gear text-primary me-2"></i></c:when>
                            <c:otherwise><i class="bi bi-sliders text-primary me-2"></i></c:otherwise>
                        </c:choose>
                        ${categoryName}
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-info-circle me-1"></i>
                        ${categoryDescription}
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/settings"
                       class="btn btn-modern btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Tous les paramètres
                    </a>
                    <button type="submit" form="categoryForm" class="btn btn-modern btn-gradient-primary">
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

    <!-- Statistiques de la catégorie -->
    <div class="row mb-4">
        <div class="col-md-3 col-sm-6">
            <div class="modern-card text-center p-3">
                <div class="stat-icon">
                    <i class="bi bi-list-check text-primary" style="font-size: 2rem;"></i>
                </div>
                <h3 class="mt-2 mb-0">${parameters.size()}</h3>
                <p class="text-muted mb-0">Paramètres</p>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="modern-card text-center p-3">
                <div class="stat-icon">
                    <i class="bi bi-check-circle text-success" style="font-size: 2rem;"></i>
                </div>
                <h3 class="mt-2 mb-0">
                    <c:set var="configuredCount" value="0"/>
                    <c:forEach var="param" items="${parameters}">
                        <c:if test="${not empty param.parameterValue}">
                            <c:set var="configuredCount" value="${configuredCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${configuredCount}
                </h3>
                <p class="text-muted mb-0">Configurés</p>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="modern-card text-center p-3">
                <div class="stat-icon">
                    <i class="bi bi-exclamation-circle text-warning" style="font-size: 2rem;"></i>
                </div>
                <h3 class="mt-2 mb-0">${parameters.size() - configuredCount}</h3>
                <p class="text-muted mb-0">À configurer</p>
            </div>
        </div>
        <div class="col-md-3 col-sm-6">
            <div class="modern-card text-center p-3">
                <div class="stat-icon">
                    <i class="bi bi-clock-history text-info" style="font-size: 2rem;"></i>
                </div>
                <h3 class="mt-2 mb-0">
                    <fmt:formatDate value="${now}" pattern="HH:mm"/>
                </h3>
                <p class="text-muted mb-0">Dernière vue</p>
            </div>
        </div>
    </div>

    <!-- Formulaire des paramètres -->
    <div class="row">
        <div class="col-12">
            <form id="categoryForm" method="post"
                  action="${pageContext.request.contextPath}/settings/save?category=${category}">
                <div class="modern-card">
                    <div class="table-responsive">
                        <table class="table modern-table mb-0">
                            <thead>
                            <tr>
                                <th width="30%">Paramètre</th>
                                <th width="15%">Type</th>
                                <th width="45%">Valeur</th>
                                <th width="10%">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="param" items="${parameters}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-start">
                                            <div class="me-3">
                                                <c:choose>
                                                    <c:when test="${param.parameterType == 'STRING'}">
                                                        <i class="bi bi-text-left text-info" style="font-size: 1.2rem;"></i>
                                                    </c:when>
                                                    <c:when test="${param.parameterType == 'INTEGER'}">
                                                        <i class="bi bi-123 text-primary" style="font-size: 1.2rem;"></i>
                                                    </c:when>
                                                    <c:when test="${param.parameterType == 'BOOLEAN'}">
                                                        <i class="bi bi-toggle-on text-success" style="font-size: 1.2rem;"></i>
                                                    </c:when>
                                                    <c:when test="${param.parameterType == 'DECIMAL'}">
                                                        <i class="bi bi-percent text-warning" style="font-size: 1.2rem;"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-gear text-secondary" style="font-size: 1.2rem;"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <strong>${param.parameterKey}</strong>
                                                <c:if test="${not empty param.description}">
                                                    <br>
                                                    <small class="text-muted">${param.description}</small>
                                                </c:if>
                                            </div>
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
                                        <c:choose>
                                            <c:when test="${param.parameterType == 'BOOLEAN'}">
                                                <div class="form-check form-switch">
                                                    <input type="checkbox"
                                                           class="form-check-input"
                                                           name="${param.parameterKey}"
                                                           value="true"
                                                        ${param.parameterValue == 'true' ? 'checked' : ''}>
                                                    <label class="form-check-label ms-2">
                                                        <c:choose>
                                                            <c:when test="${param.parameterValue == 'true'}">
                                                                <span class="text-success">
                                                                    <i class="bi bi-toggle-on me-1"></i>Activé
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-danger">
                                                                    <i class="bi bi-toggle-off me-1"></i>Désactivé
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </label>
                                                </div>
                                            </c:when>
                                            <c:when test="${param.parameterType == 'INTEGER'}">
                                                <input type="number"
                                                       class="form-control modern-input"
                                                       name="${param.parameterKey}"
                                                       value="${param.parameterValue}"
                                                       step="1"
                                                       <c:if test="${param.parameterKey == 'session_timeout'}">min="1" max="1440"</c:if>>
                                            </c:when>
                                            <c:when test="${param.parameterType == 'DECIMAL'}">
                                                <input type="number"
                                                       class="form-control modern-input"
                                                       name="${param.parameterKey}"
                                                       value="${param.parameterValue}"
                                                       step="0.01"
                                                       <c:if test="${param.parameterKey == 'tax_rate'}">min="0" max="100"</c:if>>
                                            </c:when>
                                            <c:when test="${param.parameterKey == 'ui.theme'}">
                                                <select class="form-select modern-input"
                                                        name="${param.parameterKey}">
                                                    <option value="light" ${param.parameterValue == 'light' ? 'selected' : ''}>
                                                        <i class="bi bi-sun me-1"></i>Clair
                                                    </option>
                                                    <option value="dark" ${param.parameterValue == 'dark' ? 'selected' : ''}>
                                                        <i class="bi bi-moon me-1"></i>Sombre
                                                    </option>
                                                    <option value="auto" ${param.parameterValue == 'auto' ? 'selected' : ''}>
                                                        <i class="bi bi-circle-half me-1"></i>Auto
                                                    </option>
                                                </select>
                                            </c:when>
                                            <c:when test="${param.parameterKey == 'ui.language'}">
                                                <select class="form-select modern-input"
                                                        name="${param.parameterKey}">
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
                                            <c:when test="${param.dataType == 'EMAIL'}">
                                                <input type="email"
                                                       class="form-control modern-input"
                                                       name="${param.parameterKey}"
                                                       value="${param.parameterValue}"
                                                       placeholder="email@exemple.com">
                                            </c:when>
                                            <c:when test="${param.dataType == 'PHONE'}">
                                                <input type="tel"
                                                       class="form-control modern-input"
                                                       name="${param.parameterKey}"
                                                       value="${param.parameterValue}"
                                                       pattern="[0-9+\-\s()]+"
                                                       placeholder="032 12 345 67">
                                            </c:when>
                                            <c:otherwise>
                                                <input type="text"
                                                       class="form-control modern-input"
                                                       name="${param.parameterKey}"
                                                       value="${param.parameterValue}">
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty param.validationMessage}">
                                            <small class="text-muted">${param.validationMessage}</small>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <button type="button"
                                                    class="btn btn-outline-warning"
                                                    onclick="resetSingleParameter('${param.parameterKey}')"
                                                    title="Réinitialiser">
                                                <i class="bi bi-arrow-counterclockwise"></i>
                                            </button>
                                            <button type="button"
                                                    class="btn btn-outline-info"
                                                    onclick="showParameterInfo('${param.parameterKey}')"
                                                    title="Information">
                                                <i class="bi bi-info-circle"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Actions de la catégorie -->
                    <div class="p-4 border-top">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <button type="reset" class="btn btn-modern btn-outline-secondary me-2">
                                    <i class="bi bi-x-circle me-2"></i>Annuler
                                </button>
                                <button type="button" class="btn btn-modern btn-outline-warning"
                                        onclick="resetCategorySettings()">
                                    <i class="bi bi-arrow-counterclockwise me-2"></i>Réinitialiser cette catégorie
                                </button>
                            </div>
                            <div>
                                <button type="submit" class="btn btn-modern btn-gradient-primary">
                                    <i class="bi bi-save me-2"></i>Sauvegarder les modifications
                                </button>
                            </div>
                        </div>

                        <!-- Information spécifique à la catégorie -->
                        <div class="mt-4 pt-3 border-top">
                            <div class="alert alert-info mb-0">
                                <div class="d-flex">
                                    <i class="bi bi-info-circle-fill me-3" style="font-size: 1.2rem;"></i>
                                    <div>
                                        <c:choose>
                                            <c:when test="${category == 'GENERAL'}">
                                                <strong>Note :</strong> Les paramètres généraux affectent l'identité de votre pharmacie.
                                                Le nom et l'adresse apparaîtront sur les factures et documents officiels.
                                            </c:when>
                                            <c:when test="${category == 'UI'}">
                                                <strong>Note :</strong> Les changements d'interface sont appliqués immédiatement.
                                                Le changement de thème nécessite un rechargement de la page.
                                            </c:when>
                                            <c:when test="${category == 'FINANCIAL'}">
                                                <strong>Note :</strong> Les paramètres financiers affectent tous les calculs monétaires.
                                                Modifiez ces valeurs avec précaution, surtout en cours d'exercice.
                                            </c:when>
                                            <c:when test="${category == 'SECURITY'}">
                                                <strong>Note :</strong> Les paramètres de sécurité sont critiques.
                                                Un timeout de session trop long peut présenter un risque.
                                            </c:when>
                                            <c:when test="${category == 'NOTIFICATION'}">
                                                <strong>Note :</strong> Configurez les seuils d'alerte selon votre volume de stock.
                                                Des seuils trop bas généreront trop d'alertes.
                                            </c:when>
                                            <c:when test="${category == 'ADVANCED'}">
                                                <strong>Attention :</strong> Ces paramètres sont destinés aux administrateurs expérimentés.
                                                Des modifications incorrectes peuvent affecter la stabilité du système.
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal d'information paramètre -->
<div class="modal fade" id="parameterInfoModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="parameterInfoTitle">
                    <i class="bi bi-info-circle text-info me-2"></i>
                    Information du paramètre
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <strong>Clé :</strong>
                    <span id="paramKey" class="badge bg-light text-dark ms-2"></span>
                </div>
                <div class="mb-3">
                    <strong>Type :</strong>
                    <span id="paramType" class="badge bg-info ms-2"></span>
                </div>
                <div class="mb-3">
                    <strong>Catégorie :</strong>
                    <span id="paramCategory" class="badge bg-light text-dark ms-2"></span>
                </div>
                <div class="mb-3">
                    <strong>Valeur actuelle :</strong>
                    <code id="paramCurrentValue" class="ms-2"></code>
                </div>
                <div class="mb-3">
                    <strong>Valeur par défaut :</strong>
                    <code id="paramDefaultValue" class="ms-2"></code>
                </div>
                <div>
                    <strong>Description :</strong>
                    <p id="paramDescription" class="mt-2 text-muted"></p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal de confirmation réinitialisation -->
<div class="modal fade" id="resetCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-exclamation-triangle text-warning me-2"></i>
                    Confirmation
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir réinitialiser tous les paramètres de la catégorie <strong>${categoryName}</strong> ?</p>
                <p class="text-danger">
                    <i class="bi bi-exclamation-circle me-1"></i>
                    Cette action restaurera toutes les valeurs par défaut.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-warning" onclick="confirmResetCategory()">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>Réinitialiser
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Initialisation
    document.addEventListener('DOMContentLoaded', function() {
        // Initialiser les tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Marquer les champs modifiés
        document.querySelectorAll('input, select').forEach(element => {
            const originalValue = element.value;

            element.addEventListener('change', function() {
                if (this.value !== originalValue) {
                    this.closest('tr').classList.add('table-warning');
                } else {
                    this.closest('tr').classList.remove('table-warning');
                }
            });
        });
    });

    // Réinitialiser un paramètre spécifique
    function resetSingleParameter(paramKey) {
        if (!confirm(`Réinitialiser le paramètre "${paramKey}" à sa valeur par défaut ?`)) {
            return;
        }

        fetch('${pageContext.request.contextPath}/settings/update-single', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                key: paramKey,
                value: getDefaultValue(paramKey)
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Erreur : ' + data.message);
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                alert('Erreur lors de la réinitialisation');
            });
    }

    // Afficher les informations d'un paramètre
    function showParameterInfo(paramKey) {
        // Récupérer les informations du paramètre depuis la ligne
        const row = document.querySelector(`[name="${paramKey}"]`).closest('tr');

        document.getElementById('paramKey').textContent = paramKey;
        document.getElementById('paramType').textContent = row.querySelector('.badge').textContent;
        document.getElementById('paramCategory').textContent = '${category}';
        document.getElementById('paramCurrentValue').textContent =
            row.querySelector('input, select').value || 'Non défini';
        document.getElementById('paramDefaultValue').textContent = getDefaultValue(paramKey);

        // Description (à récupérer via AJAX si disponible)
        const description = row.querySelector('small.text-muted');
        document.getElementById('paramDescription').textContent =
            description ? description.textContent : 'Aucune description disponible';

        const modal = new bootstrap.Modal(document.getElementById('parameterInfoModal'));
        modal.show();
    }

    // Réinitialiser toute la catégorie
    function resetCategorySettings() {
        const modal = new bootstrap.Modal(document.getElementById('resetCategoryModal'));
        modal.show();
    }

    // Confirmer la réinitialisation de la catégorie
    function confirmResetCategory() {
        fetch('${pageContext.request.contextPath}/settings/reset?category=${category}&confirm=true', {
            method: 'POST'
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

    // Obtenir la valeur par défaut d'un paramètre
    function getDefaultValue(paramKey) {
        const defaults = {
            // GENERAL
            'pharmacy_name': 'PharmaMaster',
            'pharmacy_address': '',
            'pharmacy_phone': '',
            'pharmacy_email': '',
            'business_hours': '8:00-18:00',

            // UI
            'ui.theme': 'light',
            'ui.language': 'fr',
            'date_format': 'dd/MM/yyyy',
            'items_per_page': '10',

            // FINANCIAL
            'default_currency': 'XOF',
            'tax_rate': '0',
            'enable_discount': 'true',
            'max_discount_percentage': '20',

            // NOTIFICATION
            'low_stock_alert': 'true',
            'low_stock_threshold': '10',
            'expiry_alert_days': '30',

            // SECURITY
            'session_timeout': '30',
            'password_min_length': '6',
            'enable_two_factor': 'false'
        };

        return defaults[paramKey] || '';
    }

    // Validation du formulaire
    document.getElementById('categoryForm').addEventListener('submit', function(e) {
        let isValid = true;
        const errors = [];

        // Validation des nombres
        document.querySelectorAll('input[type="number"]').forEach(input => {
            const min = parseFloat(input.min) || -Infinity;
            const max = parseFloat(input.max) || Infinity;
            const value = parseFloat(input.value);

            if (!isNaN(value) && (value < min || value > max)) {
                isValid = false;
                input.classList.add('is-invalid');
                errors.push(`${input.name} doit être entre ${min} et ${max}`);
            } else {
                input.classList.remove('is-invalid');
            }
        });

        // Validation des emails
        document.querySelectorAll('input[type="email"]').forEach(input => {
            if (input.value && !isValidEmail(input.value)) {
                isValid = false;
                input.classList.add('is-invalid');
                errors.push(`${input.name} n'est pas un email valide`);
            } else {
                input.classList.remove('is-invalid');
            }
        });

        if (!isValid) {
            e.preventDefault();
            alert('Veuillez corriger les erreurs :\n' + errors.join('\n'));
        }
    });

    // Fonction de validation d'email
    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    // Export de la catégorie
    function exportCategory() {
        window.location.href = '${pageContext.request.contextPath}/settings/export?category=${category}';
    }

    // Afficher un message toast
    function showToast(message, type = 'info') {
        // Implémentation similaire à celle de list.jsp
        console.log(`${type}: ${message}`);
        alert(message); // Temporaire
    }
</script>

<style>
    .modern-table tbody tr:hover {
        background-color: rgba(0, 123, 255, 0.05);
    }

    .modern-table tbody tr.table-warning {
        background-color: rgba(255, 193, 7, 0.1);
        border-left: 3px solid #ffc107;
    }

    .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background-color: rgba(13, 110, 253, 0.1);
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1rem;
    }

    .form-check-input:checked {
        background-color: #0d6efd;
        border-color: #0d6efd;
    }

    .form-control.is-invalid {
        border-color: #dc3545;
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
    }
</style>