trigger companyTrigger on Company__c (after update) {
    TriggerHandler handler = new TriggerHandler();
    if (Trigger.isAfter) {
        if  (Trigger.isUpdate){
            handler.onAfterUpdate(Trigger.newMap);
        }
    }
}