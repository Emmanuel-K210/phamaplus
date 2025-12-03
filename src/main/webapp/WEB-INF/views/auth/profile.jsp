<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="mb-1">
                <i class="bi bi-person-circle text-primary me-2"></i>Mon Profil
            </h2>
            <p class="text-muted mb-0">Gérez vos informations personnelles et paramètres</p>
        </div>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show modern-card mb-4">
            <i class="bi bi-check-circle-fill me-2"></i>${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show modern-card mb-4">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <!-- Carte de profil -->
        <div class="col-lg-4">
            <div class="modern-card p-4 text-center">
                <div class="user-avatar mx-auto mb-3" style="width: 120px; height: 120px; font-size: 3rem;">
                    ${user.fullName.substring(0,1)}
                </div>
                <h3 class="mb-1">${user.fullName}</h3>
                <p class="text-muted mb-3">@${user.username}</p>

                <div class="badge badge-modern" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                    <i class="bi bi-shield-check me-1"></i>${user.role}
                </div>

                <hr class="my-4">

                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/change-password"
                       class="btn btn-modern btn-gradient-primary">
                        <i class="bi bi-key me-2"></i>Changer le mot de passe
                    </a>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="btn btn-outline-danger">
                        <i class="bi bi-box-arrow-right me-2"></i>Se déconnecter
                    </a>
                </div>
            </div>

            <!-- Statistiques -->
            <div class="modern-card p-4 mt-4">
                <h5 class="mb-4">
                    <i class="bi bi-graph-up text-success me-2"></i>Statistiques
                </h5>

                <div class="d-flex justify-content-between mb-3">
                    <span class="text-muted">
                        <i class="bi bi-calendar-check me-2"></i>Membre depuis
                    </span>
                    <strong>${user.createdAt}</strong>
                </div>

                <div class="d-flex justify-content-between mb-3">
                    <span class="text-muted">
                        <i class="bi bi-clock-history me-2"></i>Dernière connexion
                    </span>
                    <strong>Aujourd'hui</strong>
                </div>

                <div class="d-flex justify-content-between">
                    <span class="text-muted">
                        <i class="bi bi-graph-up-arrow me-2"></i>Sessions
                    </span>
                    <strong>127</strong>
                </div>
            </div>
        </div>

        <!-- Formulaire de mise à jour -->
        <div class="col-lg-8">
            <div class="modern-card p-4">
                <h5 class="mb-4 border-bottom pb-3">
                    <i class="bi bi-person-gear text-primary me-2"></i>
                    Informations du Profil
                </h5>

                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label for="username" class="form-label">
                                <i class="bi bi-at me-1"></i>Nom d'utilisateur
                            </label>
                            <input type="text" class="form-control modern-input" id="username"
                                   value="${user.username}" disabled>
                            <div class="form-text">Le nom d'utilisateur ne peut pas être modifié</div>
                        </div>

                        <div class="col-md-6">
                            <label for="fullName" class="form-label">
                                <i class="bi bi-person me-1"></i>Nom complet <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control modern-input" id="fullName"
                                   name="fullName" value="${user.fullName}" required>
                        </div>



                        <div class="col-md-12">
                            <label for="role" class="form-label">
                                <i class="bi bi-shield-check me-1"></i>Rôle
                            </label>
                            <input type="text" class="form-control modern-input" id="role"
                                   value="${user.role}" disabled>
                            <div class="form-text">Le rôle est défini par l'administrateur</div>
                        </div>
                    </div>

                    <div class="alert alert-info d-flex align-items-center mt-4">
                        <i class="bi bi-info-circle fs-4 me-3"></i>
                        <div>
                            <strong>Note:</strong> Les modifications de profil seront appliquées
                            immédiatement après validation.
                        </div>
                    </div>

                    <div class="d-flex gap-3 justify-content-end pt-4 border-top mt-4">
                        <button type="reset" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-arrow-counterclockwise me-2"></i>Réinitialiser
                        </button>
                        <button type="submit" class="btn btn-modern btn-gradient-success px-4">
                            <i class="bi bi-check-circle me-2"></i>Enregistrer les modifications
                        </button>
                    </div>
                </form>
            </div>

            <!-- Préférences -->
            <div class="modern-card p-4 mt-4">
                <h5 class="mb-4 border-bottom pb-3">
                    <i class="bi bi-sliders text-info me-2"></i>
                    Préférences
                </h5>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">
                            <i class="bi bi-bell me-1"></i>Notifications
                        </label>

                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="stockNotif" checked>
                            <label class="form-check-label" for="stockNotif">
                                Alertes stock faible
                            </label>
                        </div>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="expiryNotif" checked>
                            <label class="form-check-label" for="expiryNotif">
                                Alertes expiration
                            </label>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">
                            <i class="bi bi-palette me-1"></i>Apparence
                        </label>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="theme" id="lightTheme" checked>
                            <label class="form-check-label" for="lightTheme">
                                <i class="bi bi-sun me-1"></i>Mode clair
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="theme" id="darkTheme">
                            <label class="form-check-label" for="darkTheme">
                                <i class="bi bi-moon me-1"></i>Mode sombre
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="theme" id="autoTheme">
                            <label class="form-check-label" for="autoTheme">
                                <i class="bi bi-circle-half me-1"></i>Automatique
                            </label>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end mt-4">
                    <button class="btn btn-modern btn-gradient-info">
                        <i class="bi bi-check-circle me-2"></i>Sauvegarder les préférences
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>