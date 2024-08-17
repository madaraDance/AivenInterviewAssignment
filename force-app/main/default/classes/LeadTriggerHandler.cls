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
					domainSearchPatterns.add(lead.Email.split('@').get(1));
				} else {
					nameSearchPatterns.add('%' + lead.Company.toLowerCase() + '%');
				}
			}
		}

		if(!leadListWithoutAccounts.isEmpty()) {
			List<Account> accList = [SELECT Name, Website, Domain__c, OwnerId, Industry FROM Account WHERE Name LIKE :nameSearchPatterns OR Domain__c IN: domainSearchPatterns];
			if (!accList.isEmpty()) {
				for (Account acc : accList) {
					accNameMap.put(acc.Name.toLowerCase(), acc);
					accDomainMap.put(acc.Domain__c.toLowerCase(), acc);
				}

				List<Lead> leadListWithCompanyName = matchLeadsToAccountsByDomain(leadListWithoutAccounts, accDomainMap);
				if (leadListWithCompanyName != null){
					List<Lead> leadListWithoutMatch = directMatchLeadsToAccountsByCompanyName(leadListWithCompanyName, accNameMap);
					if (leadListWithoutMatch.size() > 0) {
						partialMatchLeadsToAccountsByCompanyName(leadListWithoutMatch, accList);
					}
				}
			}
		}
	}

	public static List<Lead> matchLeadsToAccountsByDomain(List<Lead> leadList, Map<String, Account> accMap){
		List<Lead> leadListWithoutMatchAndWithCompanyName = new List<Lead>();
		if (leadList == null || leadList.isEmpty()){
			return null;
		}
		for (Lead lead : leadList){
			String domainFromEmail = lead.Email?.split('@').get(1);
			if (accMap.get(domainFromEmail) != null){
				modifyLeadWithMatchedAccount(lead, accMap.get(domainFromEmail));
			} else {
				leadListWithoutMatchAndWithCompanyName.add(lead);	
			}
		}
		return leadListWithoutMatchAndWithCompanyName;
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
		Set<String> nameSearchPatterns  = new Set<String>();

		for (Lead lead : leadList) {
			if (lead.Company.length() < 6) {
				continue;
			}

			Account matchedAccount = null;
			String lowerCaseCompany = lead.Company.toLowerCase();
			Integer nameMatches = 0;

			for (Account acc : accList) {
				String lowerCaseName = acc.Name.toLowerCase();
				if (lowerCaseName.contains(lowerCaseCompany)){
					nameMatches++;
					//if(lowerCaseName.getLevenshteinDistance(lowerCaseCompany, 3) != -1){
					if (lowerCaseName.length() - lowerCaseCompany.length() < 4){
						matchedAccount = acc;
					}
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