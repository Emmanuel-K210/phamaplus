<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .receipt-card {
        max-width: 800px;
        margin: 0 auto;
    }

    .receipt-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 2rem;
        border-radius: 15px 15px 0 0;
        text-align: center;
    }

    .receipt-body {
        background: white;
        padding: 2rem;
        border-radius: 0 0 15px 15px;
    }

    .info-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem 0;
        border-bottom: 1px solid #e9ecef;
    }

    .info-row:last-child {
        border-bottom: none;
    }

    .info-label {
        font-weight: 600;
        color: #6c757d;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .info-value {
        font-weight: 500;
        color: #212529;
    }

    .receipt-number-display {
        font-size: 1.5rem;
        font-family: 'Courier New', monospace;
        font-weight: bold;
        margin-top: 0.5rem;
    }

    .amount-highlight {
        background: linear-gradient(135deg, rgba(17, 153, 142, 0.1), rgba(56, 239, 125, 0.1));
        padding: 1.5rem;
        border-radius: 10px;
        margin: 1.5rem 0;
        text-align: center;
        border: 2px solid #11998e;
    }

    .amount-value {
        font-size: 2.5rem;
        font-weight: bold;
        color: #11998e;
    }

    .amount-words-display {
        font-style: italic;
        color: #6c757d;
        margin-top: 0.5rem;
    }

    .action-buttons {
        display: flex;
        gap: 1rem;
        margin-top: 2rem;
        flex-wrap: wrap;
    }

    .action-buttons .btn {
        flex: 1;
        min-width: 150px;
    }

    @media print {
        .action-buttons, .page-header, .navbar, .sidebar {
            display: none !important;
        }

        .receipt-card {
            box-shadow: none !important;
        }
    }
</style>

<div class="container-fluid">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <i class="bi bi-file-text me-2"></i>Détails du Reçu Médical
            </h2>
            <p class="text-muted mb-0">Consultation complète des informations du reçu</p>
        </div>
        <a href="${pageContext.request.contextPath}/medical-receipts" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Retour à la liste
        </a>
    </div>

    <!-- Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>
                ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <!-- Receipt Card -->
    <div class="receipt-card">
        <div class="modern-card">
            <!-- Receipt Header -->
            <div class="receipt-header">
                <h3 class="mb-0">
                    <i class="bi bi-hospital me-2"></i>
                    CENTRE DE SANTÉ URBAIN
                </h3>
                <p class="mb-0 mt-1">Reçu de Consultation Médicale</p>
                <div class="receipt-number-display">${receipt.receiptNumber}</div>
            </div>

            <!-- Receipt Body -->
            <div class="receipt-body">
                <!-- Date Information -->
                <div class="info-row">
                    <div class="info-label">
                        <i class="bi bi-calendar3"></i>
                        Date d'émission
                    </div>
                    <div class="info-value">${receipt.receiptDate}</div>
                </div>

                <!-- Patient Information Section -->
                <h5 class="mt-4 mb-3 text-primary">
                    <i class="bi bi-person-vcard me-2"></i>
                    Informations du Patient
                </h5>

                <div class="info-row">
                    <div class="info-label">
                        <i class="bi bi-person"></i>
                        Nom et Prénoms
                    </div>
                    <div class="info-value">${receipt.patientName}</div>
                </div>

                <c:if test="${not empty receipt.patientContact}">
                    <div class="info-row">
                        <div class="info-label">
                            <i class="bi bi-telephone"></i>
                            Contact
                        </div>
                        <div class="info-value">${receipt.patientContact}</div>
                    </div>
                </c:if>

                <!-- Service Information Section -->
                <h5 class="mt-4 mb-3 text-primary">
                    <i class="bi bi-clipboard2-pulse me-2"></i>
                    Nature de la Prestation
                </h5>

                <div class="info-row">
                    <div class="info-label">
                        <i class="bi bi-heart-pulse"></i>
                        Type de service
                    </div>
                    <div class="info-value">
                        <span class="badge badge-modern bg-light text-dark" style="font-size: 1rem;">
                            ${receipt.serviceType}
                        </span>
                    </div>
                </div>

                <!-- Amount Section -->
                <div class="amount-highlight">
                    <h5 class="mb-2">
                        <i class="bi bi-cash-stack me-2"></i>
                        Montant Total
                    </h5>
                    <div class="amount-value">${receipt.formattedAmount}</div>
                    <c:if test="${not empty receipt.amountInWords}">
                        <div class="amount-words-display">
                                ${receipt.amountInWords}
                        </div>
                    </c:if>
                </div>

                <!-- Additional Information -->
                <c:if test="${not empty receipt.servedBy}">
                    <div class="info-row">
                        <div class="info-label">
                            <i class="bi bi-person-check"></i>
                            Servi par
                        </div>
                        <div class="info-value">${receipt.servedBy}</div>
                    </div>
                </c:if>

                <c:if test="${not empty receipt.notes}">
                    <h5 class="mt-4 mb-3 text-primary">
                        <i class="bi bi-journal-text me-2"></i>
                        Notes / Observations
                    </h5>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i>
                            ${receipt.notes}
                    </div>
                </c:if>

                <!-- Validity Notice -->
                <div class="alert alert-warning mt-3">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    <strong>Note importante :</strong> Ce reçu est valable pour 7 jours à compter de sa date d'émission.
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/medical-receipts/print?id=${receipt.receiptId}"
                       class="btn btn-modern btn-gradient-primary"
                       target="_blank">
                        <i class="bi bi-printer me-2"></i>Imprimer le reçu
                    </a>
                    <a href="${pageContext.request.contextPath}/medical-receipts/edit?id=${receipt.receiptId}"
                       class="btn btn-warning">
                        <i class="bi bi-pencil me-2"></i>Modifier
                    </a>
                    <button type="button"
                            class="btn btn-danger"
                            onclick="confirmDelete()">
                        <i class="bi bi-trash me-2"></i>Supprimer
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Confirmer la suppression
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Êtes-vous sûr de vouloir supprimer le reçu <strong>${receipt.receiptNumber}</strong> ?</p>
                <p class="text-danger mb-0">
                    <i class="bi bi-info-circle me-1"></i>
                    Cette action est irréversible.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    Annuler
                </button>
                <form method="post" action="${pageContext.request.contextPath}/medical-receipts" class="d-inline">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="${receipt.receiptId}">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash me-2"></i>Supprimer définitivement
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete() {
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    }

    // Auto-dismiss alerts
    setTimeout(function() {
        document.querySelectorAll('.alert').forEach(alert => {
            if (!alert.classList.contains('alert-warning') && !alert.classList.contains('alert-info')) {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            }
        });
    }, 5000);
</script>