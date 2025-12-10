<%-- /WEB-INF/views/reports/prescriptions.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-file-medical text-primary me-2"></i>Rapport des Ordonnances
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-calendar me-1"></i>
                        Période : <fmt:formatDate value="${startDate}" pattern="dd/MM/yyyy"/>
                        au <fmt:formatDate value="${endDate}" pattern="dd/MM/yyyy"/>
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-modern btn-gradient-primary" onclick="printReport()">
                        <i class="bi bi-printer me-2"></i>Imprimer
                    </button>
                    <button type="button" class="btn btn-modern btn-gradient-success" onclick="exportReport('pdf')">
                        <i class="bi bi-file-pdf me-2"></i>Exporter PDF
                    </button>
                    <button type="button" class="btn btn-modern btn-gradient-info" onclick="exportReport('excel')">
                        <i class="bi bi-file-excel me-2"></i>Exporter Excel
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistiques résumées -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1">${report.summary.totalPrescriptions}</h3>
                        <p class="mb-0 opacity-75">Ordonnances totales</p>
                    </div>
                    <i class="bi bi-file-medical stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1">${report.summary.prescriptionsFilled}</h3>
                        <p class="mb-0 opacity-75">Honorées</p>
                    </div>
                    <i class="bi bi-check-circle stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1">${report.summary.prescriptionsPending}</h3>
                        <p class="mb-0 opacity-75">En attente</p>
                    </div>
                    <i class="bi bi-clock stat-icon"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-1">
                            <fmt:formatNumber value="${report.summary.fillRate}" pattern="#0.0"/>%
                        </h3>
                        <p class="mb-0 opacity-75">Taux d'honorariat</p>
                    </div>
                    <i class="bi bi-percent stat-icon"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques et détails -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="modern-card">
                <h5 class="mb-3">
                    <i class="bi bi-graph-up me-2"></i>Répartition par médecin
                </h5>
                <div style="height: 300px;">
                    <canvas id="doctorsChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="modern-card">
                <h5 class="mb-3">
                    <i class="bi bi-pie-chart me-2"></i>Statut des ordonnances
                </h5>
                <div style="height: 300px;">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Top médicaments prescrits -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="modern-card">
                <h5 class="mb-3">
                    <i class="bi bi-capsule me-2"></i>Top 10 des médicaments les plus prescrits
                </h5>
                <div class="table-responsive">
                    <table class="table modern-table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Médicament</th>
                            <th>Nombre de prescriptions</th>
                            <th>Fréquence</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="med" items="${reportData.topMedications}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${med.key}</td>
                                <td>${med.value}</td>
                                <td>
                                    <div class="progress" style="height: 20px;">
                                        <div class="progress-bar bg-info"
                                             style="width: ${(med.value / report.summary.totalPrescriptions) * 100}%">
                                            <fmt:formatNumber value="${(med.value / report.summary.totalPrescriptions) * 100}"
                                                              pattern="#0.0"/>%
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Détails des ordonnances -->
    <div class="row">
        <div class="col-12">
            <div class="modern-card">
                <h5 class="mb-3">
                    <i class="bi bi-list-ul me-2"></i>Détails des ordonnances
                </h5>
                <div class="table-responsive">
                    <table class="table modern-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Date</th>
                            <th>Client</th>
                            <th>Médecin</th>
                            <th>Nombre de médicaments</th>
                            <th>Statut</th>
                            <th>Date d'honorariat</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="detail" items="${report.details}">
                            <tr>
                                <td>#${detail.prescriptionId}</td>
                                <td>
                                    <fmt:formatDate value="${detail.date}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>${detail.customerName}</td>
                                <td>${detail.doctorName}</td>
                                <td>
                                        <span class="badge badge-modern bg-info">
                                                ${detail.numberOfMedications}
                                        </span>
                                </td>
                                <td>
                                        <span class="badge badge-modern ${detail.status == 'Honorée' ? 'bg-success' : 'bg-warning'}">
                                                ${detail.status}
                                        </span>
                                </td>
                                <td>
                                    <c:if test="${not empty detail.filledDate}">
                                        <fmt:formatDate value="${detail.filledDate}" pattern="dd/MM/yyyy"/>
                                    </c:if>
                                    <c:if test="${empty detail.filledDate}">
                                        <span class="text-muted">-</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Graphique des médecins
        const doctorsCtx = document.getElementById('doctorsChart').getContext('2d');
        const doctorsData = ${reportData.prescriptionsByDoctor != null ? reportData.prescriptionsByDoctor : '{}'};

        new Chart(doctorsCtx, {
            type: 'bar',
            data: {
                labels: Object.keys(doctorsData),
                datasets: [{
                    label: 'Nombre d\'ordonnances',
                    data: Object.values(doctorsData),
                    backgroundColor: 'rgba(54, 162, 235, 0.5)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });

        // Graphique des statuts
        const statusCtx = document.getElementById('statusChart').getContext('2d');
        const filled = ${report.summary.prescriptionsFilled};
        const pending = ${report.summary.prescriptionsPending};

        new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Honorées', 'En attente'],
                datasets: [{
                    data: [filled, pending],
                    backgroundColor: [
                        'rgba(75, 192, 192, 0.5)',
                        'rgba(255, 205, 86, 0.5)'
                    ],
                    borderColor: [
                        'rgba(75, 192, 192, 1)',
                        'rgba(255, 205, 86, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    });

    function printReport() {
        window.print();
    }

    function exportReport(format) {
        const reportId = ${report.reportId};
        let url = '${pageContext.request.contextPath}/reports/export?id=' + reportId + '&format=' + format;
        window.location.href = url;
    }
</script>