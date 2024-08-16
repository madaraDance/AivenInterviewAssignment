@isTest
private class LeadTriggerHandlerTest {

    @isTest
    static void leadsAndAccountsExactMatchTest() {
        // Inserts 3 account and then Inserts 3 leads. Tests both domain and exact company name matches.
        List<Lead> leadList = TestDataFactory.createAccountsWithLeadsThatMatchButNotLinked();
        Set<Id> leadIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();

        
        for (lead lead : leadList) {
            leadIds.add(lead.Id);
        }

        for (Lead lead : [SELECT Name, Account__c FROM Lead WHERE Id IN: leadIds]){
            System.debug(lead);
            System.assertNotEquals(null, lead.Account__c, 'Lead was not Matched to Account');
            accIds.add(lead.Account__c);
        }

        System.assertEquals(3, accIds.size(), 'Lead was matched to wrong Account');
    }

    
    @isTest
    static void accountsAndLeadsWithoutAnyMatch() {
        //Unrelated Accounts and Lead do not link to each other.
        TestDataFactory.createFiveAccountWithoutLeads(true);
        TestDataFactory.createTenUnrelatedToAccountsLeads(true);

        List<Lead> leadList = [SELECT Account__c FROM Lead WHERE Account__c != null];

        System.assertEquals(0, leadList.size(), 'Lead was matched to wrong Account');
    }

    @isTest
    static void leadsInsertWithoutAnyAccounts() {
        //Isnerting Lead without any Accounts in DB to see that no erros occur.
        TestDataFactory.createTenUnrelatedToAccountsLeads(true);

        List<Lead> leadList = [SELECT Name FROM Lead];

        System.assertEquals(10, leadList.size(), 'Expected amount of leads was not created.');
    }

    @isTest
    static void insertLinkedAccountsAndLeads() {
        //Isnerting accounts and leads. manually connect lead to account and check that automaion did not step in.
        Account acc = TestDataFactory.createCustomAccount('Test Account', null);
        Account acc2 = TestDataFactory.createCustomAccount('Test Account 2', null);
        
        List<Account> accList = new List<Account>{acc, acc2};
        insert accList;

        Lead lead = TestDataFactory.createCustomLead('firstName', 'lastName', 'Test Account', 'contacted', null);
        Lead lead2 = TestDataFactory.createCustomLead('firstName 2', 'lastName 2', 'Test Account 2', 'contacted', null);
        
        lead.Account__c = acc.Id;
        lead2.Account__c = acc2.id;

        List<Lead> leadList = new List<Lead>{lead, lead2};

        insert leadList;

        List<Lead> leadListFromDB = [SELECT isMatchedAutomatically__c FROM Lead];
        
        for (Lead l: leadListFromDB) {
            System.assertEquals(false, l.isMatchedAutomatically__c, 'Automation re-matched lead'); 
        }
        
    }


}