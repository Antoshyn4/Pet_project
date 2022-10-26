trigger employeeTrigger on Employee__c (before insert) {
	EmployeeTriggerHandler triggerHandler = new EmployeeTriggerHandler();

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            triggerHandler.onBeforeInsert(Trigger.new);
        }
    }
}