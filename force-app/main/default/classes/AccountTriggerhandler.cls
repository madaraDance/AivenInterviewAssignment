public with sharing class AccountTriggerhandler {
    public static void setDomainFieldFromWebsite(List<Account> accList) {
        for (Account acc : accList){
            if (!String.isBlank(acc.Website)){
                acc.Domain__c = DomainExtractor.DomainExtractorFromAccountWebSite(acc.Website);
            }
        }
    } 
}