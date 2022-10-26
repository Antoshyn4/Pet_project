trigger budgetTrigger on Budget__c (after update, before delete, after insert) {
    BudgetTriggerHandler handler = new BudgetTriggerHandler();

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            handler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
        else if (Trigger.isInsert) {
            handler.onAfterInsert(Trigger.new);
        }
    }
    if (Trigger.isBefore){
        if (Trigger.isDelete) {
            handler.onAfterDelete(Trigger.old);
        }
    }
}