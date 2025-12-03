<%-- /WEB-INF/views/reports/financial.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
  <div class="row mb-4">
    <div class="col-12">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h2 class="mb-1">
            <i class="bi bi-cash-stack text-primary me-2"></i>Rapport Financier
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

  <!-- Résumé financier -->
  <div class="row g-3 mb-4">
    <div class="col-md-3">
      <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h3 class="mb-1">
              <fmt:formatNumber value="${report.summary.totalRevenue}"
                                type="currency"
                                currencyCode="MGA"
                                maxFractionDigits="0"/>
            </h3>
            <p class="mb-0 opacity-75">Chiffre d'affaires</p>
          </div>
          <i class="bi bi-cash-coin stat-icon"></i>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h3 class="mb-1">
              <fmt:formatNumber value="${report.summary.averageDailyRevenue}"
                                type="currency"
                                currencyCode="MGA"
                                maxFractionDigits="0"/>
            </h3>
            <p class="mb-0 opacity-75">Moyenne journalière</p>
          </div>
          <i class="bi bi-graph-up-arrow stat-icon"></i>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h3 class="mb-1">${report.summary.numberOfTransactions}</h3>
            <p class="mb-0 opacity-75">Transactions</p>
          </div>
          <i class="bi bi-receipt stat-icon"></i>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h3 class="mb-1">
              <fmt:formatNumber value="${report.summary.averageTransactionValue}"
                                type="currency"
                                currencyCode="MGA"
                                maxFractionDigits="0"/>
            </h3>
            <p class="mb-0 opacity-75">Panier moyen</p>
          </div>
          <i class="bi bi-cart-check stat-icon"></i>
        </div>
      </div>
    </div>
  </div>

  <!-- Graphiques -->
  <div class="row mb-4">
    <div class="col-md-6">
      <div class="modern-card">
        <h5 class="mb-3">
          <i class="bi bi-graph-up me-2"></i>Évolution du chiffre d'affaires
        </h5>
        <div style="height: 300px;">
          <canvas id="revenueChart"></canvas>
        </div>
      </div>
    </div>
    <div class="col-md-6">
      <div class="modern-card">
        <h5 class="mb-3">
          <i class="bi bi-pie-chart me-2"></i>Répartition par mode de paiement
        </h5>
        <div style="height: 300px;">
          <canvas id="paymentChart"></canvas>
        </div>
      </div>
    </div>
  </div>

  <!-- Top jours de vente -->
  <div class="row mb-4">
    <div class="col-12">
      <div class="modern-card">
        <h5 class="mb-3">
          <i class="bi bi-trophy me-2"></i>Top 5 des meilleurs jours de vente
        </h5>
        <div class="table-responsive">
          <table class="table modern-table">
            <thead>
            <tr>
              <th>#</th>
              <th>Date</th>
              <th>Chiffre d'affaires</th>
              <th>Nombre de transactions</th>
              <th>Panier moyen</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="day" items="${reportData.topSellingDays}" varStatus="status">
              <tr>
                <td>${status.index + 1}</td>
                <td>
                  <fmt:parseDate value="${day.key}" pattern="yyyy-MM-dd" var="parsedDate" />
                  <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/>
                </td>
                <td>
                  <strong>
                    <fmt:formatNumber value="${day.value}"
                                      type="currency"
                                      currencyCode="MGA"
                                      maxFractionDigits="0"/>
                  </strong>
                </td>
                <td>
                  <c:set var="salesCount" value="0" />
                  <c:forEach var="detail" items="${report.details}">
                    <c:if test="${detail.date == day.key}">
                      <c:set var="salesCount" value="${salesCount + 1}" />
                    </c:if>
                  </c:forEach>
                    ${salesCount}
                </td>
                <td>
                  <fmt:formatNumber value="${day.value / salesCount}"
                                    type="currency"
                                    currencyCode="MGA"
                                    maxFractionDigits="0"/>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <!-- Détails journaliers -->
  <div class="row">
    <div class="col-12">
      <div class="modern-card">
        <h5 class="mb-3">
          <i class="bi bi-calendar-week me-2"></i>Détails journaliers
        </h5>
        <div class="table-responsive">
          <table class="table modern-table">
            <thead>
            <tr>
              <th>Date</th>
              <th>Chiffre d'affaires</th>
              <th>Nombre de transactions</th>
              <th>Panier moyen</th>
              <th>Tendance</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="detail" items="${report.details}">
              <tr>
                <td>
                  <fmt:formatDate value="${detail.date}" pattern="dd/MM/yyyy"/>
                </td>
                <td>
                  <strong>
                    <fmt:formatNumber value="${detail.revenue}"
                                      type="currency"
                                      currencyCode="MGA"
                                      maxFractionDigits="0"/>
                  </strong>
                </td>
                <td>${detail.numberOfSales}</td>
                <td>
                  <fmt:formatNumber value="${detail.revenue / detail.numberOfSales}"
                                    type="currency"
                                    currencyCode="MGA"
                                    maxFractionDigits="0"/>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${detail.revenue > report.summary.averageDailyRevenue}">
                                                <span class="badge badge-modern bg-success">
                                                    <i class="bi bi-arrow-up"></i> Au-dessus
                                                </span>
                    </c:when>
                    <c:when test="${detail.revenue < report.summary.averageDailyRevenue}">
                                                <span class="badge badge-modern bg-warning">
                                                    <i class="bi bi-arrow-down"></i> En dessous
                                                </span>
                    </c:when>
                    <c:otherwise>
                                                <span class="badge badge-modern bg-info">
                                                    <i class="bi bi-dash"></i> Moyenne
                                                </span>
                    </c:otherwise>
                  </c:choose>
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
    // Graphique des revenus
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    const revenueData = ${reportData.revenueByDay != null ? reportData.revenueByDay : '{}'};

    // Convertir les dates en format français
    const labels = Object.keys(revenueData).map(dateStr => {
      const date = new Date(dateStr);
      return date.toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit' });
    });

    new Chart(revenueCtx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: 'Chiffre d\'affaires',
          data: Object.values(revenueData),
          backgroundColor: 'rgba(54, 162, 235, 0.1)',
          borderColor: 'rgba(54, 162, 235, 1)',
          borderWidth: 2,
          fill: true,
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                return 'CA: ' + formatCurrency(context.raw);
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function(value) {
                return formatCurrency(value);
              }
            }
          }
        }
      }
    });

    // Graphique des modes de paiement
    const paymentCtx = document.getElementById('paymentChart').getContext('2d');
    const paymentData = ${reportData.revenueByPaymentMethod != null ? reportData.revenueByPaymentMethod : '{}'};

    new Chart(paymentCtx, {
      type: 'doughnut',
      data: {
        labels: Object.keys(paymentData).map(key => {
          switch(key) {
            case 'CASH': return 'Espèces';
            case 'CARD': return 'Carte';
            case 'MOBILE': return 'Mobile Money';
            case 'CHECK': return 'Chèque';
            default: return key;
          }
        }),
        datasets: [{
          data: Object.values(paymentData),
          backgroundColor: [
            'rgba(75, 192, 192, 0.5)',
            'rgba(255, 99, 132, 0.5)',
            'rgba(255, 205, 86, 0.5)',
            'rgba(54, 162, 235, 0.5)'
          ],
          borderColor: [
            'rgba(75, 192, 192, 1)',
            'rgba(255, 99, 132, 1)',
            'rgba(255, 205, 86, 1)',
            'rgba(54, 162, 235, 1)'
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
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                const value = context.raw;
                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                const percentage = Math.round((value / total) * 100);
                return formatCurrency(value) + ' (' + percentage + '%)';
              }
            }
          }
        }
      }
    });
  });

  function formatCurrency(value) {
    return new Intl.NumberFormat('fr-MG', {
      style: 'currency',
      currency: 'MGA',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(value);
  }

  function printReport() {
    window.print();
  }

  function exportReport(format) {
    const reportId = ${report.reportId};
    let url = '${pageContext.request.contextPath}/reports/export?id=' + reportId + '&format=' + format;
    window.location.href = url;
  }
</script>