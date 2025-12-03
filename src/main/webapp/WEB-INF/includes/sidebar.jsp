<div class="card mb-4">
  <div class="card-body">
    <h6 class="card-title text-muted mb-3">
      <i class="bi bi-lightning"></i> Accès Rapide
    </h6>
    <div class="list-group list-group-flush">
      <a href="${pageContext.request.contextPath}/sales/new"
         class="list-group-item list-group-item-action border-0 py-2 quick-action">
        <i class="bi bi-cart-plus text-success me-2"></i> Nouvelle Vente
      </a>
      <a href="${pageContext.request.contextPath}/inventory/add"
         class="list-group-item list-group-item-action border-0 py-2 quick-action">
        <i class="bi bi-box-arrow-in-down text-primary me-2"></i> Réapprovisionner
      </a>
      <a href="${pageContext.request.contextPath}/products/add"
         class="list-group-item list-group-item-action border-0 py-2 quick-action">
        <i class="bi bi-plus-circle text-warning me-2"></i> Nouveau Produit
      </a>
      <a href="${pageContext.request.contextPath}/sales/report"
         class="list-group-item list-group-item-action border-0 py-2 quick-action">
        <i class="bi bi-graph-up text-info me-2"></i> Rapports
      </a>
    </div>
  </div>
</div>

<div class="card border-danger alert-card">
  <div class="card-body">
    <h6 class="card-title text-danger">
      <i class="bi bi-bell"></i> Alertes
    </h6>
    <div class="list-group list-group-flush">
      <c:if test="${expiredProducts > 0}">
        <a href="${pageContext.request.contextPath}/inventory/expired"
           class="list-group-item list-group-item-action border-0 py-2 text-danger">
          <i class="bi bi-exclamation-triangle"></i>
            ${expiredProducts} produit(s) expiré(s)
        </a>
      </c:if>
      <c:if test="${lowStockProducts > 0}">
        <a href="${pageContext.request.contextPath}/products?filter=lowstock"
           class="list-group-item list-group-item-action border-0 py-2 text-warning">
          <i class="bi bi-exclamation-circle"></i>
            ${lowStockProducts} produit(s) en rupture
        </a>
      </c:if>
      <c:if test="${expiringSoon > 0}">
        <a href="${pageContext.request.contextPath}/inventory/expiring?days=30"
           class="list-group-item list-group-item-action border-0 py-2 text-info">
          <i class="bi bi-clock-history"></i>
            ${expiringSoon} expire(nt) bientôt
        </a>
      </c:if>
    </div>
  </div>
</div>
