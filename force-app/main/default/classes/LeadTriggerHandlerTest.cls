@isTest
private class LeadTriggerHandlerTest {

    @isTest
    static void leadsAndAccountsExactMatchTest() {
        // Inserts 3 account and then Inserts 3 leads. Tests both domain and exact company name matches.
        List<Lead> leadList = TestDataFactory.createAccountsWithLeadsThatMatchButNotLinked();
        Set<Id> leadIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();

        System.debug(leadList);
        for (lead lead : leadList) {
            leadIds.add(lead.Id);
        }

        for (Lead lead : [SELECT Name, Account__c FROM Lead WHERE Id IN: leadIds]){
            System.assertNotEquals(null, lead.Account__c, 'Lead was not Matched to Account');
            System.debug(lead);
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
        
        insert new List<Account>{acc, acc2};

        Lead lead = TestDataFactory.createCustomLead('firstName', 'lastName', 'Test Account', 'contacted', null);
        Lead lead2 = TestDataFactory.createCustomLead('firstName 2', 'lastName 2', 'Test Account 2', 'contacted', null);
        
        lead.Account__c = acc.Id;
        lead2.Account__c = acc2.id;

        insert new List<Lead>{lead, lead2};

        List<Lead> leadListFromDB = [SELECT isMatchedAutomatically__c FROM Lead];
        
        for (Lead l: leadListFromDB) {
            System.assertEquals(0, l.isMatchedAutomatically__c, 'Automation re-matched lead'); 
        }
        
    }

    @isTest
    static void namePartialMatchingTest(){

         // Create Accounts with varying names to test partial matching.
         Account acc1 = new Account(Name = 'TechCorp International');
         Account acc2 = new Account(Name = 'GlobalTech Solutions');
         Account acc3 = new Account(Name = 'Innovative Technologies');
         insert new List<Account>{acc1, acc2, acc3};
 
         // Create Leads with company names that will partially match the Accounts.
         Lead lead1 = TestDataFactory.createCustomLead('John', 'Smith', 'TechCorp', 'contacted', 'john@techcorp.com'); 
         Lead lead2 = TestDataFactory.createCustomLead('Jane', 'Doe', 'GlobalTech', 'contacted', 'jane@globaltech.com');
         Lead lead3 = TestDataFactory.createCustomLead('Sarah', 'Johnson', 'Innovative Tech', 'contacted', 'sarah@inntech.com');
         Lead lead4 = TestDataFactory.createCustomLead('Jim', 'Brown', 'Global Innovation', 'contacted', 'jim@globalinnovation.com'); // No match at all
         Lead lead5 = TestDataFactory.createCustomLead('Jim', 'Jons', 'Wolt', 'contacted', 'jim@wolt.com'); // company name too short no partial matching
         insert new List<Lead>{lead1, lead2, lead3, lead4, lead5};

        List<Lead> leadListFromDB =  [SELECT Account__c, isMatchedAutomatically__c FROM LEAD WHERE Account__c != null];


        System.assertEquals(3, leadListFromDB.size());
            
        
    }

    @isTest
    static void namePartialMatchingEdgeTest(){

        // Create Accounts with varying names to test partial matching.
        Account acc1 = new Account(Name = 'Logistics International');
        Account acc2 = new Account(Name = 'Logistics Solutions');

        insert new List<Account>{acc1, acc2};

        // Create Leads with company names that will partially match the Accounts.
        Lead lead1 = TestDataFactory.createCustomLead('John', 'Smith', 'Logistics', 'contacted', 'john@logint.com'); 
        Lead lead2 = TestDataFactory.createCustomLead('Jane', 'Doe', 'Logistics', 'contacted', 'jane@logsol.com');
        
        insert new List<Lead>{lead1, lead2};

        List<Lead> leadListFromDB =  [SELECT Account__c, isMatchedAutomatically__c FROM LEAD WHERE Account__c != null];


        System.assertEquals(0 , leadListFromDB.size(), 'Leads wrongly matched');
        
    }

}