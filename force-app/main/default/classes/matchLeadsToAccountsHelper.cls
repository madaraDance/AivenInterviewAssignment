public with sharing class matchLeadsToAccountsHelper {
    
    public static List<Lead> matchLeadsToAccountsByDomain(List<Lead> leadList, Map<String, Account> accMap){
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
			if (lead.Company.length() < 6) {
				continue; // Partial Matching is not available for leads with company field length below 6.
			}

			Account matchedAccount = null;
			String lowerCaseCompany = lead.Company.toLowerCase();
			Integer nameMatches = 0;

			for (Account acc : accList) {
				String lowerCaseName = acc.Name.toLowerCase();
				if (lowerCaseName.contains(lowerCaseCompany)) {
					nameMatches++;
					//if (lowerCaseName.length() - lowerCaseCompany.length() < 4){
						matchedAccount = acc;
					//}
				}
				if (nameMatches > 1) {
					break;
				} 
			}
			if(nameMatches == 1) {
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