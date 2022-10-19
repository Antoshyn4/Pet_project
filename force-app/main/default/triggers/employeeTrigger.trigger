trigger employeeTrigger on Employee__c (before insert) {
	TriggerHandler triggerHandler = new TriggerHandler();

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            triggerHandler.onBeforeInsert(Trigger.new);
        }
    }
}