public with sharing class BudgetTriggerHandler {

    public void onAfterUpdate(Map<Id,Budget__c> newMap, Map<Id,Budget__c> oldMap){
        List<Employee__c> updateEmployeeList = new List<Employee__c>();
        for (Id budgetId : oldMap.keyset()) {
            if (newMap.get(budgetId).Active__c != oldMap.get(budgetId).Active__c) {
                Id companyId = newMap.get(budgetId).Company__c;
                Id employeeId = [SELECT Head_of_Company__c FROM Company__c WHERE Id =: companyId].Head_of_Company__c;
                Integer count = Database.countQuery('SELECT COUNT() FROM Budget__c WHERE Company__c =: companyId AND Active__c = true');
                updateEmployeeList.add(new Employee__c(Id = employeeId, Count_of_bugets__c = count));
            }
        }
        if (!updateEmployeeList.isEmpty()) {
            update updateEmployeeList;
        }
    }

    public void onAfterInsert(List<Budget__c> newBudgetsList){
        Set<Id> setOfCompaniesId = new Set<Id>();
        for (Budget__c budget : [SELECT Company__c FROM Budget__c WHERE Id IN: newBudgetsList]) {
            setOfCompaniesId.add(budget.Company__c);
        }
        List<AggregateResult> aggrRes = [SELECT COUNT(Id) coun, Company__r.Head_of_Company__c testId
                                        FROM Budget__c
                                        WHERE Company__c IN :setOfCompaniesId
                                        AND Active__c = true
                                        GROUP BY Company__r.Head_of_Company__c];
        List<Employee__c> updateEmployeeList = new List<Employee__c>();

        for (AggregateResult aggr_i : aggrRes) {
            updateEmployeeList.add(new Employee__c(Id = (Id)(aggr_i.get('testId')), Count_of_bugets__c = (Decimal)aggr_i.get('coun')));
        }

        if (!updateEmployeeList.isEmpty()) {
            update updateEmployeeList;
        }
    }

    public void onAfterDelete(List<Budget__c> oldBudgetsList){
        Set<Id> setOfCompaniesId = new Set<Id>();
        for (Budget__c budget : [SELECT Company__c FROM Budget__c WHERE Id IN: oldBudgetsList]) {
            setOfCompaniesId.add(budget.Company__c);
        }
        List<AggregateResult> aggrRes = [SELECT COUNT(Id) coun, Company__r.Head_of_Company__c testId
                                        FROM Budget__c
                                        WHERE Company__c IN :setOfCompaniesId
                                        AND Active__c = true
                                        GROUP BY Company__r.Head_of_Company__c];
        List<Employee__c> updateEmployeeList = new List<Employee__c>();

        for (AggregateResult aggr_i : aggrRes) {
            updateEmployeeList.add(new Employee__c(Id = (Id)(aggr_i.get('testId')), Count_of_bugets__c = (Decimal)aggr_i.get('coun') - 1));
        }

        if (!updateEmployeeList.isEmpty()) {
            update updateEmployeeList;
        }
    }

    private void updateEmployeesOnBudget(List<Budget__c> budgetsList){
        
    }
}