public with sharing class DomainExtractor {
    public static String DomainExtractorFromLeadEmail(String email) {
        return email.split('@').get(1);
    }

    public static String DomainExtractorFromAccountWebSite(String website) {

        String domain = website.replaceAll('^(http://|https://)', '').replaceAll('^www\\.', '');
        Integer endIndex = domain.indexOf('/');

        if (endIndex != -1) {
            domain = domain.substring(0, endIndex).toLowerCase();
        }

        return domain;
    }

}