package com.onemaster.pharmaplus.controller;

import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Text;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.onemaster.pharmaplus.dao.impl.SaleDAOImpl;
import com.onemaster.pharmaplus.dao.service.SaleDAO;
import com.onemaster.pharmaplus.model.Sale;
import com.onemaster.pharmaplus.model.SaleItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/sales/thermal-ticket")
public class ThermalTicketServlet extends BaseServlet {


    private final SaleDAO saleDAO = new SaleDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Récupérez l'ID de la vente depuis les paramètres
        String saleId = request.getParameter("id");
        
        if (saleId == null || saleId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de vente requis");
            return;
        }
        
        try {
            Sale sale = saleService.getSaleWithItems(Integer.parseInt(saleId));
            if (sale == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Vente non trouvée");
                return;
            }
            
            List<SaleItem> items = saleDAO.findItemsBySaleId(sale.getSaleId());

            // Créez le ticket thermique
            byte[] pdfBytes = generateThermalTicket(sale, items);
            
            // Configurez la réponse
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", 
                "inline; filename=\"ticket-sale-" + saleId + ".pdf\"");
            response.setContentLength(pdfBytes.length);
            
            // Écrivez le PDF dans la réponse
            OutputStream out = response.getOutputStream();
            out.write(pdfBytes);
            out.flush();
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de vente invalide");
        } catch (Exception e) {
            e.printStackTrace(); // Pour le débogage
            throw new ServletException("Erreur lors de la génération du ticket", e);
        }
    }

    private byte[] generateThermalTicket(Sale sale, List<SaleItem> items) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        // Taille ticket 80mm (80mm = 226.77 points, hauteur auto)
        PageSize pageSize = new PageSize(226.77f, PageSize.A4.getHeight());

        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc, pageSize);

        // Marges minimales pour ticket thermique
        document.setMargins(15, 15, 15, 15);

        // Police monospace pour alignement parfait
        PdfFont font;
        try {
            font = PdfFontFactory.createFont("Courier");
        } catch (Exception e) {
            font = PdfFontFactory.createFont(); // Police par défaut si Courier non disponible
        }

        // === EN-TÊTE ===
        Paragraph header = new Paragraph()
                .setTextAlignment(TextAlignment.CENTER)
                .setFont(font)
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

        // === INFORMATIONS VENTE ===
        Paragraph info = new Paragraph()
                .setFont(font)
                .setFontSize(8);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        String saleDate = sale.getSaleDate() != null ?
                sale.getSaleDate().format(formatter) : "N/A";

        info.add(String.format("%-15s: #%s\n", "Transaction", sale.getSaleId()));
        info.add(String.format("%-15s: %s\n", "Date", saleDate));
        info.add(String.format("%-15s: %s\n", "Servi par", 
                sale.getServedBy() != null ? sale.getServedBy() : "N/A"));
        info.add(String.format("%-15s: %s\n", "Client", 
                sale.getCustomerName() != null ? sale.getCustomerName() : "Vente anonyme"));
        info.add(String.format("%-15s: %s\n", "Mode", 
                getPaymentMethodLabel(sale.getPaymentMethod())));
        info.add("------------------------------------------\n");

        document.add(info);

        // === ARTICLES ===
        if (items != null && !items.isEmpty()) {
            // Largeurs des colonnes (ajustées pour 80mm)
            float[] columnWidths = {3, 1, 2, 2}; // Ratio 3:1:2:2
            
            Table table = new Table(UnitValue.createPercentArray(columnWidths))
                    .setBorder(null)
                    .setFont(font)
                    .setFontSize(7)
                    .setWidth(UnitValue.createPercentValue(100));

            // En-têtes
            table.addHeaderCell(new Cell().add(new Paragraph("Produit")).setBorder(null).setBold());
            table.addHeaderCell(new Cell().add(new Paragraph("Qté")).setBorder(null).setBold().setTextAlignment(TextAlignment.CENTER));
            table.addHeaderCell(new Cell().add(new Paragraph("P.U")).setBorder(null).setBold().setTextAlignment(TextAlignment.RIGHT));
            table.addHeaderCell(new Cell().add(new Paragraph("Total")).setBorder(null).setBold().setTextAlignment(TextAlignment.RIGHT));

            DecimalFormat df = new DecimalFormat("#,##0");

            for (SaleItem item : items) {
                // Tronquer le nom du produit si trop long
                String productName = item.getProductName();
                if (productName.length() > 20) {
                    productName = productName.substring(0, 17) + "...";
                }

                table.addCell(new Cell().add(new Paragraph(productName)).setBorder(null));
                table.addCell(new Cell().add(new Paragraph(String.valueOf(item.getQuantity()))).setBorder(null)
                        .setTextAlignment(TextAlignment.CENTER));
                table.addCell(new Cell().add(new Paragraph(df.format(item.getUnitPrice()) + " F")).setBorder(null)
                        .setTextAlignment(TextAlignment.RIGHT));
                table.addCell(new Cell().add(new Paragraph(df.format(item.getLineTotal()) + " F")).setBorder(null)
                        .setTextAlignment(TextAlignment.RIGHT));
            }

            document.add(table);
            
            // Ligne vide après le tableau
            document.add(new Paragraph("\n"));
        }

        // === TOTAUX ===
        Paragraph total = new Paragraph()
                .setFont(font)
                .setFontSize(8);

        DecimalFormat df = new DecimalFormat("#,##0");

        total.add("------------------------------------------\n");
        
        // Sous-total
        total.add(String.format("%-20s%10s F\n",
                "Sous-total:", 
                sale.getSubtotal() != null ? df.format(sale.getSubtotal()) : "0"));
        
        // Remise (si applicable)
        if (sale.getDiscountAmount() != null && sale.getDiscountAmount() > 0) {
            total.add(String.format("%-20s%10s F\n",
                    "Remise:", "-" + df.format(sale.getDiscountAmount())));
        }
        
        // Taxes (si applicable)
        if (sale.getTaxAmount() != null && sale.getTaxAmount() > 0) {
            total.add(String.format("%-20s%10s F\n",
                    "Taxes:", df.format(sale.getTaxAmount())));
        }
        
        total.add("------------------------------------------\n");
        
        // TOTAL
        total.add(String.format("%-20s%10s F\n",
                "TOTAL:",
                sale.getTotalAmount() != null ? df.format(sale.getTotalAmount()) : "0"));
        
        total.add("------------------------------------------\n");
        
        // Montant payé
        total.add(String.format("%-20s%10s F\n",
                "Montant payé:",
                sale.getTotalAmount() != null ? df.format(sale.getTotalAmount()) : "0"));
        
        total.add("==========================================\n\n");

        document.add(total);

        // === PIED DE PAGE ===
        Paragraph footer = new Paragraph()
                .setFont(font)
                .setTextAlignment(TextAlignment.CENTER)
                .setFontSize(7);

        footer.add(new Text("MERCI DE VOTRE CONFIANCE !\n").setBold());
        footer.add("Conservez ce reçu précieusement\n");
        footer.add(new Text(saleDate + " - #" + sale.getSaleId())
                .setFontSize(6));

        document.add(footer);

        document.close();
        return baos.toByteArray();
    }

    private String getPaymentMethodLabel(String method) {
        if (method == null) return "INCONNU";
        switch (method.toLowerCase()) {
            case "cash": return "ESPÈCES";
            case "card": return "CARTE";
            case "mobile": return "MOBILE";
            case "insurance": return "ASSURANCE";
            default: return method.toUpperCase();
        }
    }
}