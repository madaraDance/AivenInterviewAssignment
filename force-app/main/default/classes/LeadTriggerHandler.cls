public class LeadTriggerHandler {
	public static void matchLeadsToAccounts(List<Lead> leadList){
		Map<String, Account> accNameToAccount = new Map<String, Account>();
		Map<String, Account> accDomainToAccount = new Map<String, Account>();
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
			List<Account> accList = [
				SELECT Name, Website, Domain__c, OwnerId, Industry
				FROM Account 
				WHERE Name LIKE :nameSearchPatterns OR Domain__c IN: domainSearchPatterns
			];
			if (!accList.isEmpty()) {
				for (Account acc : accList) {
					accNameToAccount.put(acc.Name.toLowerCase(), acc);
					if (!String.isBlank(acc.Domain__c)) {
						accDomainToAccount.put(acc.Domain__c.toLowerCase(), acc); //
					}	
				}
				if (!accDomainToAccount.isEmpty()) { //if accDomainMap is empty no leads to match with domain comaprisson.
					leadListWithoutAccounts = MatchLeadToAccountHelper.matchLeadsToAccountsByDomain(leadListWithoutAccounts, accDomainToAccount); //returns list with values or emtpy list.
				}
				if (!leadListWithoutAccounts.isEmpty()) {
					leadListWithoutAccounts = MatchLeadToAccountHelper.directMatchLeadsToAccountsByCompanyName(leadListWithoutAccounts, accNameToAccount); // returns list with values or emtpy list.
					if (!leadListWithoutAccounts.isEmpty()) {
						MatchLeadToAccountHelper.partialMatchLeadsToAccountsByCompanyName(leadListWithoutAccounts, accList); // void method
					}
				}
			}
		}
	}
}