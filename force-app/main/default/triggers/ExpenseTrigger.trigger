trigger ExpenseTrigger on Expense__c (after insert, after update) {
	ExpenseTriggerHandler expenseTriggerHandler = new ExpenseTriggerHandler();
    if	(Trigger.isAfter){
        if	(Trigger.isInsert){
    		expenseTriggerHandler.onAfterInsert(Trigger.New);
        }
        if	(Trigger.isUpdate){
    		expenseTriggerHandler.onAfterUpdate(Trigger.NewMap, Trigger.OldMap);
        }
    }
}