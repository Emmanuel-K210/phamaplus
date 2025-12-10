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

            byte[] pdfBytes = generateSimpleReceiptPDF(receipt);

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

    // Version alternative si vous voulez un format plus simple
    private byte[] generateSimpleReceiptPDF(MedicalReceipt receipt) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        // Format A6 (80 x 148 mm)
        PageSize pageSize = new PageSize(226.77f, 421);

        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc, pageSize);

        document.setMargins(15, 15, 15, 15);

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