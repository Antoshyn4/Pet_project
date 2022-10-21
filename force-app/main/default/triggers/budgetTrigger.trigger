trigger budgetTrigger on Budget__c (after update, after delete, after insert) {
    BudgetTriggerHandler handler = new BudgetTriggerHandler();

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            handler.onAfterUpdate(Trigger.newMap);
        }
        if (Trigger.isInsert) {
            handler.onAfterInsert(Trigger.newMap);
        }
        if (Trigger.isDelete) {
            handler.onAfterDelete(Trigger.newMap);
        }
    }
}