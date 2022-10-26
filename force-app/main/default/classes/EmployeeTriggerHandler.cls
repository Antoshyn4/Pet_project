public with sharing class EmployeeTriggerHandler {
    public void onBeforeInsert(List<Employee__c> newList){
        List<Employee__c> updatedList = new List<Employee__c>();
        
        for (Employee__c emp : newList) {
            if (!String.isBlank(emp.Current_Company__c) && String.isBlank(emp.Specialty__c)) {
                emp.Specialty__c = 'Intern';
            }
        }
    }
}