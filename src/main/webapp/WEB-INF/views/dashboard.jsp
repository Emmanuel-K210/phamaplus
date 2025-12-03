<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <!-- En-tête avec salutation -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-speedometer2 text-primary me-2"></i>
                        Bonjour, ${sessionScope.fullName} 👋
                    </h2>
                    <p class="text-muted mb-0">
                        <i class="bi bi-calendar3 me-2"></i>
                        <jsp:useBean id="now" class="java.util.Date"/>
                        <fmt:formatDate value="${now}" pattern="EEEE dd MMMM yyyy" />
                    </p>
                </div>
                <div>
                    <a class="btn btn-modern btn-gradient-primary" href="${pageContext.request.contextPath}/sales">
                        <i class="bi bi-plus-circle me-2"></i>Nouvelle Vente
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Cartes statistiques principales -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="stat-card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                <div class="position-relative">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="mb-1 opacity-75">Ventes Aujourd'hui</p>
                            <h2 class="mb-0">2,456 F CFA</h2>
                            <div class="mt-2">
                                <span class="badge bg-white bg-opacity-25">
                                    <i class="bi bi-arrow-up me-1"></i>+12.5%
                                </span>
                            </div>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="stat-card" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
                <div class="position-relative">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="mb-1 opacity-75">Produits en Stock</p>
                            <h2 class="mb-0">1,284</h2>
                            <div class="mt-2">
                                <span class="badge bg-white bg-opacity-25">
                                    <i class="bi bi-check-circle me-1"></i>Normal
                                </span>
                            </div>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-boxes"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="stat-card" style="background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);">
                <div class="position-relative">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="mb-1 opacity-75">Stock Faible</p>
                            <h2 class="mb-0">23</h2>
                            <div class="mt-2">
                                <span class="badge bg-white bg-opacity-25">
                                    <i class="bi bi-exclamation-triangle me-1"></i>Alerte
                                </span>
                            </div>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-arrow-down-circle"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="stat-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                <div class="position-relative">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <p class="mb-1 opacity-75">Clients Actifs</p>
                            <h2 class="mb-0">543</h2>
                            <div class="mt-2">
                                <span class="badge bg-white bg-opacity-25">
                                    <i class="bi bi-arrow-up me-1"></i>+5.2%
                                </span>
                            </div>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-people"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques et alertes -->
    <div class="row g-4 mb-4">
        <!-- Graphique des ventes -->
        <div class="col-lg-8">
            <div class="modern-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="mb-0">
                        <i class="bi bi-graph-up text-primary me-2"></i>
                        Évolution des Ventes
                    </h5>
                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-sm btn-outline-primary active">Semaine</button>
                        <button type="button" class="btn btn-sm btn-outline-primary">Mois</button>
                        <button type="button" class="btn btn-sm btn-outline-primary">Année</button>
                    </div>
                </div>
                <canvas id="salesChart" height="80"></canvas>
            </div>
        </div>

        <!-- Alertes importantes -->
        <div class="col-lg-4">
            <div class="modern-card p-4">
                <h5 class="mb-4">
                    <i class="bi bi-bell text-danger me-2"></i>
                    Alertes Importantes
                </h5>

                <div class="alert alert-danger alert-card d-flex align-items-start mb-3">
                    <i class="bi bi-exclamation-triangle-fill fs-4 me-3"></i>
                    <div>
                        <strong>5 produits expirés</strong>
                        <p class="mb-0 small">Action requise immédiatement</p>
                        <a href="#" class="btn btn-sm btn-danger mt-2">Voir détails</a>
                    </div>
                </div>

                <div class="alert alert-warning alert-card d-flex align-items-start mb-3">
                    <i class="bi bi-clock-fill fs-4 me-3"></i>
                    <div>
                        <strong>12 produits expirent bientôt</strong>
                        <p class="mb-0 small">Dans les 30 prochains jours</p>
                        <a href="#" class="btn btn-sm btn-warning mt-2">Voir détails</a>
                    </div>
                </div>

                <div class="alert alert-info alert-card d-flex align-items-start mb-0">
                    <i class="bi bi-info-circle-fill fs-4 me-3"></i>
                    <div>
                        <strong>23 produits en stock faible</strong>
                        <p class="mb-0 small">Réapprovisionnement recommandé</p>
                        <a href="#" class="btn btn-sm btn-info mt-2">Voir détails</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Actions rapides et produits populaires -->
    <div class="row g-4 mb-4">
        <!-- Actions rapides -->
        <div class="col-lg-4">
            <div class="modern-card p-4">
                <h5 class="mb-4">
                    <i class="bi bi-lightning-charge text-warning me-2"></i>
                    Actions Rapides
                </h5>

                <div class="d-grid gap-3">
                    <a href="${pageContext.request.contextPath}/products/add"
                       class="btn btn-modern btn-gradient-primary text-start quick-action">
                        <i class="bi bi-plus-circle me-2"></i>Ajouter un Produit
                    </a>
                    <a href="${pageContext.request.contextPath}/inventory/add"
                       class="btn btn-modern btn-gradient-success text-start quick-action">
                        <i class="bi bi-box-seam me-2"></i>Nouveau Lot
                    </a>
                    <a href="#" class="btn btn-modern btn-gradient-info text-start quick-action">
                        <i class="bi bi-cart-plus me-2"></i>Nouvelle Vente
                    </a>
                    <a href="#" class="btn btn-outline-primary text-start quick-action">
                        <i class="bi bi-file-earmark-text me-2"></i>Générer Rapport
                    </a>
                </div>
            </div>
        </div>

        <!-- Top produits -->
        <div class="col-lg-8">
            <div class="modern-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="mb-0">
                        <i class="bi bi-trophy text-warning me-2"></i>
                        Produits les Plus Vendus
                    </h5>
                    <a href="#" class="text-decoration-none">Voir tout <i class="bi bi-arrow-right"></i></a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Rang</th>
                            <th>Produit</th>
                            <th>Ventes</th>
                            <th>Revenus</th>
                            <th>Tendance</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                <div class="bg-warning bg-opacity-10 text-warning rounded-circle d-inline-flex
                                                align-items-center justify-content-center"
                                     style="width: 30px; height: 30px;">
                                    <strong>1</strong>
                                </div>
                            </td>
                            <td>
                                <strong>Paracétamol 500mg</strong>
                                <br><small class="text-muted">Analgésique</small>
                            </td>
                            <td><strong>342</strong> unités</td>
                            <td><strong class="text-success">1,710 F CFA</strong></td>
                            <td>
                                    <span class="badge badge-modern bg-success">
                                        <i class="bi bi-arrow-up"></i> +15%
                                    </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="bg-secondary bg-opacity-10 text-secondary rounded-circle d-inline-flex
                                                align-items-center justify-content-center"
                                     style="width: 30px; height: 30px;">
                                    <strong>2</strong>
                                </div>
                            </td>
                            <td>
                                <strong>Ibuprofène 400mg</strong>
                                <br><small class="text-muted">Anti-inflammatoire</small>
                            </td>
                            <td><strong>289</strong> unités</td>
                            <td><strong class="text-success">1,445 F CFA</strong></td>
                            <td>
                                    <span class="badge badge-modern bg-success">
                                        <i class="bi bi-arrow-up"></i> +8%
                                    </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="bg-secondary bg-opacity-10 text-secondary rounded-circle d-inline-flex
                                                align-items-center justify-content-center"
                                     style="width: 30px; height: 30px;">
                                    <strong>3</strong>
                                </div>
                            </td>
                            <td>
                                <strong>Vitamine C 1000mg</strong>
                                <br><small class="text-muted">Supplément</small>
                            </td>
                            <td><strong>256</strong> unités</td>
                            <td><strong class="text-success">1,280 F CFA</strong></td>
                            <td>
                                    <span class="badge badge-modern bg-danger">
                                        <i class="bi bi-arrow-down"></i> -3%
                                    </span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Ventes récentes -->
    <div class="row">
        <div class="col-12">
            <div class="modern-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="mb-0">
                        <i class="bi bi-clock-history text-info me-2"></i>
                        Ventes Récentes
                    </h5>
                    <a href="#" class="text-decoration-none">Voir toutes les ventes <i class="bi bi-arrow-right"></i></a>
                </div>

                <div class="table-responsive">
                    <table class="table modern-table mb-0">
                        <thead>
                        <tr>
                            <th><i class="bi bi-hash me-2"></i>N° Vente</th>
                            <th><i class="bi bi-person me-2"></i>Client</th>
                            <th><i class="bi bi-box me-2"></i>Produits</th>
                            <th><i class="bi bi-currency-euro me-2"></i>Montant</th>
                            <th><i class="bi bi-credit-card me-2"></i>Paiement</th>
                            <th><i class="bi bi-clock me-2"></i>Heure</th>
                            <th><i class="bi bi-info-circle me-2"></i>Statut</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr class="recent-sale">
                            <td><strong>#VNT-2024-1234</strong></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                                        <i class="bi bi-person text-primary"></i>
                                    </div>
                                    <span>Marie Dupont</span>
                                </div>
                            </td>
                            <td>3 articles</td>
                            <td><strong class="text-success">45.50 F CFA</strong></td>
                            <td><span class="badge badge-modern bg-info">Carte</span></td>
                            <td>Il y a 5 min</td>
                            <td><span class="badge badge-modern bg-success">
                                    <i class="bi bi-check-circle me-1"></i>Payé
                                </span></td>
                        </tr>
                        <tr class="recent-sale">
                            <td><strong>#VNT-2024-1233</strong></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-success bg-opacity-10 rounded-circle p-2 me-2">
                                        <i class="bi bi-person text-success"></i>
                                    </div>
                                    <span>Jean Martin</span>
                                </div>
                            </td>
                            <td>1 article</td>
                            <td><strong class="text-success">12.00 F CFA</strong></td>
                            <td><span class="badge badge-modern bg-success">Espèces</span></td>
                            <td>Il y a 12 min</td>
                            <td><span class="badge badge-modern bg-success">
                                    <i class="bi bi-check-circle me-1"></i>Payé
                                </span></td>
                        </tr>
                        <tr class="recent-sale">
                            <td><strong>#VNT-2024-1232</strong></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-warning bg-opacity-10 rounded-circle p-2 me-2">
                                        <i class="bi bi-person text-warning"></i>
                                    </div>
                                    <span>Sophie Bernard</span>
                                </div>
                            </td>
                            <td>5 articles</td>
                            <td><strong class="text-success">89.75 F CFA</strong></td>
                            <td><span class="badge badge-modern bg-info">Carte</span></td>
                            <td>Il y a 25 min</td>
                            <td><span class="badge badge-modern bg-success">
                                    <i class="bi bi-check-circle me-1"></i>Payé
                                </span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>