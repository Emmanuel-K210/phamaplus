package com.onemaster.pharmaplus.controller;

import com.onemaster.pharmaplus.model.Customer;
import com.onemaster.pharmaplus.service.CustomerService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customers", "/customers/*"})
public class CustomerServlet extends HttpServlet {

    private CustomerService customerService;

    @Override
    public void init() {
        customerService = new CustomerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();

        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "/add":
                    showAddForm(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/view":
                    showCustomerDetails(request, response);
                    break;
                case "/delete":
                    deleteCustomer(request, response);
                    break;
                case "/export":
                    exportCustomers(request, response);
                    break;
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "/customers");
        }
    }


    private void createCustomerAjax(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            extractCustomer(request);
            Customer customer = extractCustomer(request);
            customer.setDateOfBirth(null); // Optionnel
            customerService.addCustomer(customer);

            // Réponse JSON de succès
            String jsonResponse = String.format(
                    "{\"success\": true, \"customerId\": %d, \"message\": \"Client créé avec succès\"}",
                    customer.getCustomerId()
            );

            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            e.printStackTrace();

            // Réponse JSON d'erreur
            String jsonResponse = String.format(
                    "{\"success\": false, \"message\": \"%s\"}",
                    e.getMessage().replace("\"", "\\\"")
            );

            response.getWriter().write(jsonResponse);
        }
    }

    private Customer extractCustomer(HttpServletRequest request) {
        Customer customer = new Customer();
        customer.setFirstName(request.getParameter("firstName"));
        customer.setLastName(request.getParameter("lastName"));
        customer.setPhone(request.getParameter("phone"));
        customer.setEmail(request.getParameter("email"));
        customer.setAddress(request.getParameter("address"));
        return customer;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();

        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "/add":
                    addCustomer(request, response);
                    break;
                case "/edit":
                    updateCustomer(request, response);
                    break;
                case "/check-email":
                    checkEmailExists(request, response);
                    break;
                case "/check-phone":
                    checkPhoneExists(request, response);
                    break;
                case "/create":
                    createCustomerAjax(request,response);
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, e, "/customers");
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Récupérer les paramètres
            String search = request.getParameter("search");
            String filter = request.getParameter("filter");
            String birthdayMonth = request.getParameter("birthdayMonth");

            // Récupérer tous les clients pour les statistiques
            List<Customer> allCustomers = customerService.getAllCustomers();

            // Filtrer si nécessaire
            List<Customer> customers;
            if (search != null && !search.trim().isEmpty()) {
                customers = customerService.searchCustomers(search);
            } else {
                customers = allCustomers;
            }

            // Filtrer par critères supplémentaires
            if (filter != null) {
                switch (filter) {
                    case "with_email":
                        customers = customers.stream()
                                .filter(c -> c.getEmail() != null && !c.getEmail().trim().isEmpty())
                                .collect(Collectors.toList());
                        break;
                    case "with_allergies":
                        customers = customers.stream()
                                .filter(c -> c.getAllergies() != null && !c.getAllergies().trim().isEmpty())
                                .collect(Collectors.toList());
                        break;
                    case "recent":
                        // Clients des 30 derniers jours
                        LocalDate thirtyDaysAgo = LocalDate.now().minusDays(30);
                        customers = customers.stream()
                                .filter(c -> c.getCreatedAt() != null &&
                                        c.getCreatedAt().toLocalDate().isAfter(thirtyDaysAgo))
                                .collect(Collectors.toList());
                        break;
                }
            }

            // Filtrer par mois d'anniversaire
            if (birthdayMonth != null && !birthdayMonth.trim().isEmpty()) {
                int month = Integer.parseInt(birthdayMonth);
                customers = customers.stream()
                        .filter(c -> c.getDateOfBirth() != null &&
                                c.getDateOfBirth().getMonthValue() == month)
                        .collect(Collectors.toList());
            }

            // Calculer les statistiques
            int totalCustomers = allCustomers.size();
            int customersWithEmail = (int) allCustomers.stream()
                    .filter(c -> c.getEmail() != null && !c.getEmail().trim().isEmpty())
                    .count();

            int customersWithAllergies = (int) allCustomers.stream()
                    .filter(c -> c.getAllergies() != null && !c.getAllergies().trim().isEmpty())
                    .count();

            // Calculer l'âge moyen
            double averageAge = allCustomers.stream()
                    .filter(c -> c.getAge() > 0)
                    .mapToInt(Customer::getAge)
                    .average()
                    .orElse(0);

            // Trouver le dernier client
            Integer latestCustomerId = allCustomers.stream()
                    .map(Customer::getCustomerId)
                    .max(Integer::compareTo)
                    .orElse(0);

            // Définir les attributs
            request.setAttribute("customers", customers);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("customersWithEmail", customersWithEmail);
            request.setAttribute("customersWithAllergies", customersWithAllergies);
            request.setAttribute("averageAge", String.format("%.1f", averageAge));
            request.setAttribute("latestCustomerId", latestCustomerId);
            request.setAttribute("pageTitle", "Gestion des Clients");
            request.setAttribute("contentPage", "/WEB-INF/views/customers/list.jsp");

            // Forward vers la page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.err.println("ERREUR dans listCustomers: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement des clients", e);
        }
    }

    private void calculateAndAddStatistics(HttpServletRequest request, List<Customer> customers) {
        int customersWithEmail = 0;
        int customersWithAllergies = 0;
        int customersWithAddress = 0;
        int customersWithDob = 0;
        int totalAge = 0;

        for (Customer customer : customers) {
            if (customer.getEmail() != null && !customer.getEmail().trim().isEmpty()) {
                customersWithEmail++;
            }
            if (customer.getAllergies() != null && !customer.getAllergies().trim().isEmpty()) {
                customersWithAllergies++;
            }
            if (customer.getAddress() != null && !customer.getAddress().trim().isEmpty()) {
                customersWithAddress++;
            }
            if (customer.getDateOfBirth() != null) {
                customersWithDob++;
                int age = Period.between(customer.getDateOfBirth(), LocalDate.now()).getYears();
                totalAge += age;
            }
        }

        double averageAge = customersWithDob > 0 ? (double) totalAge / customersWithDob : 0;

        int totalCustomers = customerService.countAllCustomers();
        List<Customer> customersWithPrescriptionsList = customerService.getCustomersWithPrescriptions();
        int customersWithPrescriptions = customersWithPrescriptionsList.size();

        long monthsActive = 6;
        double avgClientsPerMonth = monthsActive > 0 ? (double) totalCustomers / monthsActive : totalCustomers;

        Customer latestCustomer = customerService.getLatestCustomer();
        String latestCustomerId = latestCustomer != null ? String.valueOf(latestCustomer.getCustomerId()) : "";

        request.setAttribute("customersWithEmail", customersWithEmail);
        request.setAttribute("customersWithAllergies", customersWithAllergies);
        request.setAttribute("customersWithAddress", customersWithAddress);
        request.setAttribute("customersWithPrescriptions", customersWithPrescriptions);
        request.setAttribute("averageAge", String.format("%.1f", averageAge));
        request.setAttribute("avgClientsPerMonth", String.format("%.1f", avgClientsPerMonth));
        request.setAttribute("latestCustomerId", latestCustomerId);

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int pageSize = 20;
        int totalPages = (int) Math.ceil((double) customers.size() / pageSize);

        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
    }

    private void showCustomerDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int customerId = Integer.parseInt(request.getParameter("id"));
            Customer customer = customerService.getCustomerById(customerId);

            if (customer != null) {
                // Calculer l'âge
                if (customer.getDateOfBirth() != null) {
                    int age = Period.between(customer.getDateOfBirth(), LocalDate.now()).getYears();
                    customer.setAge(age);
                }

                request.setAttribute("customer", customer);
                request.setAttribute("pageTitle", "Détails du Client");
                request.setAttribute("contentPage", "/WEB-INF/views/customers/view.jsp");

                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/customers?error=Client+non+trouvé");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customers?error=ID+client+invalide");
        }
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Customer customer = extractCustomerFromRequest(request);

            if (customerService.customerExists(customer.getEmail(), customer.getPhone())) {
                request.setAttribute("errorMessage", "Un client avec cet email ou téléphone existe déjà");
                request.setAttribute("customer", customer);
                request.setAttribute("pageTitle", "Ajouter un Client");
                request.setAttribute("contentPage", "/WEB-INF/views/customers/form.jsp");

                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
                dispatcher.forward(request, response);
                return;
            }

            customerService.addCustomer(customer);

            response.sendRedirect(request.getContextPath() +
                    "/customers?success=Client+ajouté+avec+succès");

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("customer", extractCustomerFromRequest(request));
            request.setAttribute("pageTitle", "Ajouter un Client");
            request.setAttribute("contentPage", "/WEB-INF/views/customers/form.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Récupérer l'ID du client
            int customerId = Integer.parseInt(request.getParameter("customerId"));

            // Récupérer le client existant
            Customer existingCustomer = customerService.getCustomerById(customerId);
            if (existingCustomer == null) {
                throw new IllegalArgumentException("Client non trouvé");
            }

            // Mettre à jour les données
            Customer updatedCustomer = extractCustomerFromRequest(request);
            updatedCustomer.setCustomerId(customerId);

            // Préserver la date de création
            updatedCustomer.setCreatedAt(existingCustomer.getCreatedAt());

            // Vérifier les doublons (email et téléphone)
            Customer emailCustomer = customerService.getCustomerByEmail(updatedCustomer.getEmail());
            if (emailCustomer != null && emailCustomer.getCustomerId() != customerId) {
                throw new IllegalArgumentException("Cet email est déjà utilisé par un autre client");
            }

            Customer phoneCustomer = customerService.getCustomerByPhone(updatedCustomer.getPhone());
            if (phoneCustomer != null && phoneCustomer.getCustomerId() != customerId) {
                throw new IllegalArgumentException("Ce numéro de téléphone est déjà utilisé par un autre client");
            }

            // Mettre à jour le client
            customerService.updateCustomer(updatedCustomer);

            // Rediriger avec message de succès
            response.sendRedirect(request.getContextPath() +
                    "/customers?success=Client+mis+à+jour+avec+succès");

        } catch (IllegalArgumentException e) {
            // Récupérer l'ID pour réafficher le formulaire
            int customerId = 0;
            try {
                customerId = Integer.parseInt(request.getParameter("customerId"));
            } catch (NumberFormatException ex) {
                // Ignorer
            }

            Customer customer = extractCustomerFromRequest(request);
            customer.setCustomerId(customerId);

            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("customer", customer);
            request.setAttribute("pageTitle", "Modifier le Client");
            request.setAttribute("contentPage", "/WEB-INF/views/customers/edit.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            // Gestion d'autres exceptions
            request.setAttribute("errorMessage", "Erreur lors de la mise à jour: " + e.getMessage());

            int customerId = 0;
            try {
                customerId = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException ex) {
                // Ignorer
            }

            Customer customer = extractCustomerFromRequest(request);
            customer.setCustomerId(customerId);

            request.setAttribute("customer", customer);
            request.setAttribute("pageTitle", "Modifier le Client");
            request.setAttribute("contentPage", "/WEB-INF/views/customers/form.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);
        }
    }


    private void exportCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String format = request.getParameter("format");
        if (format == null) format = "csv";

        try {
            List<Customer> customers = customerService.getAllCustomers();

            if ("csv".equalsIgnoreCase(format)) {
                exportToCSV(response, customers);
            } else if ("pdf".equalsIgnoreCase(format)) {
                exportToPDF(response, customers);
            }

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/customers?error=Erreur+lors+de+l'export");
        }
    }

    private void exportToCSV(HttpServletResponse response, List<Customer> customers) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"clients.csv\"");

        StringBuilder csv = new StringBuilder();
        csv.append("ID,Nom,Prénom,Téléphone,Email,Date de Naissance,Adresse,Allergies\n");

        for (Customer customer : customers) {
            csv.append(customer.getCustomerId()).append(",")
                    .append(escapeCsv(customer.getLastName())).append(",")
                    .append(escapeCsv(customer.getFirstName())).append(",")
                    .append(escapeCsv(customer.getPhone())).append(",")
                    .append(escapeCsv(customer.getEmail())).append(",")
                    .append(customer.getDateOfBirth() != null ? customer.getDateOfBirth() : "").append(",")
                    .append(escapeCsv(customer.getAddress())).append(",")
                    .append(escapeCsv(customer.getAllergies())).append("\n");
        }

        response.getWriter().write(csv.toString());
        response.getWriter().flush();
    }

    private void exportToPDF(HttpServletResponse response, List<Customer> customers) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"clients.pdf\"");
        // TODO: Implémenter l'export PDF avec iText ou une autre bibliothèque
        response.getWriter().write("Export PDF non encore implémenté");
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }

    private void checkEmailExists(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String email = request.getParameter("email");
            String currentCustomerId = request.getParameter("customerId");

            Customer existingCustomer = customerService.getCustomerByEmail(email);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (existingCustomer != null) {
                if (currentCustomerId != null && !currentCustomerId.isEmpty()) {
                    int id = Integer.parseInt(currentCustomerId);
                    if (existingCustomer.getCustomerId() == id) {
                        response.getWriter().write("{\"exists\": false}");
                        return;
                    }
                }
                response.getWriter().write("{\"exists\": true}");
            } else {
                response.getWriter().write("{\"exists\": false}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void checkPhoneExists(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String phone = request.getParameter("phone");
            String currentCustomerId = request.getParameter("customerId");

            Customer existingCustomer = customerService.getCustomerByPhone(phone);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (existingCustomer != null) {
                if (currentCustomerId != null && !currentCustomerId.isEmpty()) {
                    int id = Integer.parseInt(currentCustomerId);
                    if (existingCustomer.getCustomerId() == id) {
                        response.getWriter().write("{\"exists\": false}");
                        return;
                    }
                }
                response.getWriter().write("{\"exists\": true}");
            } else {
                response.getWriter().write("{\"exists\": false}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private Customer extractCustomerFromRequest(HttpServletRequest request) {
        Customer customer = new Customer();

        customer.setFirstName(request.getParameter("firstName"));
        customer.setLastName(request.getParameter("lastName"));
        customer.setPhone(request.getParameter("phone"));
        customer.setEmail(request.getParameter("email"));

        String dateOfBirthStr = request.getParameter("dateOfBirth");
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                customer.setDateOfBirth(LocalDate.parse(dateOfBirthStr));
            } catch (DateTimeParseException e) {
                // Laisser null si la date est invalide
            }
        }

        customer.setAddress(request.getParameter("address"));
        customer.setAllergies(request.getParameter("allergies"));

        return customer;
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
                             Exception e, String redirectPath)
            throws ServletException, IOException {

        e.printStackTrace();

        if (response.isCommitted()) {
            return;
        }

        String errorMessage = "Erreur : " + e.getMessage();
        response.sendRedirect(request.getContextPath() + redirectPath + "?error=" +
                java.net.URLEncoder.encode(errorMessage, "UTF-8"));
    }



    // Ajouter un client
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "Ajouter un Client");
        request.setAttribute("contentPage", "/WEB-INF/views/customers/form.jsp");

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
        dispatcher.forward(request, response);
    }

    // Modifier un client
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String id = request.getParameter("id");
            if (id == null || id.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customers?error=ID client manquant");
                return;
            }

            Customer customer = customerService.getCustomerById(Integer.parseInt(id));
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/customers?error=Client non trouvé");
                return;
            }

            request.setAttribute("customer", customer);
            request.setAttribute("pageTitle", "Modifier le Client");
            request.setAttribute("contentPage", "/WEB-INF/views/customers/edit.jsp");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/layout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/customers?error=" +
                    URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    // Sauvegarder un client
    private void saveCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Customer customer = extractCustomer(request);
            customer.setAllergies(request.getParameter("allergies"));

            // Date de naissance
            String dob = request.getParameter("dateOfBirth");
            if (dob != null && !dob.trim().isEmpty()) {
                customer.setDateOfBirth(java.time.LocalDate.parse(dob));
            }

            // ID pour la mise à jour
            String id = request.getParameter("id");
            if (id != null && !id.trim().isEmpty()) {
                customer.setCustomerId(Integer.parseInt(id));
                customerService.updateCustomer(customer);
            } else {
                customerService.addCustomer(customer);
            }

            String successMessage = "Client " + (id != null ? "modifié" : "ajouté") + " avec succès";
            response.sendRedirect(request.getContextPath() + "/customers?success=" +
                    URLEncoder.encode(successMessage, "UTF-8"));

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/customers?error=" +
                    URLEncoder.encode("Erreur: " + e.getMessage(), "UTF-8"));
        }
    }

    // Supprimer un client
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String id = request.getParameter("id");
            if (id == null || id.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customers?error=ID client manquant");
                return;
            }

            customerService.deleteCustomer(Integer.parseInt(id));

            response.sendRedirect(request.getContextPath() + "/customers?success=" +
                    URLEncoder.encode("Client supprimé avec succès", "UTF-8"));

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/customers?error=" +
                    URLEncoder.encode("Erreur: " + e.getMessage(), "UTF-8"));
        }
    }
}