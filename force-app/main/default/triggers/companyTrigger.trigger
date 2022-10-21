trigger companyTrigger on Company__c (after update) {
    CompanyTriggerHandler handler = new CompanyTriggerHandler();
    
    if (Trigger.isAfter) {
        if  (Trigger.isUpdate){
            //handler.onAfterUpdate(Trigger.newMap);
        }
    }
}