<%-- /WEB-INF/views/customers/view.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-person-circle text-primary me-2"></i>Profil Client
                    </h2>
                    <p class="text-muted mb-0">
                        Client #${customer.customerId}
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/sales/create?customerId=${customer.customerId}"
                       class="btn btn-modern btn-gradient-success">
                        <i class="bi bi-cart-plus me-2"></i>Nouvelle Vente
                    </a>
                    <a href="${pageContext.request.contextPath}/customers/edit?id=${customer.customerId}"
                       class="btn btn-modern btn-gradient-primary">
                        <i class="bi bi-pencil me-2"></i>Modifier
                    </a>
                    <a href="${pageContext.request.contextPath}/customers"
                       class="btn btn-modern btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Retour
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Colonne principale -->
        <div class="col-lg-8">
            <!-- Informations principales -->
            <div class="modern-card p-4 mb-4">
                <div class="row">
                    <div class="col-md-3 text-center mb-3 mb-md-0">
                        <div class="bg-primary bg-opacity-10 rounded-circle d-inline-flex align-items-center justify-content-center"
                             style="width: 100px; height: 100px;">
                            <i class="bi bi-person-fill text-primary" style="font-size: 3rem;"></i>
                        </div>
                        <div class="mt-3">
                            <c:if test="${not empty customer.allergies}">
                                <span class="badge badge-modern bg-warning text-dark">
                                    <i class="bi bi-exclamation-triangle me-1"></i>Allergies
                                </span>
                            </c:if>
                        </div>
                    </div>
                    <div class="col-md-9">
                        <h3 class="mb-3">${customer.firstName} ${customer.lastName}</h3>

                        <div class="row g-3">
                            <div class="col-sm-6">
                                <p class="mb-1 text-muted small">Téléphone</p>
                                <p class="mb-0">
                                    <i class="bi bi-telephone me-2"></i>
                                    <c:choose>
                                        <c:when test="${not empty customer.phone}">
                                            <a href="tel:${customer.phone}" class="text-decoration-none">
                                                    ${customer.phone}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Non renseigné</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <div class="col-sm-6">
                                <p class="mb-1 text-muted small">Email</p>
                                <p class="mb-0">
                                    <i class="bi bi-envelope me-2"></i>
                                    <c:choose>
                                        <c:when test="${not empty customer.email}">
                                            <a href="mailto:${customer.email}" class="text-decoration-none">
                                                    ${customer.email}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Non renseigné</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <div class="col-sm-6">
                                <p class="mb-1 text-muted small">Date de naissance</p>
                                <p class="mb-0">
                                    <i class="bi bi-calendar me-2"></i>
                                    <c:choose>
                                        <c:when test="${not empty customer.dateOfBirth}">
                                            ${customer.dateOfBirth}
                                            <span class="badge bg-light text-dark ms-2">
                                                <fmt:formatNumber value="${customer.age}" pattern="0"/> ans
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Non renseignée</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <div class="col-sm-6">
                                <p class="mb-1 text-muted small">Client depuis</p>
                                <p class="mb-0">
                                    <i class="bi bi-clock me-2"></i>
                                    <c:if test="${not empty customer.createdAt}">
                                        <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy"/>
                                    </c:if>
                                </p>
                            </div>

                            <div class="col-12">
                                <p class="mb-1 text-muted small">Adresse</p>
                                <p class="mb-0">
                                    <i class="bi bi-house me-2"></i>
                                    <c:choose>
                                        <c:when test="${not empty customer.address}">
                                            ${customer.address}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Non renseignée</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Informations médicales -->
            <div class="modern-card p-4 mb-4">
                <h5 class="mb-3">
                    <i class="bi bi-heart-pulse text-danger me-2"></i>Informations Médicales
                </h5>

                <div class="row">
                    <div class="col-12">
                        <div class="alert ${not empty customer.allergies ? 'alert-warning' : 'alert-success'} mb-0">
                            <div class="d-flex align-items-start">
                                <i class="bi ${not empty customer.allergies ? 'bi-exclamation-triangle-fill' : 'bi-check-circle-fill'} me-2 mt-1"></i>
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">Allergies</h6>
                                    <c:choose>
                                        <c:when test="${not empty customer.allergies}">
                                            <p class="mb-0">${customer.allergies}</p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="mb-0">Aucune allergie connue</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Historique des achats -->
            <div class="modern-card p-4">
                <h5 class="mb-3">
                    <i class="bi bi-bag text-success me-2"></i>Historique des Achats
                </h5>

                <div class="table-responsive">
                    <table class="table modern-table">
                        <thead>
                        <tr>
                            <th>Date</th>
                            <th>N° Vente</th>
                            <th>Montant</th>
                            <th>Articles</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td colspan="5" class="text-center py-4 text-muted">
                                <i class="bi bi-inbox display-4 d-block mb-2"></i>
                                Aucun achat enregistré
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Colonne latérale -->
        <div class="col-lg-4">
            <!-- Statistiques -->
            <div class="modern-card p-3 mb-3">
                <h6 class="mb-3">
                    <i class="bi bi-graph-up text-info me-2"></i>Statistiques
                </h6>

                <div class="list-group list-group-flush">
                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                        <span class="text-muted">Total des achats</span>
                        <strong>0 Ar</strong>
                    </div>
                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                        <span class="text-muted">Nombre de visites</span>
                        <strong>0</strong>
                    </div>
                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                        <span class="text-muted">Dernière visite</span>
                        <strong class="text-muted">-</strong>
                    </div>
                    <div class="list-group-item d-flex justify-content-between align-items-center px-0">
                        <span class="text-muted">Panier moyen</span>
                        <strong>0 Ar</strong>
                    </div>
                </div>
            </div>

            <!-- Actions rapides -->
            <div class="modern-card p-3 mb-3">
                <h6 class="mb-3">
                    <i class="bi bi-lightning text-warning me-2"></i>Actions Rapides
                </h6>

                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/sales/create?customerId=${customer.customerId}"
                       class="btn btn-modern btn-gradient-success btn-sm">
                        <i class="bi bi-cart-plus me-2"></i>Nouvelle Vente
                    </a>
                    <a href="${pageContext.request.contextPath}/prescriptions/create?customerId=${customer.customerId}"
                       class="btn btn-modern btn-gradient-info btn-sm">
                        <i class="bi bi-file-medical me-2"></i>Ajouter Ordonnance
                    </a>
                    <a href="tel:${customer.phone}"
                       class="btn btn-modern btn-outline-primary btn-sm">
                        <i class="bi bi-telephone me-2"></i>Appeler
                    </a>
                    <a href="mailto:${customer.email}"
                       class="btn btn-modern btn-outline-primary btn-sm">
                        <i class="bi bi-envelope me-2"></i>Envoyer Email
                    </a>
                </div>
            </div>

            <!-- Notes -->
            <div class="modern-card p-3 mb-3">
                <h6 class="mb-3">
                    <i class="bi bi-sticky text-warning me-2"></i>Notes
                </h6>

                <textarea class="form-control modern-input"
                          rows="4"
                          placeholder="Ajouter une note sur ce client..."></textarea>
                <button class="btn btn-modern btn-gradient-primary btn-sm w-100 mt-2">
                    <i class="bi bi-save me-1"></i>Enregistrer
                </button>
            </div>

            <!-- Informations système -->
            <div class="modern-card p-3">
                <h6 class="mb-3">
                    <i class="bi bi-info-circle text-secondary me-2"></i>Informations Système
                </h6>

                <div class="small">
                    <p class="mb-2">
                        <strong>ID Client:</strong> ${customer.customerId}
                    </p>
                    <p class="mb-2">
                        <strong>Créé le:</strong>
                        <c:if test="${not empty customer.createdAt}">
                            <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy à HH:mm"/>
                        </c:if>
                    </p>
                    <p class="mb-0">
                        <strong>Modifié le:</strong>
                        <c:if test="${not empty customer.updatedAt}">
                            <fmt:formatDate value="${customer.updatedAt}" pattern="dd/MM/yyyy à HH:mm"/>
                        </c:if>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Fonction pour imprimer le profil
    function printProfile() {
        window.print();
    }

    // Styles d'impression
    const style = document.createElement('style');
    style.textContent = `
    @media print {
        .btn, .no-print {
            display: none !important;
        }
        .modern-card {
            break-inside: avoid;
        }
    }
`;
    document.head.appendChild(style);
</script>

<style>
    .badge-modern {
        padding: 0.35rem 0.65rem;
        font-weight: 500;
        font-size: 0.75rem;
    }

    .list-group-item {
        border: none;
        padding: 0.75rem 0;
    }

    .list-group-item:not(:last-child) {
        border-bottom: 1px solid rgba(0,0,0,0.05);
    }
</style>