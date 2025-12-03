<%-- /WEB-INF/views/customers/form.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-person-plus text-primary me-2"></i>
                        <c:choose>
                            <c:when test="${not empty customer}">Modifier le Client</c:when>
                            <c:otherwise>Ajouter un Client</c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-info-circle me-1"></i>
                        Remplissez les informations du client
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/customers" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i>Retour à la liste
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Formulaire -->
    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/customers/save" method="post">
                        <c:if test="${not empty customer}">
                            <input type="hidden" name="id" value="${customer.customerId}">
                        </c:if>

                        <div class="row g-3">
                            <!-- Nom et Prénom -->
                            <div class="col-md-6">
                                <label class="form-label">Prénom *</label>
                                <input type="text" class="form-control" name="firstName"
                                       value="${customer.firstName}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Nom *</label>
                                <input type="text" class="form-control" name="lastName"
                                       value="${customer.lastName}" required>
                            </div>

                            <!-- Contact -->
                            <div class="col-md-6">
                                <label class="form-label">Téléphone</label>
                                <input type="tel" class="form-control" name="phone"
                                       value="${customer.phone}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email"
                                       value="${customer.email}">
                            </div>

                            <!-- Date de naissance -->
                            <div class="col-md-6">
                                <label class="form-label">Date de naissance</label>
                                <input type="date" class="form-control" name="dateOfBirth"
                                       value="${customer.dateOfBirth}">
                            </div>

                            <!-- Adresse -->
                            <div class="col-12">
                                <label class="form-label">Adresse</label>
                                <textarea class="form-control" name="address" rows="2">${customer.address}</textarea>
                            </div>

                            <!-- Allergies -->
                            <div class="col-12">
                                <label class="form-label">Allergies / Notes médicales</label>
                                <textarea class="form-control" name="allergies" rows="3">${customer.allergies}</textarea>
                                <small class="text-muted">Listez les allergies médicamenteuses ou alimentaires</small>
                            </div>

                            <!-- Boutons -->
                            <div class="col-12 mt-4">
                                <div class="d-flex justify-content-between">
                                    <button type="reset" class="btn btn-outline-secondary">
                                        <i class="bi bi-x-circle me-2"></i>Annuler
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save me-2"></i>
                                        <c:choose>
                                            <c:when test="${not empty customer}">Modifier le Client</c:when>
                                            <c:otherwise>Ajouter le Client</c:otherwise>
                                        </c:choose>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Informations -->
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-info-circle me-2"></i>Informations</h5>
                </div>
                <div class="card-body">
                    <p>Les champs marqués d'un * sont obligatoires.</p>
                    <p>La saisie des informations médicales est importante pour la sécurité des patients.</p>

                    <div class="alert alert-info mt-3">
                        <h6><i class="bi bi-lightbulb me-2"></i>Conseils</h6>
                        <ul class="mb-0">
                            <li>Vérifiez l'exactitude des coordonnées</li>
                            <li>Notez toutes les allergies importantes</li>
                            <li>La date de naissance permet de calculer l'âge automatiquement</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>