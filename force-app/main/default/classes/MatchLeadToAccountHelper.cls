public with sharing class MatchLeadToAccountHelper {
    
    private static final Integer MIN_LEAD_COMPANY_LENGTH = 4;

    public static List<Lead> matchLeadsToAccountsByDomain(List<Lead> leadList, Map<String, Account> accMap){ //domainToAccount
        List<Lead> leadListWithoutMatch = new List<Lead>();
        for (Lead lead : leadList) {
            if (String.isBlank(lead.Email)) {
                leadListWithoutMatch.add(lead);
                continue; // if lead without email continue to next one.
            }
            String domainFromEmail = DomainExtractor.DomainExtractorFromLeadEmail(lead.Email);
            if (accMap.get(domainFromEmail) != null) {
                modifyLeadWithMatchedAccount(lead, accMap.get(domainFromEmail));
            } else {
                leadListWithoutMatch.add(lead);	
            }
        }
        return leadListWithoutMatch;
    }
    
    public static List<Lead> directMatchLeadsToAccountsByCompanyName(List<Lead> leadListWithCompanyName, Map<String, Account> accMap){
        List<Lead> leadListWithoutMatch = new List<Lead>();
        for (Lead lead : leadListWithCompanyName) {
            String leadCompanyLowerCase = lead.Company.toLowerCase();
            if (accMap.get(leadCompanyLowerCase) != null) {
                modifyLeadWithMatchedAccount(lead, accMap.get(leadCompanyLowerCase));
            } else {
                leadListWithoutMatch.add(lead);
            }
        }
        return leadListWithoutMatch;
    }

    public static void partialMatchLeadsToAccountsByCompanyName(List<Lead> leadList, List<Account> accList){
        for (Lead lead : leadList) {
            if (lead.Company.length() < MIN_LEAD_COMPANY_LENGTH) {
                continue; // Partial Matching is not available for leads with company field length below 4.
            }
            Account matchedAccount = null;
            String lowerCaseLeadCompany = lead.Company.toLowerCase();
            Integer nameMatchesCounter = 0;
            for (Account acc : accList) {
                String lowerCaseAccName = acc.Name.toLowerCase();
                if (lowerCaseAccName.contains(lowerCaseLeadCompany)) {
                    nameMatchesCounter++;
                    matchedAccount = acc;
                }
                if (nameMatchesCounter > 1) {
                    break;
                } 
            }
            if(nameMatchesCounter == 1) {
                modifyLeadWithMatchedAccount(lead, matchedAccount);
            }
        }
    }
    
    public static void modifyLeadWithMatchedAccount(Lead lead, Account acc) {
        lead.Account__c = acc.Id;
        lead.OwnerId = acc.OwnerId;
        if (!String.isBlank(lead.Industry)) {
            lead.Industry = acc.Industry;
        }
        lead.isMatchedAutomatically__c = 1;
    }
}