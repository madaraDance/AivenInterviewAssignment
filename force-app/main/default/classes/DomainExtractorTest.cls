@isTest
private class DomainExtractorTest {
    @isTest
    static void DomainExtractorFromAccountWebSiteTest() {
        Account acc = TestDataFactory.createCustomAccount('Test Account', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
        Account acc2 = TestDataFactory.createCustomAccount('Test Account 2', 'http://www.youtube.com/watch?v=dQw4w9WgXcQ');
        Account acc3 = TestDataFactory.createCustomAccount('Test Account 3', 'https://youtube.com/watch?v=dQw4w9WgXcQ');
        Account acc4 = TestDataFactory.createCustomAccount('Test Account 4', 'www.youtube.com');
        Account acc5 =TestDataFactory.createCustomAccount('Test Account 5', 'http://youtube.com/watch?v=dQw4w9WgXcQ');
        Account acc6 =TestDataFactory.createCustomAccount('Test Account 6', 'http://youtube.com.uk');


        insert new List<Account>{acc, acc2, acc3, acc4, acc5};

        List<Account> accListFromDB = [SELECT Id, Name, Domain__c FROM Account];

        for (Account a : accListFromDB){
            if(a.Name == 'Test Account 6'){
                System.assertEquals('youtube.com.uk', a.Domain__c);
            }
            System.assertEquals('youtube.com', a.Domain__c);
        }
    }

    @isTest
    static void DomainExtractorFromLeadEmailTest() {
        String emailDomain = DomainExtractor.DomainExtractorFromLeadEmail('john@logint.com');
        System.assertEquals('logint.com', emailDomain);
        emailDomain = DomainExtractor.DomainExtractorFromLeadEmail('jane@logsol.com.uk');
        System.assertEquals('logsol.com.uk', emailDomain);
        emailDomain = DomainExtractor.DomainExtractorFromLeadEmail('jane@parentCo.company.com');
        System.assertEquals('parentCo.company.com', emailDomain);
    }   
}