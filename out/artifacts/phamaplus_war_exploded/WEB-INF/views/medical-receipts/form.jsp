<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* Modern Gradient Colors */
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --success-gradient: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        --info-gradient: linear-gradient(135deg, #3a7bd5 0%, #00d2ff 100%);
        --warning-gradient: linear-gradient(135deg, #f46b45 0%, #eea849 100%);
        --card-shadow: 0 8px 32px rgba(102, 126, 234, 0.1);
        --hover-shadow: 0 12px 48px rgba(102, 126, 234, 0.15);
    }

    .form-section {
        margin-bottom: 2.5rem;
        padding-bottom: 2.5rem;
        position: relative;
    }

    .form-section:not(:last-child):after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.3), transparent);
    }

    .form-section-title {
        color: #2d3748;
        font-weight: 700;
        margin-bottom: 1.75rem;
        padding-left: 0;
        position: relative;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 1.25rem;
    }

    .form-section-title:before {
        content: '';
        display: block;
        width: 4px;
        height: 24px;
        background: var(--primary-gradient);
        border-radius: 2px;
    }

    .required-field {
        font-weight: 600;
        color: #2d3748;
    }

    .required-field:after {
        content: " *";
        color: #f56565;
    }

    /* Modern Card Design */
    .modern-card {
        background: white;
        border-radius: 16px;
        border: 1px solid rgba(226, 232, 240, 0.8);
        box-shadow: var(--card-shadow);
        transition: all 0.3s ease;
        overflow: hidden;
    }

    .modern-card:hover {
        box-shadow: var(--hover-shadow);
        border-color: rgba(102, 126, 234, 0.3);
    }

    .modern-card .card-body {
        padding: 2rem;
    }

    /* Modern Input Styling */
    .modern-input {
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        padding: 0.875rem 1rem;
        font-size: 1rem;
        transition: all 0.3s ease;
        background: #f8fafc;
    }

    .modern-input:focus {
        border-color: #667eea;
        background: white;
        box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        outline: none;
    }

    .modern-input:read-only {
        background: #f1f5f9;
        border-color: #cbd5e0;
        color: #64748b;
    }

    /* Info Box Modern */
    .info-box-modern {
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
        border-radius: 16px;
        padding: 1.5rem;
        margin-bottom: 2rem;
        border: 1px solid rgba(102, 126, 234, 0.2);
        position: relative;
        overflow: hidden;
    }

    .info-box-modern:before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 4px;
        height: 100%;
        background: var(--primary-gradient);
    }

    /* Amount Display Box */
    .amount-display-modern {
        background: linear-gradient(135deg, rgba(17, 153, 142, 0.05), rgba(56, 239, 125, 0.05));
        border-radius: 16px;
        padding: 1.5rem;
        border: 2px solid rgba(17, 153, 142, 0.2);
        margin-top: 1rem;
        position: relative;
        overflow: hidden;
    }

    .amount-display-modern:before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: var(--success-gradient);
    }

    .amount-words {
        color: #11998e;
        font-weight: 600;
        font-size: 1.125rem;
        line-height: 1.6;
        min-height: 3rem;
        display: flex;
        align-items: center;
        padding: 0.5rem;
        background: rgba(255, 255, 255, 0.7);
        border-radius: 8px;
        margin-top: 0.5rem;
    }

    /* Service Type Grid - Modern */
    .service-type-grid-modern {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 1rem;
        margin: 1.5rem 0;
    }

    .service-card-modern {
        background: white;
        border: 2px solid #e2e8f0;
        border-radius: 14px;
        padding: 1.5rem 1rem;
        cursor: pointer;
        transition: all 0.3s ease;
        text-align: center;
        position: relative;
        overflow: hidden;
    }

    .service-card-modern:hover {
        border-color: #667eea;
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(102, 126, 234, 0.15);
    }

    .service-card-modern.selected {
        border-color: #667eea;
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
        box-shadow: 0 8px 24px rgba(102, 126, 234, 0.2);
    }

    .service-card-modern.selected:after {
        content: '✓';
        position: absolute;
        top: 8px;
        right: 8px;
        width: 24px;
        height: 24px;
        background: #667eea;
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.875rem;
        font-weight: bold;
    }

    .service-card-modern i {
        font-size: 2.25rem;
        margin-bottom: 0.75rem;
        background: var(--primary-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .service-card-modern .service-name {
        font-weight: 600;
        color: #2d3748;
        font-size: 0.95rem;
        line-height: 1.4;
    }

    /* Modern Button Group */
    .btn-group-modern {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
        margin-top: 3rem;
        padding-top: 2rem;
        border-top: 1px solid rgba(226, 232, 240, 0.8);
    }

    .btn-modern {
        border-radius: 12px;
        padding: 0.875rem 2rem;
        font-weight: 600;
        border: none;
        transition: all 0.3s ease;
    }

    .btn-modern.btn-gradient-primary {
        background: var(--primary-gradient);
        color: white;
    }

    .btn-modern.btn-gradient-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
    }

    .btn-modern.btn-outline-modern {
        background: white;
        border: 2px solid #e2e8f0;
        color: #4a5568;
    }

    .btn-modern.btn-outline-modern:hover {
        border-color: #667eea;
        color: #667eea;
        background: rgba(102, 126, 234, 0.05);
    }

    /* Page Header Modern */
    .page-header-modern {
        background: linear-gradient(135deg, #f8fafc 0%, #edf2f7 100%);
        border-radius: 20px;
        padding: 2rem;
        margin-bottom: 3rem;
        border: 1px solid rgba(226, 232, 240, 0.8);
        position: relative;
        overflow: hidden;
    }

    .page-header-modern:before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 4px;
        background: var(--primary-gradient);
    }

    /* Form Validation Styling */
    .was-validated .modern-input:invalid {
        border-color: #fc8181;
        background: rgba(252, 129, 129, 0.05);
    }

    .was-validated .modern-input:valid {
        border-color: #48bb78;
    }

    .invalid-feedback {
        font-size: 0.875rem;
        color: #f56565;
        margin-top: 0.25rem;
    }

    /* Loading Animation for Amount Conversion */
    @keyframes pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.5; }
    }

    .loading {
        animation: pulse 1.5s infinite;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .modern-card .card-body {
            padding: 1.5rem;
        }

        .service-type-grid-modern {
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
        }

        .btn-group-modern {
            flex-direction: column;
        }

        .btn-modern {
            width: 100%;
            justify-content: center;
        }

        .page-header-modern {
            padding: 1.5rem;
        }
    }

    @media (max-width: 480px) {
        .service-type-grid-modern {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="container-fluid">
    <!-- Modern Page Header -->
    <div class="page-header-modern mb-5">
        <div class="d-flex justify-content-between align-items-start">
            <div class="flex-grow-1">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-white p-2 rounded-circle shadow-sm me-3">
                        <i class="bi ${isEdit ? 'bi-pencil-square' : 'bi-plus-circle'} fs-4"
                           style="background: var(--primary-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"></i>
                    </div>
                    <div>
                        <h1 class="h3 fw-bold text-gray-800 mb-1">
                            ${isEdit ? 'Modifier le Reçu' : 'Nouveau Reçu Médical'}
                        </h1>
                        <p class="text-muted mb-0">
                            ${isEdit ? 'Modifiez les informations du reçu existant' : 'Créez un nouveau reçu de consultation médicale'}
                        </p>
                    </div>
                </div>

                <!-- Progress Indicator -->
                <div class="d-flex align-items-center mt-4">
                    <div class="d-flex align-items-center me-4">
                        <div class="bg-success rounded-circle p-2 me-2">
                            <i class="bi bi-check-lg text-white"></i>
                        </div>
                        <span class="text-muted">Informations patient</span>
                    </div>
                    <div class="me-4"><i class="bi bi-chevron-right text-gray-400"></i></div>
                    <div class="d-flex align-items-center me-4">
                        <div class="bg-primary rounded-circle p-2 me-2">
                            <span class="text-white">2</span>
                        </div>
                        <span class="fw-medium">Détails consultation</span>
                    </div>
                    <div class="me-4"><i class="bi bi-chevron-right text-gray-400"></i></div>
                    <div class="d-flex align-items-center">
                        <div class="bg-gray-200 rounded-circle p-2 me-2">
                            <span class="text-gray-500">3</span>
                        </div>
                        <span class="text-muted">Validation</span>
                    </div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/medical-receipts"
               class="btn btn-outline-modern btn-modern">
                <i class="bi bi-arrow-left me-2"></i>Retour
            </a>
        </div>
    </div>

    <!-- Error Messages -->
    <c:if test="${not empty errorMessage}">
        <div class="modern-card mb-4 border-left-4 border-left-danger">
            <div class="card-body d-flex align-items-start">
                <div class="bg-danger bg-opacity-10 p-2 rounded-circle me-3">
                    <i class="bi bi-exclamation-circle-fill text-danger"></i>
                </div>
                <div>
                    <h6 class="fw-bold mb-1">Erreur de validation</h6>
                    <p class="mb-0">${errorMessage}</p>
                </div>
                <button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.style.display='none'"></button>
            </div>
        </div>
    </c:if>

    <!-- Info Box -->
    <c:if test="${not isEdit}">
        <div class="info-box-modern mb-5">
            <div class="d-flex">
                <div class="flex-shrink-0 me-3">
                    <div class="bg-primary bg-opacity-10 p-2 rounded-circle">
                        <i class="bi bi-info-circle-fill text-primary"></i>
                    </div>
                </div>
                <div class="flex-grow-1">
                    <h5 class="fw-bold mb-2">Informations importantes</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <ul class="mb-0">
                                <li class="mb-2">
                                    <i class="bi bi-asterisk text-danger me-2"></i>
                                    <span class="text-muted">Champs obligatoires marqués d'une étoile</span>
                                </li>
                                <li class="mb-2">
                                    <i class="bi bi-hash text-primary me-2"></i>
                                    <span class="text-muted">Numéro de reçu généré automatiquement</span>
                                </li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <ul class="mb-0">
                                <li class="mb-2">
                                    <i class="bi bi-calculator text-success me-2"></i>
                                    <span class="text-muted">Montant converti automatiquement en lettres</span>
                                </li>
                                <li class="mb-2">
                                    <i class="bi bi-calendar-check text-info me-2"></i>
                                    <span class="text-muted">Reçu valable pendant 7 jours</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Main Form -->
    <form method="post"
          action="${pageContext.request.contextPath}/medical-receipts"
          id="receiptForm"
          class="needs-validation"
          novalidate>

        <input type="hidden" name="action" value="${isEdit ? 'update' : 'create'}">
        <c:if test="${isEdit}">
            <input type="hidden" name="receiptId" value="${receipt.receiptId}">
        </c:if>

        <!-- Receipt Information -->
        <div class="modern-card mb-5">
            <div class="card-body">
                <h4 class="form-section-title">
                    Informations du Reçu
                </h4>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <label for="receiptNumber" class="form-label required-field">
                            <i class="bi bi-hash me-2 text-primary"></i>
                            Numéro de Reçu
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-receipt text-primary"></i>
                            </span>
                            <input type="text"
                                   class="form-control modern-input border-start-0"
                                   id="receiptNumber"
                                   name="receiptNumber"
                                   value="${isEdit ? receipt.receiptNumber : receiptNumber}"
                                   readonly>
                        </div>
                        <small class="form-text text-muted mt-2 d-flex align-items-center">
                            <i class="bi bi-info-circle me-1"></i>
                            Généré automatiquement - format unique
                        </small>
                    </div>

                    <div class="col-md-6 mb-4">
                        <label for="receiptDate" class="form-label required-field">
                            <i class="bi bi-calendar-date me-2 text-primary"></i>
                            Date & Heure
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-clock text-primary"></i>
                            </span>
                            <input type="datetime-local"
                                   class="form-control modern-input border-start-0"
                                   id="receiptDate"
                                   name="receiptDate"
                                   value="${currentDate}"
                                   readonly>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Patient Information -->
        <div class="modern-card mb-5">
            <div class="card-body">
                <h4 class="form-section-title">
                    Informations Patient
                </h4>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <label for="patientName" class="form-label required-field">
                            <i class="bi bi-person-badge me-2 text-primary"></i>
                            Nom Complet
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-person-fill text-primary"></i>
                            </span>
                            <input type="text"
                                   class="form-control modern-input border-start-0"
                                   id="patientName"
                                   name="patientName"
                                   value="${receipt.patientName}"
                                   placeholder="Ex: KOUASSI Jean Marie"
                                   required>
                        </div>
                        <div class="invalid-feedback d-flex align-items-center mt-2">
                            <i class="bi bi-x-circle-fill me-2"></i>
                            Veuillez saisir le nom complet du patient
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <label for="patientContact" class="form-label">
                            <i class="bi bi-telephone-forward me-2 text-primary"></i>
                            Contact Téléphonique
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-telephone text-primary"></i>
                            </span>
                            <input type="tel"
                                   class="form-control modern-input border-start-0"
                                   id="patientContact"
                                   name="patientContact"
                                   value="${receipt.patientContact}"
                                   placeholder="07 00 00 00 00"
                                   pattern="[0-9\s]{10,}">
                        </div>
                        <small class="form-text text-muted mt-2 d-flex align-items-center">
                            <i class="bi bi-lightbulb me-1"></i>
                            Format recommandé : 07 XX XX XX XX
                        </small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Service Information -->
        <div class="modern-card mb-5">
            <div class="card-body">
                <h4 class="form-section-title">
                    Consultation & Services
                </h4>

                <div class="mb-4">
                    <label class="form-label required-field mb-3 d-block">
                        <i class="bi bi-clipboard2-pulse me-2"></i>
                        Sélectionnez le type de consultation
                    </label>

                    <div class="service-type-grid-modern">
                        <div class="service-card-modern" onclick="selectService('Consultation générale')">
                            <i class="bi bi-person-hearts"></i>
                            <div class="service-name">Consultation générale</div>
                        </div>
                        <div class="service-card-modern" onclick="selectService('Ophtalmologie')">
                            <i class="bi bi-eye"></i>
                            <div class="service-name">Ophtalmologie</div>
                        </div>
                        <div class="service-card-modern" onclick="selectService('Gynécologie')">
                            <i class="bi bi-gender-female"></i>
                            <div class="service-name">Gynécologie</div>
                        </div>
                        <div class="service-card-modern" onclick="selectService('Échographie')">
                            <i class="bi bi-heart-pulse"></i>
                            <div class="service-name">Échographie</div>
                        </div>
                        <div class="service-card-modern" onclick="selectService('Laboratoire')">
                            <i class="bi bi-activity"></i>
                            <div class="service-name">Analyses laboratoire</div>
                        </div>
                        <div class="service-card-modern" onclick="selectService('Consultation prénatale')">
                            <i class="bi bi-hearts"></i>
                            <div class="service-name">Consultation prénatale</div>
                        </div>
                        <div class="service-card-modern" onclick="selectService('Dermatologie')">
                            <i class="bi bi-person-badge"></i>
                            <div class="service-name">Dermatologie</div>
                        </div>
                        <div class="service-card-modern" onclick="selectService('Dentiste')">
                            <i class="bi bi-tooth"></i>
                            <div class="service-name">Dentisterie</div>
                        </div>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="serviceType" class="form-label required-field">
                        <i class="bi bi-pen me-2 text-primary"></i>
                        Service sélectionné ou personnalisé
                    </label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0">
                            <i class="bi bi-clipboard-check text-primary"></i>
                        </span>
                        <input type="text"
                               class="form-control modern-input border-start-0"
                               id="serviceType"
                               name="serviceType"
                               value="${receipt.serviceType}"
                               placeholder="Cliquez sur une option ci-dessus ou saisissez votre service"
                               required>
                    </div>
                    <div class="invalid-feedback d-flex align-items-center mt-2">
                        <i class="bi bi-x-circle-fill me-2"></i>
                        Veuillez sélectionner ou saisir un type de service
                    </div>
                </div>
            </div>
        </div>

        <!-- Amount Section -->
        <div class="modern-card mb-5">
            <div class="card-body">
                <h4 class="form-section-title">
                    Détails du Paiement
                </h4>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <label for="amount" class="form-label required-field">
                            <i class="bi bi-cash-coin me-2 text-primary"></i>
                            Montant (FCFA)
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-currency-exchange text-primary"></i>
                            </span>
                            <input type="number"
                                   class="form-control modern-input border-start-0"
                                   id="amount"
                                   name="amount"
                                   value="${receipt.amount}"
                                   placeholder="0"
                                   step="1"
                                   min="0"
                                   required
                                   oninput="convertAmountToWords()">
                            <span class="input-group-text bg-light border-start-0">
                                FCFA
                            </span>
                        </div>
                        <div class="invalid-feedback d-flex align-items-center mt-2">
                            <i class="bi bi-x-circle-fill me-2"></i>
                            Veuillez saisir un montant valide
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="amount-display-modern">
                            <label class="form-label fw-bold mb-3 d-block">
                                <i class="bi bi-fonts me-2"></i>
                                Montant en toutes lettres
                            </label>
                            <div id="amountInWords" class="amount-words">
                                <c:choose>
                                    <c:when test="${not empty receipt.amountInWords}">
                                        ${receipt.amountInWords}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Le montant converti s'affichera ici...</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <small class="form-text text-muted mt-3 d-flex align-items-center">
                                <i class="bi bi-arrow-repeat me-1"></i>
                                Conversion automatique lors de la saisie
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Additional Information -->
        <div class="modern-card mb-5">
            <div class="card-body">
                <h4 class="form-section-title">
                    Informations Complémentaires
                </h4>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <label for="servedBy" class="form-label">
                            <i class="bi bi-person-check me-2 text-primary"></i>
                            Agent Caissier
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0">
                                <i class="bi bi-person-workspace text-primary"></i>
                            </span>
                            <input type="text"
                                   class="form-control modern-input border-start-0"
                                   id="servedBy"
                                   name="servedBy"
                                   value="${receipt.servedBy}"
                                   placeholder="Nom de l'agent">
                        </div>
                        <small class="form-text text-muted mt-2 d-flex align-items-center">
                            <i class="bi bi-person-fill-gear me-1"></i>
                            L'agent ayant effectué la transaction
                        </small>
                    </div>

                    <div class="col-md-12 mb-4">
                        <label for="notes" class="form-label">
                            <i class="bi bi-journal-text me-2 text-primary"></i>
                            Notes & Observations
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 align-items-start pt-3">
                                <i class="bi bi-sticky text-primary"></i>
                            </span>
                            <textarea class="form-control modern-input border-start-0"
                                      id="notes"
                                      name="notes"
                                      rows="4"
                                      placeholder="Observations particulières, prescriptions, remarques...">${receipt.notes}</textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Form Actions -->
        <div class="btn-group-modern">
            <a href="${pageContext.request.contextPath}/medical-receipts"
               class="btn btn-outline-modern btn-modern">
                <i class="bi bi-x-lg me-2"></i>Annuler
            </a>
            <button type="reset" class="btn btn-outline-modern btn-modern">
                <i class="bi bi-arrow-clockwise me-2"></i>Réinitialiser
            </button>
            <button type="submit" class="btn btn-modern btn-gradient-primary">
                <i class="bi ${isEdit ? 'bi-check-lg' : 'bi-save'} me-2"></i>
                ${isEdit ? 'Mettre à jour' : 'Créer le reçu'}
            </button>
        </div>
    </form>
</div>

<script>
    // Keep all the JavaScript logic exactly the same
    // Only the CSS design has been modified
    (function() {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    function selectService(serviceName) {
        document.getElementById('serviceType').value = serviceName;
        document.querySelectorAll('.service-card-modern').forEach(card => {
            card.classList.remove('selected');
        });
        event.currentTarget.classList.add('selected');
    }

    window.addEventListener('load', function() {
        const serviceType = document.getElementById('serviceType').value;
        if (serviceType) {
            document.querySelectorAll('.service-card-modern').forEach(card => {
                if (card.textContent.trim().includes(serviceType)) {
                    card.classList.add('selected');
                }
            });
        }

        const amount = document.getElementById('amount').value;
        if (amount && amount > 0) {
            convertAmountToWords();
        }
    });

    function convertAmountToWords() {
        const amount = document.getElementById('amount').value;
        const displayDiv = document.getElementById('amountInWords');

        if (!amount || amount <= 0) {
            displayDiv.innerHTML = '<span class="text-muted">Le montant converti s\'affichera ici...</span>';
            return;
        }

        displayDiv.innerHTML = '<div class="d-flex align-items-center"><div class="spinner-border spinner-border-sm text-primary me-2"></div><span class="text-primary">Conversion en cours...</span></div>';
        displayDiv.classList.add('loading');

        setTimeout(() => {
            // AJAX call would go here - keeping the same structure
            fetch('${pageContext.request.contextPath}/medical-receipts/api/convert-amount', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'amount=' + encodeURIComponent(amount)
            })
                .then(response => response.json())
                .then(data => {
                    displayDiv.textContent = data.amountInWords;
                    displayDiv.classList.remove('loading');
                })
                .catch(error => {
                    displayDiv.innerHTML = '<span class="text-danger">Erreur de conversion</span>';
                    displayDiv.classList.remove('loading');
                });
        }, 300);
    }

    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        });
    }, 5000);

    document.getElementById('patientContact')?.addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length > 0) {
            value = value.match(/.{1,2}/g)?.join(' ') || value;
        }
        e.target.value = value;
    });
</script>