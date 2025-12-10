<%-- /WEB-INF/views/reports/list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-graph-up text-primary me-2"></i>Rapports et Analyses
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-file-earmark-text me-1"></i>
                        Générez et consultez les rapports de votre pharmacie
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/reports/generate"
                       class="btn btn-modern btn-gradient-primary">
                        <i class="bi bi-plus-circle me-2"></i>Nouveau Rapport
                    </a>
                </div>
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

    <!-- Statistiques rapides -->
    <div class="row g-3 mb-4">
        <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/reports?filter=SALES"
               class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-1">
                                <i class="bi bi-cart me-2"></i>
                            </h3>
                            <p class="mb-0 opacity-75">Ventes</p>
                        </div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/reports?filter=STOCK"
               class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-1">
                                <i class="bi bi-box-seam me-2"></i>
                            </h3>
                            <p class="mb-0 opacity-75">Stock</p>
                        </div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/reports?filter=CUSTOMER"
               class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-1">
                                <i class="bi bi-people me-2"></i>
                            </h3>
                            <p class="mb-0 opacity-75">Clients</p>
                        </div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/reports?filter=FINANCIAL"
               class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-1">
                                <i class="bi bi-cash-stack me-2"></i>
                            </h3>
                            <p class="mb-0 opacity-75">Financier</p>
                        </div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-2">
            <a href="${pageContext.request.contextPath}/reports?filter=PRESCRIPTION"
               class="text-decoration-none">
                <div class="stat-card" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h3 class="mb-1">
                                <i class="bi bi-file-medical me-2"></i>
                            </h3>
                            <p class="mb-0 opacity-75">Ordonnances</p>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    </div>

    <!-- Tableau des rapports -->
    <div class="row">
        <div class="col-12">
            <div class="modern-card p-0">
                <div class="table-responsive">
                    <table class="table modern-table mb-0">
                        <thead>
                        <tr>
                            <th><i class="bi bi-hash me-2"></i>ID</th>
                            <th><i class="bi bi-file-earmark-text me-2"></i>Nom du Rapport</th>
                            <th><i class="bi bi-tag me-2"></i>Type</th>
                            <th><i class="bi bi-calendar me-2"></i>Période</th>
                            <th><i class="bi bi-clock me-2"></i>Généré le</th>
                            <th><i class="bi bi-filetype-pdf me-2"></i>Format</th>
                            <th><i class="bi bi-info-circle me-2"></i>Statut</th>
                            <th class="text-center"><i class="bi bi-gear me-2"></i>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty reports}">
                                <tr>
                                    <td colspan="8" class="text-center py-5">
                                        <i class="bi bi-file-earmark-text display-1 text-muted d-block mb-3"></i>
                                        <h5 class="text-muted">Aucun rapport généré</h5>
                                        <a href="${pageContext.request.contextPath}/reports/generate"
                                           class="btn btn-modern btn-gradient-primary mt-3">
                                            <i class="bi bi-plus-circle me-2"></i>Générer votre premier rapport
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="report" items="${reports}">
                                    <tr>
                                        <td><strong>#${report.reportId}</strong></td>
                                        <td>
                                            <div>
                                                <strong>${report.reportName}</strong>
                                                <c:if test="${not empty report.description}">
                                                    <br>
                                                    <small class="text-muted">${report.description}</small>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge badge-modern
                                                ${report.reportType == 'SALES' ? 'bg-primary' :
                                                  report.reportType == 'STOCK' ? 'bg-success' :
                                                  report.reportType == 'CUSTOMER' ? 'bg-warning' :
                                                  report.reportType == 'FINANCIAL' ? 'bg-info' : 'bg-secondary'}">
                                                <c:choose>
                                                    <c:when test="${report.reportType == 'SALES'}">Ventes</c:when>
                                                    <c:when test="${report.reportType == 'STOCK'}">Stock</c:when>
                                                    <c:when test="${report.reportType == 'CUSTOMER'}">Clients</c:when>
                                                    <c:when test="${report.reportType == 'FINANCIAL'}">Financier</c:when>
                                                    <c:when test="${report.reportType == 'PRESCRIPTION'}">Ordonnances</c:when>
                                                    <c:otherwise>${report.reportType}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${not empty report.startDate}">
                                                <fmt:formatDate value="${report.startDate}" pattern="dd/MM/yyyy"/>
                                                <c:if test="${not empty report.endDate}">
                                                    <br>
                                                    <small class="text-muted">au</small>
                                                    <fmt:formatDate value="${report.endDate}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:if test="${not empty report.generatedAt}">
                                                <fmt:formatDate value="${report.generatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="badge badge-modern bg-light text-dark">
                                                    ${report.format}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge badge-modern
                                                ${report.status == 'COMPLETED' ? 'bg-success' :
                                                  report.status == 'GENERATING' ? 'bg-warning' :
                                                  report.status == 'FAILED' ? 'bg-danger' : 'bg-secondary'}">
                                                    ${report.status}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a href="${pageContext.request.contextPath}/reports/view?id=${report.reportId}"
                                                   class="btn btn-outline-primary" title="Voir" data-bs-toggle="tooltip">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <c:if test="${report.status == 'COMPLETED'}">
                                                    <a href="${pageContext.request.contextPath}/reports/download?id=${report.reportId}"
                                                       class="btn btn-outline-success" title="Télécharger" data-bs-toggle="tooltip">
                                                        <i class="bi bi-download"></i>
                                                    </a>
                                                </c:if>
                                                <button type="button" class="btn btn-outline-danger"
                                                        onclick="confirmDelete(${report.reportId}, '${report.reportName}')"
                                                        title="Supprimer" data-bs-toggle="tooltip">
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
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete(reportId, reportName) {
        if (confirm('Êtes-vous sûr de vouloir supprimer le rapport "' + reportName + '" ?')) {
            window.location.href = '${pageContext.request.contextPath}/reports/delete?id=' + reportId;
        }
    }
</script>