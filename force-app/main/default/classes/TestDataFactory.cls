@isTest
public with sharing class TestDataFactory {

    /** 
    * ********************************************************
    * Below methods are test data for Lead object
    * ********************************************************
    */

    public static Lead createCustomLead(String firstName, String lastName, String company, String status, String email) {
        Lead newLead = new Lead();
        newLead.FirstName = firstName;
        newLead.LastName = lastName;
        newLead.Company = company;
        newLead.Status = status;
        newLead.Email = email;
        return newLead;
    }

    public static Lead createLeadWithoutEmail(Boolean doInsert){
        Lead newLead = new Lead() ;
        newLead.FirstName = 'Cole';
        newLead.LastName = 'Swain';
        newLead.Company = 'RedWave';
        newLead.Status = 'contacted';
        if(doInsert){
            insert newLead;
        }
        return newLead;
    }

    public static Lead createLeadWithEmail(Boolean doInsert){
        Lead newLead = new Lead() ;
        newLead.FirstName = 'Jeremy';
        newLead.LastName = 'Mike';
        newLead.Company = 'RedWave';
        newLead.Status = 'contacted';
        newLead.Email = 'cole.swain@bluewave.com';
        if(doInsert){
            insert newLead;
        }
        return newLead;
    }


    public static List<Lead> createTenUnrelatedToAccountsLeads(Boolean doInsert) {
        List<Lead> leadList = new List<Lead>();
        leadList.add(createCustomLead('Jeremy', 'Mike', 'Online TechConsulting', 'contacted', 'cole.swain@onlinetechconsulting.com'));
        leadList.add(createCustomLead('Alice', 'Johnson', 'Global Innovations Inc.', 'new', 'alice.johnson@globalinnovations.com'));
        leadList.add(createCustomLead('Michael', 'Smith', 'Smith Technologies', 'qualified', 'm.smith@smithtech.com'));
        leadList.add(createCustomLead('David', 'Lee', 'Pinnacle Solutions', 'contacted', null));
        leadList.add(createCustomLead('Sarah', 'Parker', 'BrightFuture Corp', 'qualified', 'sarah.parker@brightfuture.com'));
        leadList.add(createCustomLead('John', 'Doe', 'Doe Enterprises', 'new', 'john.doe@doeenterprises.com'));
        leadList.add(createCustomLead('Emma', 'Brown', 'Brown Solutions', 'contacted', null));
        leadList.add(createCustomLead('Chris', 'Evans', 'Evans Consulting', 'new', 'chris.evans@evansconsulting.com'));
        leadList.add(createCustomLead('Olivia', 'Martinez', 'Martinez & Co', 'qualified', null));
        leadList.add(createCustomLead('Robert', 'Taylor', 'Taylor Engineering', 'contacted', 'r.taylor@tayloreng.com'));
        
        if(doInsert) {
            insert leadList;
        }
    
        return leadList;
    }

    /** 
    * ********************************************************
    * Below methods are test data for Account object
    * ********************************************************
    */

    public static Account createCustomAccount(String name, String website) {
        Account newAcc = new Account();
        newAcc.Name = name;
        newAcc.Website = website;
        return newAcc;
    }

    public static Account createAccountWithWebsite(Boolean doInsert){
        Account newAcc = new Account();
        newAcc.Name = 'World Wide Organization';
        newAcc.Website = 'www.wwo.com';
        if(doInsert){
            insert newAcc;
        }
        return newAcc;
    }

    public static List<Account> createFiveAccountWithoutLeads(Boolean doInsert){
        List<Account> accountList = new List<Account>();
    
        // Add unique accounts in a similar format
        accountList.add(createCustomAccount('Tech Innovations Inc.', 'www.techinnovations.com'));
        accountList.add(createCustomAccount('Future Dynamics LLC', 'www.futuredynamics.com'));
        accountList.add(createCustomAccount('Alpha Solutions Group', 'www.alphasolutions.com'));
        accountList.add(createCustomAccount('Beta Services Co.', 'www.betaservices.com'));
        accountList.add(createCustomAccount('Gamma Enterprises Ltd.', 'www.gammaenterprises.com'));
    
        // Insert accounts if requested
        if (doInsert) {
            insert accountList;
        }
    
        return accountList;
    }

    // FOR EXACT MATCHING WITH DOMAIN OR COMPANY NAME
    public static List<Lead> createAccountsWithLeadsThatMatchButNotLinked(){
        List<Account> accountList = new List<Account>();
        List<Lead> leadList = new List<Lead>();

        accountList.add(createCustomAccount('Maksim Consulting.', 'www.maksimconsulting.com'));
        accountList.add(createCustomAccount('Actual Company', 'https://actualcompany.com'));
        accountList.add(createCustomAccount('Music Streaming', 'https://musicstreaming.com'));
        
        insert accountList;

        leadList.add(createCustomLead('Maksim', 'Minenko', 'Has To be Matched With Domain', 'contacted', 'maksim.minenko@maksimconsulting.com'));
        leadList.add(createCustomLead('Nobody', 'Nobody', 'Actual Company', 'contacted', null));
        leadList.add(createCustomLead('Dima', 'Love', 'Music Streaming', 'contacted', null));
        
        insert leadList;

        return leadList;
    }


}