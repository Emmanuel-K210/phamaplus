<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1">
                        <i class="bi bi-pencil text-primary me-2"></i>Modifier le Fournisseur
                    </h2>
                    <p class="text-muted mb-0">
                        Modifiez les informations de ${supplier.supplierName}
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/suppliers" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Retour à la liste
                </a>
            </div>
        </div>
    </div>

    <!-- Messages d'erreur -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show modern-card mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <strong>Erreur !</strong> ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <div class="col-lg-8">
            <div class="modern-card p-4">
                <form action="${pageContext.request.contextPath}/suppliers/edit" method="post" id="supplierForm">
                    <input type="hidden" name="id" value="${supplier.supplierId}">

                    <!-- Informations principales -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-building text-primary me-2"></i>Informations de l'entreprise
                            </h5>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Nom du fournisseur <span class="text-danger">*</span></label>
                            <input type="text" class="form-control modern-input"
                                   name="supplierName" required
                                   value="${supplier.supplierName}"
                                   placeholder="MediCorp France">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Code barre</label>
                            <input type="text" class="form-control modern-input"
                                   name="barcode"
                                   value="${supplier.barcode}"
                                   placeholder="123456789012">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Personne de contact</label>
                            <input type="text" class="form-control modern-input"
                                   name="contactPerson"
                                   value="${supplier.contactPerson}"
                                   placeholder="M. Martin Dupont">
                        </div>
                    </div>

                    <!-- Contact -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-telephone text-primary me-2"></i>Coordonnées
                            </h5>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Téléphone <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control modern-input"
                                   name="phone" required
                                   value="${supplier.phone}"
                                   placeholder="01 23 45 67 89">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" class="form-control modern-input"
                                   name="email"
                                   value="${supplier.email}"
                                   placeholder="contact@medicorp.fr">
                        </div>
                    </div>

                    <!-- Adresse -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-geo-alt text-primary me-2"></i>Adresse
                            </h5>
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label fw-bold">Adresse complète</label>
                            <textarea class="form-control modern-input"
                                      name="address" rows="2"
                                      placeholder="123 Avenue des Champs-Élysées">${supplier.address}</textarea>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Ville</label>
                            <input type="text" class="form-control modern-input"
                                   name="city"
                                   value="${supplier.city}"
                                   placeholder="Paris">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Pays</label>
                            <div class="country-select-container">
                                <input type="text"
                                       class="form-control modern-input"
                                       id="countryInput"
                                       name="country"
                                       value="${supplier.country}"
                                       placeholder="Commencez à taper un pays..."
                                       autocomplete="off"
                                       required>
                                <div class="country-suggestions"></div>
                            </div>
                            <small class="text-muted">Commencez à taper pour rechercher</small>
                        </div>
                    </div>

                    <!-- Paramètres -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <h5 class="mb-3 border-bottom pb-2">
                                <i class="bi bi-gear text-primary me-2"></i>Paramètres
                            </h5>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Niveau de réapprovisionnement</label>
                            <input type="number" class="form-control modern-input"
                                   name="reorderLevel" min="1" max="1000"
                                   value="${supplier.reorderLevel}">
                            <small class="text-muted">Niveau à partir duquel une commande est suggérée</small>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Statut</label>
                            <div class="form-check form-switch mt-2">
                                <input class="form-check-input" type="checkbox"
                                       name="isActive" value="true"
                                       role="switch" id="flexSwitchCheckDefault"
                                ${supplier.isActive ? 'checked' : ''}>
                                <label class="form-check-label" for="flexSwitchCheckDefault">
                                    Fournisseur actif
                                </label>
                            </div>
                            <small class="text-muted">Désactivez pour suspendre les commandes</small>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <button type="button" class="btn btn-modern btn-gradient-danger"
                                            onclick="confirmDelete(${supplier.supplierId})">
                                        <i class="bi bi-trash me-2"></i>Supprimer
                                    </button>
                                    <button type="button" class="btn btn-modern ${supplier.isActive ? 'btn-gradient-warning' : 'btn-gradient-success'}"
                                            onclick="toggleStatus(${supplier.supplierId}, ${supplier.isActive})">
                                        <i class="bi ${supplier.isActive ? 'bi-toggle-off' : 'bi-toggle-on'} me-2"></i>
                                        ${supplier.isActive ? 'Désactiver' : 'Activer'}
                                    </button>
                                </div>
                                <div class="d-flex gap-3">
                                    <a href="${pageContext.request.contextPath}/suppliers" class="btn btn-modern btn-gradient-secondary">
                                        <i class="bi bi-x-circle me-2"></i>Annuler
                                    </a>
                                    <button type="submit" class="btn btn-modern btn-gradient-primary">
                                        <i class="bi bi-check-circle me-2"></i>Enregistrer les modifications
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Sidebar - Informations -->
        <div class="col-lg-4">
            <div class="modern-card p-4 mb-4">
                <h5 class="mb-3">
                    <i class="bi bi-info-circle text-info me-2"></i>Informations du fournisseur
                </h5>
                <div class="mb-3">
                    <div class="d-flex align-items-center mb-2">
                        <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2">
                            <i class="bi bi-building text-primary"></i>
                        </div>
                        <div>
                            <strong>${supplier.supplierName}</strong>
                            <br>
                            <small class="text-muted">ID: #${supplier.supplierId}</small>
                        </div>
                    </div>
                </div>
                <ul class="list-unstyled">
                    <c:if test="${not empty supplier.contactPerson}">
                        <li class="mb-2">
                            <i class="bi bi-person text-primary me-2"></i>
                            <strong>Contact :</strong> ${supplier.contactPerson}
                        </li>
                    </c:if>
                    <li class="mb-2">
                        <i class="bi bi-telephone text-primary me-2"></i>
                        <strong>Téléphone :</strong> ${supplier.phone}
                    </li>
                    <c:if test="${not empty supplier.email}">
                        <li class="mb-2">
                            <i class="bi bi-envelope text-primary me-2"></i>
                            <strong>Email :</strong> ${supplier.email}
                        </li>
                    </c:if>
                    <c:if test="${not empty supplier.city}">
                        <li class="mb-2">
                            <i class="bi bi-geo-alt text-primary me-2"></i>
                            <strong>Localisation :</strong> ${supplier.city}, ${supplier.country}
                        </li>
                    </c:if>
                    <li class="mb-2">
                        <i class="bi bi-box text-primary me-2"></i>
                        <strong>Niveau réappro :</strong> ${supplier.reorderLevel}
                    </li>
                    <li class="mb-2">
                        <i class="bi bi-toggle-on text-primary me-2"></i>
                        <strong>Statut :</strong>
                        <c:choose>
                            <c:when test="${supplier.isActive}">
                                <span class="badge bg-success">Actif</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Inactif</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <c:if test="${not empty supplier.createdAt}">
                        <li class="mb-2">
                            <i class="bi bi-clock text-primary me-2"></i>
                            <strong>Créé le :</strong> ${supplier.createdAt}
                        </li>
                    </c:if>
                </ul>
            </div>

            <div class="modern-card p-4">
                <h5 class="mb-3">
                    <i class="bi bi-lightning text-warning me-2"></i>Actions rapides
                </h5>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/purchase/create?supplierId=${supplier.supplierId}"
                       class="btn btn-outline-success text-start">
                        <i class="bi bi-cart-plus me-2"></i>Nouvelle commande
                    </a>
                    <a href="${pageContext.request.contextPath}/inventory?supplierId=${supplier.supplierId}"
                       class="btn btn-outline-info text-start">
                        <i class="bi bi-box-seam me-2"></i>Voir les stocks
                    </a>
                    <a href="${pageContext.request.contextPath}/suppliers"
                       class="btn btn-outline-primary text-start">
                        <i class="bi bi-list me-2"></i>Voir tous les fournisseurs
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    (function() {
        'use strict';

        const CountryManager = {
            countries: [
                // Europe
                "France", "Allemagne", "Belgique", "Suisse", "Luxembourg",
                "Italie", "Espagne", "Portugal", "Royaume-Uni", "Pays-Bas",
                "Suède", "Norvège", "Danemark", "Finlande", "Pologne",
                "République Tchèque", "Slovaquie", "Hongrie", "Autriche", "Grèce",
                "Turquie", "Russie", "Irlande", "Islande",

                // Afrique
                "Algérie", "Maroc", "Tunisie", "Sénégal", "Côte d'Ivoire",
                "Cameroun", "Afrique du Sud", "Égypte", "Nigeria", "Ghana",
                "Kenya", "Madagascar", "Mali", "Burkina Faso", "Bénin",
                "Togo", "Gabon", "Congo", "Rwanda",

                // Amériques
                "États-Unis", "Canada", "Brésil", "Mexique", "Argentine",
                "Chili", "Colombie", "Pérou", "Cuba", "République Dominicaine",
                "Venezuela", "Équateur", "Bolivie", "Uruguay", "Paraguay",

                // Asie
                "Chine", "Japon", "Corée du Sud", "Inde", "Indonésie",
                "Thaïlande", "Vietnam", "Philippines", "Malaisie", "Singapour",
                "Arabie Saoudite", "Émirats Arabes Unis", "Qatar", "Israël",
                "Pakistan", "Bangladesh", "Sri Lanka", "Népal",

                // Océanie
                "Australie", "Nouvelle-Zélande", "Fidji", "Papouasie-Nouvelle-Guinée"
            ],

            init: function() {
                this.initializeCountryAutocomplete();
                this.setupFormValidation();
            },

            initializeCountryAutocomplete: function() {
                const countryInput = document.getElementById('countryInput');
                if (!countryInput) return;

                // Créer le conteneur pour les suggestions
                const container = countryInput.closest('.country-select-container') ||
                    countryInput.parentNode;
                container.style.position = 'relative';

                // Créer la boîte de suggestions
                const suggestionBox = document.createElement('div');
                suggestionBox.className = 'country-suggestions';
                suggestionBox.style.cssText = `
                display: none;
                position: absolute;
                background: white;
                border: 1px solid #dee2e6;
                border-radius: 0.375rem;
                max-height: 200px;
                overflow-y: auto;
                z-index: 1050;
                width: 100%;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
                margin-top: 2px;
            `;
                container.appendChild(suggestionBox);

                // Trier les pays
                this.countries.sort((a, b) => a.localeCompare(b, 'fr'));

                // Gérer les événements de saisie
                countryInput.addEventListener('input', (e) => {
                    const value = e.target.value.trim();

                    if (value.length === 0) {
                        suggestionBox.style.display = 'none';
                        return;
                    }

                    const filtered = this.countries.filter(country =>
                        country.toLowerCase().includes(value.toLowerCase())
                    );

                    this.displaySuggestions(suggestionBox, filtered, countryInput);
                });

                // Gérer le focus
                countryInput.addEventListener('focus', () => {
                    if (countryInput.value.length > 0) {
                        const value = countryInput.value.trim();
                        const filtered = this.countries.filter(country =>
                            country.toLowerCase().includes(value.toLowerCase())
                        );
                        this.displaySuggestions(suggestionBox, filtered, countryInput);
                    }
                });

                // Cacher les suggestions quand on clique ailleurs
                document.addEventListener('click', (e) => {
                    if (!container.contains(e.target)) {
                        suggestionBox.style.display = 'none';
                    }
                });

                // Navigation clavier
                countryInput.addEventListener('keydown', (e) => {
                    const suggestions = suggestionBox.querySelectorAll('.country-item');
                    const active = suggestionBox.querySelector('.country-item.active');

                    if (!suggestions.length) return;

                    let index = Array.from(suggestions).indexOf(active);

                    switch(e.key) {
                        case 'ArrowDown':
                            e.preventDefault();
                            index = (index + 1) % suggestions.length;
                            this.highlightSuggestion(suggestions, index, countryInput);
                            break;

                        case 'ArrowUp':
                            e.preventDefault();
                            index = index <= 0 ? suggestions.length - 1 : index - 1;
                            this.highlightSuggestion(suggestions, index, countryInput);
                            break;

                        case 'Enter':
                            e.preventDefault();
                            if (active) {
                                active.click();
                            }
                            break;

                        case 'Escape':
                            suggestionBox.style.display = 'none';
                            break;
                    }
                });
            },

            displaySuggestions: function(suggestionBox, countries, inputElement) {
                suggestionBox.innerHTML = '';

                if (countries.length === 0) {
                    const noResults = document.createElement('div');
                    noResults.className = 'country-item text-muted p-2';
                    noResults.textContent = 'Aucun pays trouvé';
                    suggestionBox.appendChild(noResults);
                } else {
                    countries.forEach(country => {
                        const item = document.createElement('div');
                        item.className = 'country-item';
                        item.textContent = country;
                        item.style.cssText = `
                        padding: 0.5rem 1rem;
                        cursor: pointer;
                        border-bottom: 1px solid #f8f9fa;
                        transition: background-color 0.2s;
                    `;

                        item.addEventListener('mouseenter', () => {
                            item.style.backgroundColor = '#f8f9fa';
                            item.classList.add('active');
                        });

                        item.addEventListener('mouseleave', () => {
                            item.style.backgroundColor = '';
                            item.classList.remove('active');
                        });

                        item.addEventListener('click', () => {
                            inputElement.value = country;
                            suggestionBox.style.display = 'none';
                            inputElement.focus();
                        });

                        suggestionBox.appendChild(item);
                    });
                }

                suggestionBox.style.display = 'block';
            },

            highlightSuggestion: function(suggestions, index, inputElement) {
                suggestions.forEach(s => s.classList.remove('active'));

                if (index >= 0 && index < suggestions.length) {
                    suggestions[index].classList.add('active');
                    suggestions[index].style.backgroundColor = '#f8f9fa';
                    suggestions[index].scrollIntoView({ block: 'nearest' });

                    // Optionnel: pré-remplir l'input pendant la navigation
                    // inputElement.value = suggestions[index].textContent;
                }
            },

            setupFormValidation: function() {
                const form = document.getElementById('supplierForm');
                if (!form) return;

                form.addEventListener('submit', (e) => {
                    const countryInput = document.getElementById('countryInput');
                    const supplierName = document.querySelector('input[name="supplierName"]').value.trim();
                    const phone = document.querySelector('input[name="phone"]').value.trim();
                    const country = countryInput.value.trim();

                    // Validation du nom
                    if (!supplierName) {
                        e.preventDefault();
                        this.showAlert('Erreur', 'Le nom du fournisseur est obligatoire', 'error');
                        document.querySelector('input[name="supplierName"]').focus();
                        return false;
                    }

                    // Validation du téléphone
                    if (!phone || !this.validatePhone(phone)) {
                        e.preventDefault();
                        this.showAlert('Erreur', 'Veuillez entrer un numéro de téléphone valide (minimum 10 chiffres)', 'error');
                        document.querySelector('input[name="phone"]').focus();
                        return false;
                    }

                    // Validation du pays
                    if (!country) {
                        e.preventDefault();
                        this.showAlert('Erreur', 'Le pays est obligatoire', 'error');
                        countryInput.focus();
                        return false;
                    }

                    // Vérifier si le pays est valide
                    if (!this.isValidCountry(country)) {
                        if (!confirm(`"${country}" n'est pas dans notre liste. Voulez-vous continuer avec ce pays?`)) {
                            e.preventDefault();
                            countryInput.focus();
                            return false;
                        }
                    }

                    return true;
                });
            },

            validatePhone: function(phone) {
                // Nettoyer le numéro
                const cleanPhone = phone.replace(/[\s\-\(\)\.]/g, '');
                // Vérifier s'il contient au moins 10 chiffres
                return /\d{10,}/.test(cleanPhone);
            },

            isValidCountry: function(country) {
                return this.countries.some(c =>
                    c.toLowerCase() === country.toLowerCase()
                );
            },

            showAlert: function(title, message, type) {
                // Utiliser les alertes Bootstrap si disponibles
                if (typeof bootstrap !== 'undefined') {
                    const alertDiv = document.createElement('div');
                    alertDiv.className = `alert alert-${type eq 'error' ? 'danger' : 'warning'} alert-dismissible fade show`;
                    alertDiv.innerHTML = `
                    <strong>${title}</strong> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;

                    const container = document.querySelector('.container-fluid');
                    if (container) {
                        container.insertBefore(alertDiv, container.firstChild);

                        // Auto-dismiss après 5 secondes
                        setTimeout(() => {
                            if (alertDiv.parentNode) {
                                const bsAlert = bootstrap.Alert.getOrCreateInstance(alertDiv);
                                bsAlert.close();
                            }
                        }, 5000);
                    }
                } else {
                    // Fallback simple
                    alert(`${title}: ${message}`);
                }
            },

            reset: function() {
                const countryInput = document.getElementById('countryInput');
                if (countryInput) {
                    countryInput.value = 'France';
                }

                const suggestionBox = document.querySelector('.country-suggestions');
                if (suggestionBox) {
                    suggestionBox.style.display = 'none';
                }
            }
        };

        // Fonction globale pour réinitialiser le champ pays
        window.resetCountryField = function() {
            CountryManager.reset();
        };

        // Initialiser quand le DOM est chargé
        document.addEventListener('DOMContentLoaded', () => CountryManager.init());

    })();
</script>
<script>
    // Validation du formulaire
    document.getElementById('supplierForm').addEventListener('submit', function(e) {
        const supplierName = document.querySelector('input[name="supplierName"]').value.trim();
        const phone = document.querySelector('input[name="phone"]').value.trim();

        if (!supplierName) {
            e.preventDefault();
            alert('Le nom du fournisseur est obligatoire');
            return false;
        }

        if (!phone || !/^[0-9\-\+\s\(\)]{10,}$/.test(phone)) {
            e.preventDefault();
            alert('Veuillez entrer un numéro de téléphone valide');
            return false;
        }

        return true;
    });

    function confirmDelete(supplierId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer ce fournisseur ? Cette action est irréversible.')) {
            window.location.href = '${pageContext.request.contextPath}/suppliers/delete?id=' + supplierId;
        }
    }

    function toggleStatus(supplierId, isActive) {
        const action = isActive ? 'deactivate' : 'activate';
        const message = isActive ?
            'Êtes-vous sûr de vouloir désactiver ce fournisseur ? Les nouvelles commandes seront bloquées.' :
            'Êtes-vous sûr de vouloir activer ce fournisseur ?';

        if (confirm(message)) {
            window.location.href = '${pageContext.request.contextPath}/suppliers/toggle-status?id=' + supplierId + '&action=' + action;
        }
    }

    // Focus sur le premier champ
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelector('input[name="supplierName"]').focus();
    });
</script>