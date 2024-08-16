trigger LeadTrigger on Lead (before insert) {
 if (Trigger.isBefore){
    if (Trigger.isInsert) {
        LeadTriggerHandler.matchLeadToAccountByCompanyNameOrDomain(Trigger.new);
    }
 }
}