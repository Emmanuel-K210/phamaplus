<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
  <!-- En-tête -->
  <div class="row mb-4">
    <div class="col-12">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h2 class="mb-1">
            <i class="bi bi-truck text-primary me-2"></i>Gestion des Fournisseurs
          </h2>
          <p class="text-muted mb-0">
            <i class="bi bi-building me-1"></i>
            <c:choose>
              <c:when test="${not empty totalSuppliers}">${totalSuppliers}</c:when>
              <c:otherwise>0</c:otherwise>
            </c:choose>
            fournisseurs
          </p>
        </div>
        <a href="${pageContext.request.contextPath}/suppliers/add" class="btn btn-modern btn-gradient-primary">
          <i class="bi bi-plus-circle me-2"></i>Nouveau Fournisseur
        </a>
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

  <!-- Statistiques -->
  <div class="row g-3 mb-4">
    <div class="col-md-3">
      <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h3 class="mb-1">
              <c:choose>
                <c:when test="${not empty totalSuppliers}">${totalSuppliers}</c:when>
                <c:otherwise>0</c:otherwise>
              </c:choose>
            </h3>
            <p class="mb-0 opacity-75">Fournisseurs Totaux</p>
          </div>
          <i class="bi bi-truck stat-icon"></i>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h3 class="mb-1">
              <c:choose>
                <c:when test="${not empty activeSuppliers}">${activeSuppliers}</c:when>
                <c:otherwise>0</c:otherwise>
              </c:choose>
            </h3>
            <p class="mb-0 opacity-75">Fournisseurs Actifs</p>
          </div>
          <i class="bi bi-check-circle stat-icon"></i>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h3 class="mb-1">
              <c:choose>
                <c:when test="${not empty localSuppliers}">${localSuppliers}</c:when>
                <c:otherwise>0</c:otherwise>
              </c:choose>
            </h3>
            <p class="mb-0 opacity-75">Fournisseurs Locaux</p>
          </div>
          <i class="bi bi-geo-alt stat-icon"></i>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h3 class="mb-1">
              <c:choose>
                <c:when test="${not empty productCount}">${productCount}</c:when>
                <c:otherwise>0</c:otherwise>
              </c:choose>
            </h3>
            <p class="mb-0 opacity-75">Produits fournis</p>
          </div>
          <i class="bi bi-box stat-icon"></i>
        </div>
      </div>
    </div>
  </div>

  <!-- Barre de recherche -->
  <div class="row mb-4">
    <div class="col-12">
      <div class="modern-card p-4">
        <form action="${pageContext.request.contextPath}/suppliers" method="get" class="row g-3">
          <div class="col-md-5">
            <div class="input-group">
                            <span class="input-group-text bg-light border-0">
                                <i class="bi bi-search"></i>
                            </span>
              <input type="text" class="form-control modern-input border-start-0"
                     name="search" placeholder="Rechercher par nom ou contact..."
                     value="${param.search}">
            </div>
          </div>
          <div class="col-md-4">
            <select class="form-select modern-input" name="status">
              <option value="">Tous les statuts</option>
              <option value="active" ${param.status == 'active' ? 'selected' : ''}>Actifs seulement</option>
              <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactifs seulement</option>
            </select>
          </div>
          <div class="col-md-3">
            <button type="submit" class="btn btn-modern btn-gradient-primary w-100">
              <i class="bi bi-funnel me-2"></i>Filtrer
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Tableau des fournisseurs -->
  <div class="row">
    <div class="col-12">
      <div class="modern-card p-0">
        <div class="table-responsive">
          <table class="table modern-table mb-0">
            <thead>
            <tr>
              <th><i class="bi bi-building me-2"></i>Fournisseur</th>
              <th><i class="bi bi-person me-2"></i>Contact</th>
              <th><i class="bi bi-telephone me-2"></i>Téléphone</th>
              <th><i class="bi bi-envelope me-2"></i>Email</th>
              <th><i class="bi bi-geo-alt me-2"></i>Localisation</th>
              <th><i class="bi bi-box me-2"></i>Niveau réappro</th>
              <th><i class="bi bi-toggle-on me-2"></i>Statut</th>
              <th class="text-center"><i class="bi bi-gear me-2"></i>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${empty suppliers}">
                <tr>
                  <td colspan="8" class="text-center py-5">
                    <i class="bi bi-truck display-1 text-muted d-block mb-3"></i>
                    <h5 class="text-muted">Aucun fournisseur trouvé</h5>
                    <a href="${pageContext.request.contextPath}/suppliers/add"
                       class="btn btn-modern btn-gradient-primary mt-3">
                      <i class="bi bi-plus-circle me-2"></i>Ajouter votre premier fournisseur
                    </a>
                  </td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="supplier" items="${suppliers}">
                  <tr>
                    <td>
                      <div class="d-flex align-items-center">
                        <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                          <i class="bi bi-building text-primary"></i>
                        </div>
                        <div>
                          <strong>${supplier.supplierName}</strong>
                          <br>
                          <small class="text-muted">ID: #${supplier.supplierId}</small>
                        </div>
                      </div>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty supplier.contactPerson}">
                          ${supplier.contactPerson}
                        </c:when>
                        <c:otherwise>
                          <span class="text-muted">Non spécifié</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty supplier.phone}">
                          <i class="bi bi-telephone text-muted me-1"></i>
                          ${supplier.phone}
                        </c:when>
                        <c:otherwise>
                          <span class="text-muted">Non renseigné</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty supplier.email}">
                          <i class="bi bi-envelope text-muted me-1"></i>
                          ${supplier.email}
                        </c:when>
                        <c:otherwise>
                          <span class="text-muted">Non renseigné</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div class="text-truncate" style="max-width: 120px;">
                        <c:choose>
                          <c:when test="${not empty supplier.city}">
                            <i class="bi bi-geo-alt text-muted me-1"></i>
                            ${supplier.city}
                            <c:if test="${not empty supplier.country}">
                              <br>
                              <small class="text-muted">${supplier.country}</small>
                            </c:if>
                          </c:when>
                          <c:otherwise>
                            <span class="text-muted">Non spécifiée</span>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </td>
                    <td>
                                            <span class="badge badge-modern bg-info">
                                                ${supplier.reorderLevel}
                                            </span>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${supplier.isActive}">
                                                    <span class="badge badge-modern bg-success">
                                                        <i class="bi bi-check-circle me-1"></i>Actif
                                                    </span>
                        </c:when>
                        <c:otherwise>
                                                    <span class="badge badge-modern bg-secondary">
                                                        <i class="bi bi-x-circle me-1"></i>Inactif
                                                    </span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="text-center">
                      <div class="btn-group btn-group-sm" role="group">
                        <!--<a href="${pageContext.request.contextPath}/purchase/create?supplierId=${supplier.supplierId}"
                           class="btn btn-outline-success" title="Nouvelle commande">
                          <i class="bi bi-cart-plus"></i>
                        </a>-->
                        <a href="${pageContext.request.contextPath}/suppliers/edit?id=${supplier.supplierId}"
                           class="btn btn-outline-primary" title="Modifier">
                          <i class="bi bi-pencil"></i>
                        </a>
                        <button type="button" class="btn btn-outline-danger"
                                onclick="confirmDelete(${supplier.supplierId})" title="Supprimer">
                          <i class="bi bi-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <c:if test="${not empty suppliers and not empty totalPages and totalPages > 1}">
          <div class="p-4 border-top">
            <div class="d-flex justify-content-between align-items-center">
              <p class="mb-0 text-muted">
                Affichage de <strong>${suppliers.size()}</strong> fournisseurs sur <strong>${totalSuppliers}</strong>
              </p>
              <nav>
                <ul class="pagination mb-0">
                  <c:if test="${currentPage > 1}">
                    <li class="page-item">
                      <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&status=${param.status}">
                        Précédent
                      </a>
                    </li>
                  </c:if>

                  <c:forEach begin="1" end="${totalPages}" var="page">
                    <c:choose>
                      <c:when test="${page == currentPage}">
                        <li class="page-item active">
                          <span class="page-link">${page}</span>
                        </li>
                      </c:when>
                      <c:otherwise>
                        <li class="page-item">
                          <a class="page-link" href="?page=${page}&search=${param.search}&status=${param.status}">
                              ${page}
                          </a>
                        </li>
                      </c:otherwise>
                    </c:choose>
                  </c:forEach>

                  <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                      <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&status=${param.status}">
                        Suivant
                      </a>
                    </li>
                  </c:if>
                </ul>
              </nav>
            </div>
          </div>
        </c:if>
      </div>
    </div>
  </div>
</div>

<script>
  function confirmDelete(supplierId) {
    if (confirm('Êtes-vous sûr de vouloir supprimer ce fournisseur ?')) {
      window.location.href = '${pageContext.request.contextPath}/suppliers/delete?id=' + supplierId;
    }
  }

  function toggleStatus(supplierId, currentStatus) {
    if (confirm('Êtes-vous sûr de vouloir ' + (currentStatus ? 'désactiver' : 'activer') + ' ce fournisseur ?')) {
      window.location.href = '${pageContext.request.contextPath}/suppliers/toggle-status?id=' + supplierId;
    }
  }
</script>