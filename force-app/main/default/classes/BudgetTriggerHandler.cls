public with sharing class BudgetTriggerHandler {

    public void onAfterUpdate(Map<Id,Budget__c> newMap){
        setNewValueCountOfBugets(newMap);
        
        Set<Id> budgetIds = new Set<Id>(newMap.keyset());
        List<Employee__c> updateEmployeeList = [SELECT Count_of_bugets__c FROM Employee__c WHERE Current_Company__c IN (SELECT Company__c FROM Budget__c WHERE ID IN :budgetIds)];
        AggregateResult  maxvalue = [SELECT MAX(Employees_Budget__c) maxBudget FROM Budget__c WHERE Company__c IN (SELECT Current_Company__c FROM Employee__c WHERE id IN :updateEmployeeList)];
        
        for (Employee__c employee : updateEmployeeList) {
            employee.Max_Employee_Budget__c = (Decimal)maxvalue.get('maxBudget');
        }

        if (!updateEmployeeList.isEmpty()) {
            update updateEmployeeList;
        }
    }

    public void onAfterInsert(Map<Id,Budget__c> newMap){
        setNewValueCountOfBugets(newMap);
    }

    public void onAfterDelete(Map<Id,Budget__c> newMap){
        setNewValueCountOfBugets(newMap);
    }
    
    private void setNewValueCountOfBugets(Map<Id,Budget__c> newMap){
        Set<Id> budgetIds = new Set<Id>(newMap.keyset());
        List<Employee__c> updateEmployeeList = [SELECT Count_of_bugets__c FROM Employee__c WHERE Current_Company__c IN (SELECT Company__c FROM Budget__c WHERE ID IN :budgetIds)];
        Integer count = database.countQuery('SELECT COUNT() FROM Budget__c WHERE Company__c IN (SELECT Current_Company__c FROM Employee__c WHERE id IN :updateEmployeeList)');
        
        for (Employee__c employee : updateEmployeeList) {
            employee.Count_of_bugets__c = count;
        }

        if (!updateEmployeeList.isEmpty()) {
            update updateEmployeeList;
        }
    }
}
