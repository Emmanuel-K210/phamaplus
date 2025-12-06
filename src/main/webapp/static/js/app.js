function toggleSidebar() {
    document.querySelector('.modern-sidebar').classList.toggle('show');
}

// Formatage des nombres pour le F CFA
function formatFCFA(amount) {
    if (!amount) return '0 F CFA';
    return new Intl.NumberFormat('fr-FR', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    }).format(amount) + ' F CFA';
}

// Initialisation au chargement
document.addEventListener('DOMContentLoaded', function() {
    // Animation des cartes
    const cards = document.querySelectorAll('.modern-card, .stat-card');
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });

    // Formater les montants F CFA
    document.querySelectorAll('.fcfa-amount').forEach(element => {
        const amount = parseFloat(element.textContent) || 0;
        element.textContent = formatFCFA(amount);
    });

    // Tooltips Bootstrap
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});