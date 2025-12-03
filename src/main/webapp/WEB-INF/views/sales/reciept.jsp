<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid py-4">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <!-- Boutons d'action -->
            <div class="d-flex justify-content-between mb-3 no-print">
                <a href="${pageContext.request.contextPath}/sales" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Retour aux ventes
                </a>
                <div>
                    <button onclick="window.print()" class="btn btn-primary">
                        <i class="bi bi-printer"></i> Imprimer
                    </button>
                    <a href="${pageContext.request.contextPath}/sales/new" class="btn btn-success">
                        <i class="bi bi-plus-circle"></i> Nouvelle vente
                    </a>
                </div>
            </div>

            <!-- Reçu -->
            <div class="card shadow-lg" id="receipt">
                <div class="card-body p-5">
                    <!-- En-tête de la pharmacie -->
                    <div class="text-center mb-4">
                        <h2 class="text-primary mb-1">
                            <i class="bi bi-capsule"></i> PHARMAPLUS
                        </h2>
                        <p class="mb-0">Pharmacie Moderne et Fiable</p>
                        <p class="text-muted small mb-0">
                            123 Avenue de la République, Abidjan, Côte d'Ivoire<br>
                            Tél: +225 27 20 30 40 50 | Email: contact@pharmaplus.ci<br>
                            RCCM: CI-ABJ-2024-B-12345
                        </p>
                    </div>

                    <hr class="my-4">

                    <!-- Informations de la vente -->
                    <div class="row mb-4">
                        <div class="col-6">
                            <h5 class="text-primary">REÇU DE VENTE</h5>
                            <p class="mb-1"><strong>N° Vente:</strong> #${sale.saleId}</p>
                            <p class="mb-1">
                                <strong>Date:</strong>
                                <fmt:formatDate value="${sale.saleDate}" pattern="dd/MM/yyyy 'à' HH:mm"/>
                            </p>
                            <p class="mb-1"><strong>Servi par:</strong> ${sale.servedBy}</p>
                        </div>
                        <div class="col-6 text-end">
                            <c:if test="${not empty sale.customerName}">
                                <h6 class="text-muted">CLIENT</h6>
                                <p class="mb-1"><strong>${sale.customerName}</strong></p>
                                <c:if test="${not empty sale.customerPhone}">
                                    <p class="mb-1"><small>${sale.customerPhone}</small></p>
                                </c:if>
                                <c:if test="${not empty sale.customerEmail}">
                                    <p class="mb-1"><small>${sale.customerEmail}</small></p>
                                </c:if>
                            </c:if>
                        </div>
                    </div>

                    <!-- Articles vendus -->
                    <div class="table-responsive mb-4">
                        <table class="table table-bordered">
                            <thead class="table-light">
                            <tr>
                                <th style="width: 5%;">#</th>
                                <th style="width: 45%;">Produit</th>
                                <th style="width: 15%;" class="text-center">Quantité</th>
                                <th style="width: 17%;" class="text-end">Prix Unit.</th>
                                <th style="width: 18%;" class="text-end">Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:set var="subtotal" value="0"/>
                            <c:forEach var="item" items="${items}" varStatus="status">
                                <tr>
                                    <td class="text-center">${status.index + 1}</td>
                                    <td>
                                        <strong>${item.productName}</strong>
                                        <c:if test="${not empty item.productDescription}">
                                            <br><small class="text-muted">${item.productDescription}</small>
                                        </c:if>
                                    </td>
                                    <td class="text-center">${item.quantity}</td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0"/> FCFA
                                    </td>
                                    <td class="text-end">
                                        <strong>
                                            <fmt:formatNumber value="${item.lineTotal}" pattern="#,##0"/> FCFA
                                        </strong>
                                    </td>
                                </tr>
                                <c:set var="subtotal" value="${subtotal + item.lineTotal}"/>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Totaux -->
                    <div class="row">
                        <div class="col-7"></div>
                        <div class="col-5">
                            <table class="table table-sm">
                                <tr>
                                    <td><strong>Sous-total:</strong></td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${subtotal}" pattern="#,##0"/> FCFA
                                    </td>
                                </tr>
                                <c:if test="${sale.discount > 0}">
                                    <tr>
                                        <td><strong>Remise:</strong></td>
                                        <td class="text-end text-danger">
                                            - <fmt:formatNumber value="${sale.discount}" pattern="#,##0"/> FCFA
                                        </td>
                                    </tr>
                                </c:if>
                                <tr class="table-primary">
                                    <td><h5 class="mb-0">TOTAL À PAYER:</h5></td>
                                    <td class="text-end">
                                        <h4 class="mb-0 text-primary">
                                            <fmt:formatNumber value="${sale.totalAmount}" pattern="#,##0"/> FCFA
                                        </h4>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Mode de paiement:</strong></td>
                                    <td class="text-end">
                                        <span class="badge ${sale.paymentMethod eq 'cash' ? 'bg-success' :
                                                             sale.paymentMethod eq 'card' ? 'bg-primary' :
                                                             sale.paymentMethod eq 'mobile' ? 'bg-warning' :
                                                             sale.paymentMethod eq 'insurance' ? 'bg-info' : 'bg-secondary'}">
                                            <c:choose>
                                                <c:when test="${sale.paymentMethod eq 'cash'}">ESPÈCES</c:when>
                                                <c:when test="${sale.paymentMethod eq 'card'}">CARTE BANCAIRE</c:when>
                                                <c:when test="${sale.paymentMethod eq 'mobile'}">MOBILE MONEY</c:when>
                                                <c:when test="${sale.paymentMethod eq 'insurance'}">ASSURANCE</c:when>
                                                <c:otherwise>AUTRE</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Informations supplémentaires -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="alert alert-info">
                                <h6 class="alert-heading">
                                    <i class="bi bi-info-circle"></i> Informations importantes
                                </h6>
                                <ul class="mb-0 small">
                                    <li>Ce reçu fait office de facture</li>
                                    <li>Aucun échange ou remboursement après 7 jours</li>
                                    <li>Les médicaments doivent être conservés selon les recommandations</li>
                                    <li>En cas de problème, contactez-nous au +225 27 20 30 40 50</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Code-barres et signature -->
                    <div class="row mt-4">
                        <div class="col-6">
                            <div class="text-center">
                                <svg id="barcode"></svg>
                                <p class="small text-muted mt-2">Code vente: ${sale.saleId}</p>
                            </div>
                        </div>
                        <div class="col-6 text-center">
                            <p class="mb-5">Signature du vendeur</p>
                            <div class="border-top d-inline-block" style="width: 200px;"></div>
                            <p class="small text-muted mt-1">${sale.servedBy}</p>
                        </div>
                    </div>

                    <!-- Pied de page -->
                    <div class="text-center mt-5">
                        <p class="text-muted small mb-0">
                            Merci de votre confiance ! Prenez soin de vous.
                        </p>
                        <p class="text-muted small mb-0">
                            <i class="bi bi-globe"></i> www.pharmaplus.ci |
                            <i class="bi bi-facebook"></i> @pharmaplus |
                            <i class="bi bi-instagram"></i> @pharmaplus_ci
                        </p>
                    </div>
                </div>
            </div>

            <!-- Actions supplémentaires (non imprimées) -->
            <div class="card mt-3 no-print">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <button class="btn btn-outline-primary w-100" onclick="sendByEmail()">
                                <i class="bi bi-envelope"></i> Envoyer par Email
                            </button>
                        </div>
                        <div class="col-md-4">
                            <button class="btn btn-outline-success w-100" onclick="sendByWhatsApp()">
                                <i class="bi bi-whatsapp"></i> Envoyer par WhatsApp
                            </button>
                        </div>
                        <div class="col-md-4">
                            <button class="btn btn-outline-danger w-100" onclick="downloadPDF()">
                                <i class="bi bi-file-pdf"></i> Télécharger PDF
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>
<script>
    // Générer le code-barres
    JsBarcode("#barcode", "${sale.saleId}", {
        format: "CODE128",
        width: 2,
        height: 50,
        displayValue: false
    });

    function sendByEmail() {
        const customerEmail = '${sale.customerEmail}';
        if (customerEmail) {
            window.location.href = 'mailto:' + customerEmail +
                '?subject=Reçu de vente PharmaPlus #${sale.saleId}' +
                '&body=Veuillez trouver ci-joint votre reçu de vente.';
        } else {
            alert('Aucune adresse email associée à ce client');
        }
    }

    function sendByWhatsApp() {
        const phone = '${sale.customerPhone}';
        if (phone) {
            const message = 'Bonjour, voici votre reçu de vente PharmaPlus #${sale.saleId}. ' +
                'Montant: ${sale.totalAmount} FCFA. Merci de votre confiance!';
            window.open('https://wa.me/' + phone.replace(/\D/g, '') + '?text=' + encodeURIComponent(message));
        } else {
            alert('Aucun numéro de téléphone associé à ce client');
        }
    }

    function downloadPDF() {
        alert('Fonctionnalité de téléchargement PDF en cours de développement');
        // À implémenter avec une librairie comme jsPDF
    }

    // Auto-print si paramètre print=true
    if (window.location.search.includes('print=true')) {
        setTimeout(() => window.print(), 500);
    }
</script>

<style>
    @media print {
        .no-print {
            display: none !important;
        }

        body {
            margin: 0;
            padding: 0;
        }

        #receipt {
            box-shadow: none !important;
            border: none !important;
            page-break-after: always;
        }

        .card {
            border: none !important;
        }
    }

    #receipt {
        background: white;
    }
</style>