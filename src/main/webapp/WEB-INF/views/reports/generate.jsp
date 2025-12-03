<%-- /WEB-INF/views/reports/generate.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="fr_FR"/>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-file-earmark-plus text-primary me-2"></i>Générer un Rapport
                    </h2>
                    <p class="text-muted mb-0">
                        Créez des rapports personnalisés selon vos besoins
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/reports" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Retour aux rapports
                </a>
            </div>
        </div>
    </div>

    <!-- Messages -->
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

    <div class="row">
        <!-- Formulaire principal -->
        <div class="col-lg-8">
            <div class="card">
                <div class="card-body">
                    <form id="reportForm" method="post" action="${pageContext.request.contextPath}/reports/generate">

                        <!-- Type de rapport -->
                        <div class="mb-4">
                            <h5 class="border-bottom pb-2 mb-3">
                                <i class="bi bi-file-text me-2"></i>Type de Rapport
                            </h5>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="report-type-card" onclick="selectReportType('SALES')">
                                        <input type="radio" name="reportType" value="SALES"
                                               id="type_SALES" class="d-none" required>
                                        <label for="type_SALES" class="d-block p-3 h-100">
                                            <div class="d-flex align-items-start">
                                                <i class="bi bi-cart-check-fill fs-3 me-3 text-primary"></i>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-1">Rapport de Ventes</h6>
                                                    <small class="text-muted">Analysez vos ventes et revenus</small>
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="report-type-card" onclick="selectReportType('STOCK')">
                                        <input type="radio" name="reportType" value="STOCK"
                                               id="type_STOCK" class="d-none" required>
                                        <label for="type_STOCK" class="d-block p-3 h-100">
                                            <div class="d-flex align-items-start">
                                                <i class="bi bi-box-seam-fill fs-3 me-3 text-primary"></i>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-1">Rapport de Stock</h6>
                                                    <small class="text-muted">État actuel de votre stock</small>
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="report-type-card" onclick="selectReportType('CUSTOMER')">
                                        <input type="radio" name="reportType" value="CUSTOMER"
                                               id="type_CUSTOMER" class="d-none" required>
                                        <label for="type_CUSTOMER" class="d-block p-3 h-100">
                                            <div class="d-flex align-items-start">
                                                <i class="bi bi-people-fill fs-3 me-3 text-primary"></i>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-1">Rapport Clients</h6>
                                                    <small class="text-muted">Statistiques sur vos clients</small>
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="report-type-card" onclick="selectReportType('FINANCIAL')">
                                        <input type="radio" name="reportType" value="FINANCIAL"
                                               id="type_FINANCIAL" class="d-none" required>
                                        <label for="type_FINANCIAL" class="d-block p-3 h-100">
                                            <div class="d-flex align-items-start">
                                                <i class="bi bi-currency-exchange fs-3 me-3 text-primary"></i>
                                                <div class="flex-grow-1">
                                                    <h6 class="mb-1">Rapport Financier</h6>
                                                    <small class="text-muted">Vue d'ensemble financière</small>
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="invalid-feedback d-block" id="reportTypeError" style="display: none;">
                                Veuillez sélectionner un type de rapport
                            </div>
                        </div>

                        <!-- Période -->
                        <div class="mb-4" id="periodSection">
                            <h5 class="border-bottom pb-2 mb-3">
                                <i class="bi bi-calendar-range me-2"></i>Période
                            </h5>

                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label for="startDate" class="form-label">
                                        Date de début <span class="text-danger">*</span>
                                    </label>
                                    <input type="date" class="form-control"
                                           id="startDate" name="startDate" required>
                                </div>

                                <div class="col-md-6">
                                    <label for="endDate" class="form-label">
                                        Date de fin <span class="text-danger">*</span>
                                    </label>
                                    <input type="date" class="form-control"
                                           id="endDate" name="endDate" required>
                                </div>
                            </div>

                            <!-- Raccourcis de période -->
                            <div class="btn-group btn-group-sm" role="group">
                                <button type="button" class="btn btn-outline-secondary" onclick="setPeriod(7)">
                                    7 derniers jours
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="setPeriod(30)">
                                    30 derniers jours
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="setPeriod(90)">
                                    3 derniers mois
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="setPeriod(365)">
                                    Année en cours
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="setCurrentMonth()">
                                    Mois en cours
                                </button>
                            </div>
                        </div>

                        <!-- Options supplémentaires -->
                        <div class="mb-4" id="additionalOptions" style="display: none;">
                            <h5 class="border-bottom pb-2 mb-3">
                                <i class="bi bi-sliders me-2"></i>Options Supplémentaires
                            </h5>

                            <!-- Options pour rapport de ventes -->
                            <div id="salesOptions" class="report-options" style="display: none;">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Grouper par</label>
                                        <select class="form-select" name="groupBy">
                                            <option value="day">Jour</option>
                                            <option value="week">Semaine</option>
                                            <option value="month" selected>Mois</option>
                                            <option value="product">Produit</option>
                                            <option value="category">Catégorie</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Inclure</label>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="includeDetails"
                                                   id="includeDetails" value="true" checked>
                                            <label class="form-check-label" for="includeDetails">
                                                Détails des transactions
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="includeCharts"
                                                   id="includeCharts" value="true" checked>
                                            <label class="form-check-label" for="includeCharts">
                                                Graphiques
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Options pour rapport de stock -->
                            <div id="stockOptions" class="report-options" style="display: none;">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Filtrer par</label>
                                        <select class="form-select" name="stockFilter">
                                            <option value="all">Tous les produits</option>
                                            <option value="low">Stock bas uniquement</option>
                                            <option value="expired">Produits expirés</option>
                                            <option value="expiring">Expiration proche</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Catégorie</label>
                                        <select class="form-select" name="categoryFilter">
                                            <option value="">Toutes les catégories</option>
                                            <option value="medicaments">Médicaments</option>
                                            <option value="supplements">Suppléments</option>
                                            <option value="equipements">Équipements</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Options pour rapport clients -->
                            <div id="customerOptions" class="report-options" style="display: none;">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Type de clients</label>
                                        <select class="form-select" name="customerType">
                                            <option value="all">Tous les clients</option>
                                            <option value="new">Nouveaux clients</option>
                                            <option value="active">Clients actifs</option>
                                            <option value="inactive">Clients inactifs</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Inclure</label>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="includePurchaseHistory"
                                                   id="includePurchaseHistory" value="true">
                                            <label class="form-check-label" for="includePurchaseHistory">
                                                Historique d'achats
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="includeStatistics"
                                                   id="includeStatistics" value="true" checked>
                                            <label class="form-check-label" for="includeStatistics">
                                                Statistiques
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Options pour rapport financier -->
                            <div id="financialOptions" class="report-options" style="display: none;">
                                <div class="row g-3">
                                    <div class="col-md-12">
                                        <label class="form-label">Inclure dans le rapport</label>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="includeRevenue"
                                                           id="includeRevenue" value="true" checked>
                                                    <label class="form-check-label" for="includeRevenue">
                                                        Chiffre d'affaires
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="includeExpenses"
                                                           id="includeExpenses" value="true" checked>
                                                    <label class="form-check-label" for="includeExpenses">
                                                        Dépenses
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="includeProfit"
                                                           id="includeProfit" value="true" checked>
                                                    <label class="form-check-label" for="includeProfit">
                                                        Bénéfices
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="includeTaxes"
                                                           id="includeTaxes" value="true">
                                                    <label class="form-check-label" for="includeTaxes">
                                                        Taxes
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Format d'export -->
                        <div class="mb-4">
                            <h5 class="border-bottom pb-2 mb-3">
                                <i class="bi bi-file-earmark-arrow-down me-2"></i>Format d'Export
                            </h5>

                            <div class="row g-3">
                                <div class="col-md-3 col-6">
                                    <div class="format-card" onclick="selectFormat('HTML')">
                                        <input type="radio" name="format" value="HTML"
                                               id="format_HTML" class="d-none" checked>
                                        <label for="format_HTML" class="d-block p-3 text-center h-100">
                                            <i class="bi bi-filetype-html fs-1 d-block mb-2 text-primary"></i>
                                            <div class="fw-bold small">HTML</div>
                                        </label>
                                    </div>
                                </div>

                                <div class="col-md-3 col-6">
                                    <div class="format-card" onclick="selectFormat('PDF')">
                                        <input type="radio" name="format" value="PDF"
                                               id="format_PDF" class="d-none">
                                        <label for="format_PDF" class="d-block p-3 text-center h-100">
                                            <i class="bi bi-file-earmark-pdf-fill fs-1 d-block mb-2 text-danger"></i>
                                            <div class="fw-bold small">PDF</div>
                                        </label>
                                    </div>
                                </div>

                                <div class="col-md-3 col-6">
                                    <div class="format-card" onclick="selectFormat('EXCEL')">
                                        <input type="radio" name="format" value="EXCEL"
                                               id="format_EXCEL" class="d-none">
                                        <label for="format_EXCEL" class="d-block p-3 text-center h-100">
                                            <i class="bi bi-file-earmark-excel-fill fs-1 d-block mb-2 text-success"></i>
                                            <div class="fw-bold small">Excel</div>
                                        </label>
                                    </div>
                                </div>

                                <div class="col-md-3 col-6">
                                    <div class="format-card" onclick="selectFormat('CSV')">
                                        <input type="radio" name="format" value="CSV"
                                               id="format_CSV" class="d-none">
                                        <label for="format_CSV" class="d-block p-3 text-center h-100">
                                            <i class="bi bi-filetype-csv fs-1 d-block mb-2 text-info"></i>
                                            <div class="fw-bold small">CSV</div>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Boutons d'action -->
                        <div class="d-flex justify-content-between pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/reports"
                               class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle me-2"></i>Annuler
                            </a>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-play-circle me-2"></i>Générer le Rapport
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Panneau d'aide -->
        <div class="col-lg-4">
            <!-- Aide rapide -->
            <div class="card p-3 mb-3">
                <h6 class="mb-3">
                    <i class="bi bi-lightbulb text-warning me-2"></i>Aide Rapide
                </h6>
                <div id="helpContent">
                    <p class="small text-muted mb-2">
                        <strong>Sélectionnez un type de rapport</strong> pour voir les options disponibles.
                    </p>
                    <ul class="small text-muted mb-0">
                        <li>Choisissez le type de rapport souhaité</li>
                        <li>Définissez la période d'analyse</li>
                        <li>Personnalisez les options</li>
                        <li>Sélectionnez le format d'export</li>
                        <li>Générez le rapport</li>
                    </ul>
                </div>
            </div>

            <!-- Information -->
            <div class="card p-3">
                <h6 class="mb-3">
                    <i class="bi bi-info-circle text-info me-2"></i>Informations
                </h6>
                <div class="small text-muted">
                    <p>Les rapports sont générés en temps réel à partir de vos données.</p>
                    <p>Pour les rapports volumineux, la génération peut prendre quelques instants.</p>
                    <p class="mb-0">Vous pouvez télécharger le rapport une fois généré.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Initialiser les dates au chargement de la page
    document.addEventListener('DOMContentLoaded', function() {
        // Définir les dates par défaut (30 derniers jours)
        setPeriod(30);

        // Pré-sélectionner HTML
        selectFormat('HTML');
    });

    // Sélection du type de rapport
    function selectReportType(type) {
        // Désélectionner tous les types
        document.querySelectorAll('.report-type-card').forEach(card => {
            card.classList.remove('selected');
        });

        // Sélectionner le type cliqué
        const selectedCard = document.querySelector(`#type_${type}`).closest('.report-type-card');
        selectedCard.classList.add('selected');
        document.getElementById(`type_${type}`).checked = true;

        // Masquer toutes les options
        document.querySelectorAll('.report-options').forEach(option => {
            option.style.display = 'none';
        });

        // Afficher les options correspondantes
        document.getElementById('additionalOptions').style.display = 'block';

        if (type === 'SALES') {
            document.getElementById('salesOptions').style.display = 'block';
        } else if (type === 'STOCK') {
            document.getElementById('stockOptions').style.display = 'block';
        } else if (type === 'CUSTOMER') {
            document.getElementById('customerOptions').style.display = 'block';
        } else if (type === 'FINANCIAL') {
            document.getElementById('financialOptions').style.display = 'block';
        }

        // Mettre à jour l'aide
        updateHelp(type);

        // Masquer l'erreur si elle était affichée
        document.getElementById('reportTypeError').style.display = 'none';
    }

    // Sélection du format
    function selectFormat(format) {
        document.querySelectorAll('.format-card').forEach(card => {
            card.classList.remove('selected');
        });

        const selectedCard = document.querySelector(`#format_${format}`).closest('.format-card');
        selectedCard.classList.add('selected');
        document.getElementById(`format_${format}`).checked = true;
    }

    // Définir une période
    function setPeriod(days) {
        const endDate = new Date();
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - days);

        document.getElementById('startDate').value = formatDate(startDate);
        document.getElementById('endDate').value = formatDate(endDate);
    }

    // Définir le mois en cours
    function setCurrentMonth() {
        const now = new Date();
        const firstDay = new Date(now.getFullYear(), now.getMonth(), 1);
        const lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0);

        document.getElementById('startDate').value = formatDate(firstDay);
        document.getElementById('endDate').value = formatDate(lastDay);
    }

    // Formater une date en YYYY-MM-DD
    function formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    // Mettre à jour l'aide contextuelle
    function updateHelp(type) {
        const helpTexts = {
            'SALES': {
                title: 'Rapport de Ventes',
                text: 'Analysez vos ventes sur une période donnée. Vous pouvez grouper par jour, semaine, mois, produit ou catégorie.'
            },
            'STOCK': {
                title: 'Rapport de Stock',
                text: 'Vue d\'ensemble de votre stock actuel. Identifiez les produits en rupture ou proche de l\'expiration.'
            },
            'CUSTOMER': {
                title: 'Rapport Clients',
                text: 'Analysez votre base client. Identifiez les clients actifs, nouveaux ou inactifs.'
            },
            'FINANCIAL': {
                title: 'Rapport Financier',
                text: 'Vue complète de vos finances : chiffre d\'affaires, dépenses, bénéfices et taxes.'
            }
        };

        const help = helpTexts[type];
        if (help) {
            document.getElementById('helpContent').innerHTML = `
                <p class="small mb-2"><strong>${help.title}</strong></p>
                <p class="small text-muted mb-0">${help.text}</p>
            `;
        }
    }

    // Validation du formulaire
    document.getElementById('reportForm').addEventListener('submit', function(e) {
        const reportType = document.querySelector('input[name="reportType"]:checked');

        if (!reportType) {
            e.preventDefault();
            document.getElementById('reportTypeError').style.display = 'block';
            document.querySelector('.report-type-card').scrollIntoView({ behavior: 'smooth' });
            return false;
        }

        // Validation des dates
        const startDate = new Date(document.getElementById('startDate').value);
        const endDate = new Date(document.getElementById('endDate').value);

        if (startDate > endDate) {
            e.preventDefault();
            alert('La date de début doit être antérieure à la date de fin');
            return false;
        }

        // Afficher un loader
        const submitBtn = this.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Génération...';

        return true;
    });
</script>

<style>
    .report-type-card, .format-card {
        border: 2px solid #e9ecef;
        border-radius: 12px;
        cursor: pointer;
        transition: all 0.3s ease;
        height: 100%;
    }

    .report-type-card:hover, .format-card:hover {
        border-color: #667eea;
        background-color: rgba(102, 126, 234, 0.05);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
    }

    .report-type-card.selected, .format-card.selected {
        border-color: #667eea;
        background-color: rgba(102, 126, 234, 0.1);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
    }

    .report-type-card label, .format-card label {
        cursor: pointer;
        margin: 0;
    }

    /* Animation pour les options */
    .report-options {
        animation: fadeIn 0.3s ease-in;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>