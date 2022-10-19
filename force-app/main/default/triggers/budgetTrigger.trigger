trigger budgetTrigger on Budget__c (after update) {
    TriggerHandler handler = new TriggerHandler();
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            
        }
    }
}