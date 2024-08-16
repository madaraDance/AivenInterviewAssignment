trigger AccountTrigger on Account (before insert) {
    if (Trigger.isBefore){
        if (Trigger.isInsert) {
            AccountTriggerHandler.setDomainFieldFromWebsite(Trigger.new);
        }
     }
}