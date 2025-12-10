package com.onemaster.pharmaplus.utils;

import java.text.DecimalFormat;

public class AmountToWordsConverter {
    
    private static final String[] UNITS = {
        "", "un", "deux", "trois", "quatre", "cinq", "six", "sept", "huit", "neuf", "dix",
        "onze", "douze", "treize", "quatorze", "quinze", "seize", "dix-sept", "dix-huit", "dix-neuf"
    };
    
    private static final String[] TENS = {
        "", "", "vingt", "trente", "quarante", "cinquante", "soixante", "soixante-dix", 
        "quatre-vingt", "quatre-vingt-dix"
    };
    
    public static String convert(double amount) {
        if (amount == 0) {
            return "zéro francs CFA";
        }
        
        long entier = (long) amount;
        long decimal = Math.round((amount - entier) * 100);
        
        String result = convertNumberToWords(entier);
        
        if (decimal > 0) {
            result += " francs et " + convertNumberToWords(decimal) + " centimes";
        } else {
            result += " francs CFA";
        }
        
        return result.substring(0, 1).toUpperCase() + result.substring(1);
    }
    
    private static String convertNumberToWords(long number) {
        if (number < 20) {
            return UNITS[(int) number];
        }
        
        if (number < 100) {
            int unit = (int) (number % 10);
            int ten = (int) (number / 10);
            
            if (ten == 7 || ten == 9) {
                // Soixante-dix et quatre-vingt-dix
                return TENS[ten - 1] + (unit == 1 ? " et " : "-") + UNITS[unit + 10];
            } else if (unit == 0) {
                return TENS[ten] + (ten == 8 ? "s" : "");
            } else if (unit == 1) {
                return TENS[ten] + " et " + UNITS[unit];
            } else {
                return TENS[ten] + "-" + UNITS[unit];
            }
        }
        
        if (number < 1000) {
            int hundred = (int) (number / 100);
            long remainder = number % 100;
            
            String result = (hundred == 1 ? "cent" : UNITS[hundred] + " cents");
            if (remainder > 0) {
                result += " " + convertNumberToWords(remainder);
            }
            return result;
        }
        
        if (number < 1000000) {
            int thousand = (int) (number / 1000);
            long remainder = number % 1000;
            
            String result = (thousand == 1 ? "mille" : convertNumberToWords(thousand) + " mille");
            if (remainder > 0) {
                result += " " + convertNumberToWords(remainder);
            }
            return result;
        }
        
        if (number < 1000000000) {
            int million = (int) (number / 1000000);
            long remainder = number % 1000000;
            
            String result = (million == 1 ? "un million" : convertNumberToWords(million) + " millions");
            if (remainder > 0) {
                result += " " + convertNumberToWords(remainder);
            }
            return result;
        }
        
        // Pour les très grands nombres
        DecimalFormat df = new DecimalFormat("#,###");
        return df.format(number);
    }
    
    public static void main(String[] args) {
        // Tests
        System.out.println(convert(1234567.89));
        System.out.println(convert(1000.00));
        System.out.println(convert(250.50));
        System.out.println(convert(75.00));
    }
}