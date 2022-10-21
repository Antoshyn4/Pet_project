public with sharing class CompanyTriggerHandler {
    public void onAfterUpdate(Map<Id,Company__c> newMap){
        Set<Id> budgetIds = new Set<Id>();
        for (Budget__c budgets : [SELECT Id FROM Budget__c WHERE Company__c IN :newMap.values()]) {
            budgetIds.add(budgets.Id);
        }
        
        List<Employee__c> updateList = [SELECT Count_of_bugets__c FROM Employee__c WHERE Current_Company__c IN (SELECT Company__c FROM Budget__c WHERE ID IN :budgetIds)];
        for (Employee__c emp : updateList) {
            List<Budget__c> tempList = [SELECT Id FROM Budget__c WHERE Company__c IN (SELECT Current_Company__c FROM Employee__c WHERE Id =: emp.Id)];
            emp.Count_of_bugets__c = tempList.size();
        }

        if (!updateList.isEmpty()) {
            update updateList;
        }
    }
}
