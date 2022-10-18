import { LightningElement, track, wire,api } from 'lwc';
import getIssues from '@salesforce/apex/toDoListController.getIssues';
import {loadStyle} from 'lightning/platformResourceLoader'
import COLORS from '@salesforce/resourceUrl/styles'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import search from '@salesforce/apex/toDoListController.search';
import getRecentlyViewed from '@salesforce/apex/toDoListController.getRecentlyViewed';
import insertIssue from '@salesforce/apex/toDoListController.insertIssue';

const columns = [
                  { label: ' Issue Name', type:'url', fieldName: 'nameUrl', sortable: "true",typeAttributes: {label: { fieldName: 'name' ,target: '_blank'}}},
                  { label: 'Description', fieldName: 'Description', sortable: "true"},
                  { label: 'Date to Do', fieldName: 'dateToDo', type: 'date', sortable: "true"},
                  { label: 'Family Member', fieldName: 'memberOfFamily', type: 'text', sortable: "true" },];

export default class Todo extends LightningElement {
    @api notifyViaAlerts = false;
    @track data;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;
    @track isShowModal = false;
    @track nameOfIssue;
    @track descriptionOfIssue;
    @track dateOfIssue;
    @track asigneeFromFamily;
    @track issueId;
    isCssLoaded = false;
    dateval;


    isMultiEntry = false;
    maxSelectionSize = 2;
    
    errors = [];
    recentlyViewed = [];
    newRecordOptions = [
        { value: 'Family_Member__c', label: 'New Family Member' }
    ];

    /**
     * Loads recently viewed records and set them as default lookpup search results (optional)
     */
    @wire(getRecentlyViewed)
    getRecentlyViewed({ data }) {
        if (data) {
            this.recentlyViewed = data;
            this.initLookupDefaultResults();
        }
    }

    connectedCallback() {
        this.initLookupDefaultResults();
    }

    /**
     * Initializes the lookup default results with a list of recently viewed records (optional)
     */
    initLookupDefaultResults() {
        // Make sure that the lookup is present and if so, set its default results
        const lookup = this.template.querySelector('c-lookup');
        if (lookup) {
            lookup.setDefaultResults(this.recentlyViewed);
        }
    }

    /**
     * Handles the lookup search event.
     * Calls the server to perform the search and returns the resuls to the lookup.
     * @param {event} event `search` event emmitted by the lookup
     */
    handleLookupSearch(event) {
        const lookupElement = event.target;
        // Call Apex endpoint to search for records and pass results to the lookup
        search(event.detail)
            .then((results) => {
                lookupElement.setSearchResults(results);
            })
            .catch((error) => {
                this.notifyUser('Lookup Error', 'An error occured while searching with the lookup field.', 'error');
                // eslint-disable-next-line no-console
                console.error('Lookup error', JSON.stringify(error));
                this.errors = [error];
            });
    }

    /**
     * Handles the lookup selection change
     * @param {event} event `selectionchange` event emmitted by the lookup.
     * The event contains the list of selected ids.
     */
    // eslint-disable-next-line no-unused-vars
    handleLookupSelectionChange(event) {
        this.checkForErrors();
    }

    // All functions below are part of the sample app form (not required by the lookup).

    handleLookupTypeChange(event) {
        this.initialSelection = [];
        this.errors = [];
        this.isMultiEntry = event.target.checked;
    }

    handleMaxSelectionSizeChange(event) {
        this.maxSelectionSize = event.target.value;
    }

    handleSubmit() {
        this.checkForErrors();
        if (this.errors.length === 0) {
            this.notifyUser('Success', 'The form was submitted.', 'success');
        }
    }

    handleClear() {
        this.initialSelection = [];
        this.errors = [];
    }

    checkForErrors() {
        this.errors = [];
        const selection = JSON.stringify(this.template.querySelector('c-lookup-field-template').getSelection());
        var issueObject = JSON.parse(selection);
        this.asigneeFromFamily = issueObject[0]['id'];
        console.log('test ' + this.asigneeFromFamily);
        if (this.isMultiEntry && selection.length > this.maxSelectionSize) {
            this.errors.push({ message: `You may only select up to ${this.maxSelectionSize} items.` });
        }
        // Enforcing required field
        if (selection.length === 0) {
            this.errors.push({ message: 'Please make a selection.' });
        }
    }

    issueHandleChange(event){
        if(event.target.name == 'issueName'){
            this.nameOfIssue = event.target.value;
        }
        if(event.target.name == 'descriptionName'){
            this.descriptionOfIssue = event.target.value;
        }

        if(event.target.name == 'dateToDoIssue'){
            this.dateOfIssue = event.target.value;  
        }
    }

    saveIssue(){
        insertIssue({name:this.nameOfIssue,description:this.descriptionOfIssue,dateToDo:this.dateOfIssue,familyMember:this.asigneeFromFamily})
        .then(result=>{
            this.issueId = result.Id;      
            const toastEvent = new ShowToastEvent({
                title:'Success!',
                message:'Issue created successfully',
                variant:'success'
              });
              this.dispatchEvent(toastEvent);
              this.isShowModal = false;
              window.location.reload();
        })
        .catch(error =>{
           this.errorMsg=error.message;
           window.console.log(this.error);
        });
    
     }


    notifyUser(title, message, variant) {
        if (this.notifyViaAlerts) {
            // Notify via alert
            // eslint-disable-next-line no-alert
            alert(`${title}\n${message}`);
        } else {
            // Notify via toast (only works in LEX)
            const toastEvent = new ShowToastEvent({ title, message, variant });
            this.dispatchEvent(toastEvent);
        }
    }


    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    } 

    get dateValue(){
    if(this.dateval == undefined)
    {
      this.dateval = new Date().toISOString().substring(0, 10);
    }
    return this.dateval;
    }
    
    @wire(getIssues, { dateValue: '$dateval'})
    issues(result) {
        if (result.data) {
            this.data = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }

    showModalBox() {  
        this.isShowModal = true;
    }

    hideModalBox() {
        this.isShowModal = false;
    }

    showNextDay() {
        var nextDay = new Date(this.dateval);
        nextDay.setDate(nextDay.getDate() + 1);
        this.dateval = nextDay;
    }

    showPreviousDay() {
        var previousDay = new Date(this.dateval);
        previousDay.setDate(previousDay.getDate() - 1);
        this.dateval = previousDay;
    }

    

    renderedCallback(){ 
        if(this.isCssLoaded) return
        this.isCssLoaded = true
        loadStyle(this, COLORS).then(()=>{
            console.log("Loaded Successfully")
        }).catch(error=>{ 
            console.error("Error in loading the colors")
        })
    }

}