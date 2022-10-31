public with sharing class BudgetTriggerHandler {

    @future

    public static void futureBudgetUpdateMethod(List<Id> companyId){
        List<AggregateResult> aggrResults = [SELECT COUNT(Id) budgetsCount, Company__r.Head_of_Company__c emp 
        FROM Budget__c WHERE Company__c IN: companyId 
        AND Active__c = true
        GROUP BY Company__r.Head_of_Company__c];
        List<Employee__c> updateEmployee = new List<Employee__c>();
        System.debug('Test' + aggrResults);
        for (AggregateResult aggRes : aggrResults) {
            updateEmployee.add(new Employee__c(Id = (Id)aggRes.get('emp'), Count_of_bugets__c = (Decimal)aggRes.get('budgetsCount')));
        }
        if (!updateEmployee.isEmpty()) {
            update updateEmployee;
        }
    }

    public void onAfterUpdate(Map<Id,Budget__c> newMap, Map<Id,Budget__c> oldMap){
        List<Id> companyIdList = new List<Id>();
        for (Id budgetId : oldMap.keyset()) {
            if (newMap.get(budgetId).Active__c != oldMap.get(budgetId).Active__c) {
                companyIdList.add(newMap.get(budgetId).Company__c);
            }	
            if (newMap.get(budgetId).Last_Updated_Date__c != oldMap.get(budgetId).Last_Updated_Date__c) {
                System.enqueueJob(new testQuebleName());
            }
        }
        if (!companyIdList.isEmpty()) {
            BudgetTriggerHandler.futureBudgetUpdateMethod(companyIdList);
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