package com.onemaster.pharmaplus.controller;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Text;
import com.itextpdf.layout.properties.TextAlignment;
import com.onemaster.pharmaplus.model.MedicalReceipt;
import com.onemaster.pharmaplus.service.MedicalReceiptService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.time.format.DateTimeFormatter;

@WebServlet("/medical-receipts/print")
public class MedicalReceiptPrintServlet extends HttpServlet {

    private MedicalReceiptService receiptService;

    @Override
    public void init() {
        receiptService = new MedicalReceiptService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String receiptId = request.getParameter("id");

        if (receiptId == null || receiptId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de reçu requis");
            return;
        }

        try {
            MedicalReceipt receipt = receiptService.getReceiptById(Integer.parseInt(receiptId));

            if (receipt == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Reçu non trouvé");
                return;
            }

            byte[] pdfBytes = generateReceiptPDF(receipt);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                    "inline; filename=\"receipt-medical-" + receipt.getReceiptNumber() + ".pdf\"");
            response.setContentLength(pdfBytes.length);

            OutputStream out = response.getOutputStream();
            out.write(pdfBytes);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de la génération du reçu", e);
        }
    }

    private byte[] generateReceiptPDF(MedicalReceipt receipt) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        // Format spécifique basé sur votre PDF (environ 80mm x 2 tickets)
        PageSize pageSize = new PageSize(226.77f, 600f); // 80mm de large, hauteur pour 2 tickets

        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc, pageSize);

        // Marges minimales pour ticket
        document.setMargins(5, 5, 5, 5);

        // === PREMIER TICKET ===
        addReceiptTicket(document, receipt, 1);

        // Séparateur entre les tickets
        document.add(new Paragraph("\n\n══════════════════════════════════════════\n\n")
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(6));

        // === DEUXIÈME TICKET (copie) ===
        addReceiptTicket(document, receipt, 2);

        document.close();
        return baos.toByteArray();
    }

    private void addReceiptTicket(Document document, MedicalReceipt receipt, int copyNumber) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        String receiptDate = receipt.getReceiptDate() != null ?
                receipt.getReceiptDate().format(formatter) : "N/A";

        DecimalFormat df = new DecimalFormat("#,##0");

        // === EN-TÊTE DU TICKET ===
        Paragraph header = new Paragraph()
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(8);

        header.add(new Text("MINISTÈRE DE LA SANTÉ ET DE L'HYGIÈNE PUBLIQUE\n")
                .setBold()
                .setFontSize(9));
        header.add(new Text("ET DE LA COUVERTURE MALADIE UNIVERSELLE\n")
                .setBold()
                .setFontSize(9));
        header.add(new Text("CENTRE DE SANTÉ URBAIN SŒURS PASSIONISTES\n")
                .setBold()
                .setFontSize(9));
        header.add("Abadjin-Doumé (route de Dabou km 17, carrefour institut pasteur)\n");
        header.add("Tel : (+225) 07 12 64 36 66 - 07 15 56 68 01\n");
        header.add("══════════════════════════════════════════\n\n");

        document.add(header);

        // === INFORMATIONS PRINCIPALES ===
        Paragraph mainInfo = new Paragraph()
                .setFontSize(9)
                .setTextAlignment(TextAlignment.LEFT);

        mainInfo.add(String.format("%-12s ________________________\n", "RECU N°"));
        mainInfo.add(String.format("%-12s ________________________\n", "DATE"));
        mainInfo.add(String.format("%-12s ________________________\n", "PATIENT"));
        mainInfo.add(String.format("%-12s ________________________\n", ""));
        mainInfo.add(String.format("%-12s ________________________\n", "PRESTATION"));
        mainInfo.add(String.format("%-12s ________________________\n", "MONTANT"));
        mainInfo.add(String.format("%-12s ________________________\n", "CONTACT"));

        document.add(mainInfo);

        // === CHAMPS À REMPLIR ===
        Paragraph fields = new Paragraph()
                .setFontSize(8)
                .setTextAlignment(TextAlignment.LEFT);

        fields.add("Somme (en lettres) : ");
        if (receipt.getAmountInWords() != null && !receipt.getAmountInWords().isEmpty()) {
            fields.add(new Text(receipt.getAmountInWords() + "\n").setBold());
        } else {
            fields.add("................................................................................................\n");
        }

        fields.add("Nom et Prénoms : ");
        if (receipt.getPatientName() != null) {
            fields.add(new Text(receipt.getPatientName() + "\n").setBold());
        } else {
            fields.add("................................................................................................\n");
        }

        fields.add("Contacts : ");
        if (receipt.getPatientContact() != null) {
            fields.add(new Text(receipt.getPatientContact() + "\n").setBold());
        } else {
            fields.add("................................................................................................\n");
        }

        fields.add("Nature de prestation : ");
        if (receipt.getServiceType() != null) {
            fields.add(new Text(receipt.getServiceType() + "\n").setBold());
        } else {
            fields.add("................................................................................................\n");
        }

        // Espace pour les observations
        fields.add("\n\n\n"); // Lignes vides comme dans le PDF

        document.add(fields);

        // === NOTES ===
        Paragraph notes = new Paragraph()
                .setFontSize(7)
                .setTextAlignment(TextAlignment.CENTER);

        notes.add("NB. Ce reçu est valable pour 7 Jours.\n");
        document.add(notes);

        // === RÉCAPITULATIF EN BAS ===
        Paragraph recap = new Paragraph()
                .setFontSize(8)
                .setTextAlignment(TextAlignment.CENTER);

        recap.add("══════════════════════════════════════════\n");

        // Première ligne avec les informations
        Paragraph infoLine = new Paragraph()
                .setFontSize(8)
                .setTextAlignment(TextAlignment.LEFT);

        infoLine.add(String.format("%-20s%-20s%-20s\n",
                "RECU N° " + (receipt.getReceiptNumber() != null ?
                        receipt.getReceiptNumber().substring(0, Math.min(10, receipt.getReceiptNumber().length())) : "______"),
                "DATE " + receiptDate.substring(0, Math.min(10, receiptDate.length())),
                "MONTANT " + (receipt.getAmount() != null ? df.format(receipt.getAmount()) : "______")));

        document.add(infoLine);

        // === CATÉGORIES DE SERVICES ===
        Paragraph services = new Paragraph()
                .setFontSize(7)
                .setTextAlignment(TextAlignment.CENTER);

        services.add("\n");

        // Créer une grille de services comme dans le PDF
        String[][] serviceGrid = {
                {"Ophtamo", "Gynéco", "Écho", "Labo"},
                {"Consultation", "Consultation", "Consultation", "Dermato"},
                {"générale", "générale", "prénatale", "Dentiste"},
                {"", "", "", "Autre"}
        };

        // Afficher la grille
        for (String[] row : serviceGrid) {
            StringBuilder rowText = new StringBuilder();
            for (String service : row) {
                rowText.append(String.format("%-15s", service));
            }
            services.add(rowText.toString().trim() + "\n");
        }

        services.add("\n");
        services.add("La Caissière\n");

        document.add(services);

        // === SIGNATURE / SERVICE ===
        Paragraph signature = new Paragraph()
                .setFontSize(8)
                .setTextAlignment(TextAlignment.CENTER);

        signature.add("\n");
        signature.add(new Text("C.S.U.S.P\n").setBold());

        if (receipt.getServedBy() != null) {
            signature.add("Servi par: " + receipt.getServedBy() + "\n");
        }

        // Numéro de copie
        signature.add(new Text("(Copie " + copyNumber + ")\n")
                .setFontSize(6)
                .setItalic());

        document.add(signature);

        // Séparateur entre les sections si pas la dernière copie
        if (copyNumber < 2) {
            document.add(new Paragraph("\n══════════════════════════════════════════\n\n")
                    .setTextAlignment(TextAlignment.CENTER)
                    .setFontSize(6));
        }
    }

    // Version alternative si vous voulez un format plus simple
    private byte[] generateSimpleReceiptPDF(MedicalReceipt receipt) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        // Format A6 (105 x 148 mm)
        PageSize pageSize = new PageSize(298, 421);

        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc, pageSize);

        document.setMargins(10, 10, 10, 10);

        // Header
        Paragraph header = new Paragraph()
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(9);

        header.add(new Text("MINISTÈRE DE LA SANTÉ ET DE L'HYGIÈNE PUBLIQUE\n").setBold());
        header.add(new Text("CENTRE DE SANTÉ URBAIN SŒURS PASSIONISTES\n").setBold());
        header.add("Abadjin-Doumé, route de Dabou km 17\n");
        header.add("Tel: (+225) 07 12 64 36 66\n");
        header.add("══════════════════════════════════════\n\n");

        document.add(header);

        // Receipt Info
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        String dateStr = receipt.getReceiptDate() != null ?
                receipt.getReceiptDate().format(dtf) : "N/A";

        DecimalFormat df = new DecimalFormat("#,##0");

        Paragraph info = new Paragraph()
                .setFontSize(10);

        info.add(String.format("RECU N°: %s\n", receipt.getReceiptNumber()));
        info.add(String.format("DATE: %s\n", dateStr));
        info.add(String.format("PATIENT: %s\n", receipt.getPatientName()));

        if (receipt.getPatientContact() != null) {
            info.add(String.format("CONTACT: %s\n", receipt.getPatientContact()));
        }

        info.add(String.format("PRESTATION: %s\n", receipt.getServiceType()));
        info.add(String.format("MONTANT: %s F CFA\n\n", df.format(receipt.getAmount())));

        info.add("══════════════════════════════════════\n");

        document.add(info);

        // Amount in words
        if (receipt.getAmountInWords() != null) {
            Paragraph words = new Paragraph()
                    .setFontSize(9);

            words.add("Montant en lettres:\n");
            words.add(new Text(receipt.getAmountInWords()).setItalic());
            words.add("\n\n");

            document.add(words);
        }

        // Footer
        Paragraph footer = new Paragraph()
                .setFontSize(8)
                .setTextAlignment(TextAlignment.CENTER);

        footer.add("NB. Ce reçu est valable pour 7 jours\n");
        footer.add("══════════════════════════════════════\n");
        footer.add(new Text("C.S.U.S.P\n").setBold());

        if (receipt.getServedBy() != null) {
            footer.add("Servi par: " + receipt.getServedBy() + "\n");
        }

        footer.add(dateStr.substring(0, 10) + " - " + receipt.getReceiptNumber());

        document.add(footer);

        document.close();
        return baos.toByteArray();
    }
}