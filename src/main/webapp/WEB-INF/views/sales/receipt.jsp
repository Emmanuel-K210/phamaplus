<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="container-fluid px-0">
    <!-- En-tête -->
    <div class="modern-header bg-gradient-primary text-white p-4 mb-4">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="mb-1">
                        <i class="bi bi-receipt me-3"></i>Reçu de Vente
                    </h1>
                    <p class="mb-0 text-white-50">Transaction #${sale.saleId}</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/sales" class="btn btn-light me-2">
                        <i class="bi bi-arrow-left me-2"></i>Retour aux ventes
                    </a>
                    <button type="button" class="btn btn-light" onclick="window.print()">
                        <i class="bi bi-printer me-2"></i>Imprimer
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Message de succès -->
    <c:if test="${not empty param.success}">
        <div class="container mb-4">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <div class="d-flex align-items-center">
                    <i class="bi bi-check-circle-fill fs-4 me-3"></i>
                    <div>
                        <h5 class="alert-heading mb-1">Vente enregistrée avec succès!</h5>
                        <p class="mb-0">La transaction a été enregistrée et le stock a été mis à jour.</p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </c:if>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <!-- Carte du reçu -->
                <div class="card modern-card border-0 shadow-lg" id="receipt">
                    <div class="card-body p-5">
                        <!-- Informations de la vente -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h5 class="text-primary mb-3">
                                    <i class="bi bi-info-circle me-2"></i>Informations Vente
                                </h5>
                                <table class="table table-borderless table-sm">
                                    <tr>
                                        <td class="text-muted">N° Transaction:</td>
                                        <td class="fw-bold">#${sale.saleId}</td>
                                    </tr>
                                    <tr>
                                        <td class="text-muted">Date:</td>
                                        <td class="fw-bold">

                                            <c:choose>
                                                <c:when test="${not empty sale.saleDate}">
                                                    ${fn:substring(sale.saleDate, 0, 10)} ${fn:substring(sale.saleDate, 11, 16)}
                                                </c:when>
                                                <c:otherwise>
                                                    Non spécifié
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="text-muted">Servi par:</td>
                                        <td class="fw-bold">${sale.servedBy}</td>
                                    </tr>
                                    <tr>
                                        <td class="text-muted">Mode de paiement:</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${sale.paymentMethod == 'cash'}">
                                                    <span class="badge bg-success">
                                                        <i class="bi bi-cash me-1"></i>Espèces
                                                    </span>
                                                </c:when>
                                                <c:when test="${sale.paymentMethod == 'card'}">
                                                    <span class="badge bg-primary">
                                                        <i class="bi bi-credit-card me-1"></i>Carte
                                                    </span>
                                                </c:when>
                                                <c:when test="${sale.paymentMethod == 'mobile'}">
                                                    <span class="badge bg-warning">
                                                        <i class="bi bi-phone me-1"></i>Mobile
                                                    </span>
                                                </c:when>
                                                <c:when test="${sale.paymentMethod == 'insurance'}">
                                                    <span class="badge bg-info">
                                                        <i class="bi bi-shield-check me-1"></i>Assurance
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                            <div class="col-md-6">
                                <h5 class="text-primary mb-3">
                                    <i class="bi bi-person-circle me-2"></i>Informations Client
                                </h5>
                                <c:choose>
                                    <c:when test="${not empty sale.customerName}">
                                        <div class="bg-light p-3 rounded">
                                            <p class="mb-1"><strong>${sale.customerName}</strong></p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-light p-3 rounded">
                                            <p class="text-muted mb-0">
                                                <i class="bi bi-person-x me-2"></i>Vente anonyme
                                            </p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Articles vendus -->
                        <h5 class="text-primary mb-3">
                            <i class="bi bi-cart-check me-2"></i>Articles
                        </h5>
                        <div class="table-responsive mb-4">
                            <table class="table table-bordered">
                                <thead class="table-light">
                                <tr>
                                    <th>Produit</th>
                                    <th class="text-center">Lot</th>
                                    <th class="text-center">Prix Unit.</th>
                                    <th class="text-center">Qté</th>
                                    <th class="text-end">Total</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${items}">
                                    <tr>
                                        <td>
                                            <strong>${item.productName}</strong>
                                        </td>
                                        <td class="text-center">
                                            <small class="text-muted">${item.batchNumber}</small>
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0"/> FCFA
                                        </td>
                                        <td class="text-center">
                                            <strong>${item.quantity}</strong>
                                        </td>
                                        <td class="text-end">
                                            <strong>
                                                <fmt:formatNumber value="${item.lineTotal}" pattern="#,##0"/> FCFA
                                            </strong>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Totaux -->
                        <div class="row justify-content-end">
                            <div class="col-md-5">
                                <table class="table table-borderless">
                                    <tr>
                                        <td class="text-muted">Sous-total:</td>
                                        <td class="text-end fw-bold">
                                            <fmt:formatNumber value="${sale.subtotal}" pattern="#,##0"/> FCFA
                                        </td>
                                    </tr>
                                    <c:if test="${sale.discountAmount > 0}">
                                        <tr>
                                            <td class="text-muted">Remise:</td>
                                            <td class="text-end text-danger">
                                                - <fmt:formatNumber value="${sale.discountAmount}" pattern="#,##0"/> FCFA
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:if test="${sale.taxAmount > 0}">
                                        <tr>
                                            <td class="text-muted">Taxes:</td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${sale.taxAmount}" pattern="#,##0"/> FCFA
                                            </td>
                                        </tr>
                                    </c:if>
                                    <tr class="border-top">
                                        <td class="text-primary"><h4>TOTAL:</h4></td>
                                        <td class="text-end">
                                            <h3 class="text-primary mb-0">
                                                <fmt:formatNumber value="${sale.totalAmount}" pattern="#,##0"/> FCFA
                                            </h3>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <!-- Notes -->
                        <c:if test="${not empty sale.notes}">
                            <div class="alert alert-info mt-4">
                                <h6 class="mb-2"><i class="bi bi-sticky me-2"></i>Notes:</h6>
                                <p class="mb-0">${sale.notes}</p>
                            </div>
                        </c:if>

                        <!-- Pied de page -->
                        <div class="text-center mt-5 pt-4 border-top">
                            <p class="text-muted mb-2">
                                Merci de votre confiance!
                            </p>
                            <p class="small text-muted mb-0">
                                Ce reçu fait foi de transaction. Conservez-le précieusement.<br>
                                Pour toute réclamation, présentez ce reçu dans un délai de 7 jours.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="text-center mt-4 no-print">
                    <a href="${pageContext.request.contextPath}/sales/new" class="btn btn-primary btn-lg me-2">
                        <i class="bi bi-plus-circle me-2"></i>Nouvelle Vente
                    </a>
                    <a href="${pageContext.request.contextPath}/sales" class="btn btn-outline-secondary btn-lg me-2">
                        <i class="bi bi-list me-2"></i>Liste des Ventes
                    </a>

                    <!-- Bouton impression thermique -->
                    <a href="${pageContext.request.contextPath}/sales/view?id=${sale.saleId}&printThermal=true"
                       class="btn btn-success btn-lg">
                        <i class="bi bi-receipt me-2"></i>Imprimer Ticket Thermique
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Style pour impression thermique -->
<style>
    .modern-header {
        background: linear-gradient(135deg, #0d6efd 0%, #38ef7d 100%);
        border-radius: 0 0 20px 20px;
    }

    .modern-card {
        border-radius: 12px;
    }

    /* Style pour l'impression ticket thermique */
    @media print {
        .modern-header,
        .no-print,
        .btn,
        .alert,
        .table-light,
        .text-primary {
            display: none !important;
        }

        .card {
            border: none !important;
            box-shadow: none !important;
        }

        body {
            background: white !important;
            font-family: 'Courier New', monospace !important;
            font-size: 12px !important;
            line-height: 1 !important;
            padding: 0 !important;
            margin: 0 !important;
            width: 80mm !important;
        }

        .container, .container-fluid {
            max-width: 80mm !important;
            padding: 0 !important;
            margin: 0 !important;
        }

        .col-lg-10, .row {
            max-width: 80mm !important;
            margin: 0 !important;
        }

        h1, h2, h3, h4, h5, h6 {
            font-size: 14px !important;
            margin: 2px 0 !important;
            font-weight: bold !important;
        }

        .card-body {
            padding: 5px !important;
        }

        table {
            width: 100% !important;
            font-size: 10px !important;
            border-collapse: collapse !important;
        }

        th, td {
            padding: 2px !important;
            border: 1px solid #000 !important;
        }

        .table-borderless td, .table-borderless th {
            border: none !important;
        }

        .text-center {
            text-align: center !important;
        }

        .text-end {
            text-align: right !important;
        }

        .text-muted {
            color: #000 !important;
        }

        hr {
            margin: 3px 0 !important;
            border-color: #000 !important;
        }

        .border-top {
            border-top: 1px solid #000 !important;
        }

        .text-primary {
            color: #000 !important;
        }
    }
</style>

<c:if test="${not empty param.print and param.print == 'true'}">
    <script>
        window.onload = function() {
            setTimeout(function() {
                window.print();
            }, 500);
        };
    </script>
</c:if>