public class LeadTriggerHandler {
	public static void matchLeadToAccountByCompanyNameOrDomain(List<Lead> leadList){
		Map<String, Account> accNameMap = new Map<String, Account>();
		Map<String, Account> accDomainMap = new Map<String, Account>();
		List<Lead> leadListWithoutAccounts = new List<Lead>();
		List<String> nameSearchPatterns  = new List<String>();
		List<String> domainSearchPatterns = new List<String>();
		
		for (Lead lead : leadList){
			
			if (lead.Account__c == null) {
				leadListWithoutAccounts.add(lead);

				if (!String.isBlank(lead.Email)) {
					String emailDomain = DomainExtractor.DomainExtractorFromLeadEmail(lead.Email);
					domainSearchPatterns.add(emailDomain);
				}
				nameSearchPatterns.add('%' + lead.Company.toLowerCase() + '%');
			}
		}

		if(!leadListWithoutAccounts.isEmpty()) {
			List<Account> accList = [SELECT Name, Website, Domain__c, OwnerId, Industry FROM Account WHERE Name LIKE :nameSearchPatterns OR Domain__c IN: domainSearchPatterns];
			if (!accList.isEmpty()) {
				for (Account acc : accList) {
					accNameMap.put(acc.Name.toLowerCase(), acc);
					if (!String.isBlank(acc.Domain__c)){
						accDomainMap.put(acc.Domain__c.toLowerCase(), acc);
					}	
				}
				if (!accDomainMap.isEmpty()){
					leadListWithoutAccounts = matchLeadsToAccountsByDomain(leadListWithoutAccounts, accDomainMap); //returns list with values or emtpy list.
				}

				if (!leadListWithoutAccounts.isEmpty()){
					leadListWithoutAccounts = directMatchLeadsToAccountsByCompanyName(leadListWithoutAccounts, accNameMap); // returns list with values or emtpy list.
					if (!leadListWithoutAccounts.isEmpty()) {
						partialMatchLeadsToAccountsByCompanyName(leadListWithoutAccounts, accList); // void method
					}
				}
			}
		}
	}

	public static List<Lead> matchLeadsToAccountsByDomain(List<Lead> leadList, Map<String, Account> accMap){
		List<Lead> leadListWithoutMatch = new List<Lead>();
		for (Lead lead : leadList){

			if (String.isBlank(lead.Email)) {
				leadListWithoutMatch.add(lead);
				continue; // if lead without email continue to next one.
			}

			String domainFromEmail = DomainExtractor.DomainExtractorFromLeadEmail(lead.Email);
			if (accMap.get(domainFromEmail) != null){
				modifyLeadWithMatchedAccount(lead, accMap.get(domainFromEmail));
			} else {
				leadListWithoutMatch.add(lead);	
			}
		}
		return leadListWithoutMatch;
	}

	public static List<Lead> directMatchLeadsToAccountsByCompanyName(List<Lead> leadListWithCompanyName, Map<String, Account> accMap){
		List<Lead> leadListWithoutMatch = new List<Lead>();
		for (Lead lead : leadListWithCompanyName){
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
				if (lowerCaseName.contains(lowerCaseCompany)){
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