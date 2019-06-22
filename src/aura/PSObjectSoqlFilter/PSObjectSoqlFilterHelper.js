({
    initFilterParams: function(component) {
        console.log('initFilterParams begin...');
        var map = {};
        
        var self = this; // safe reference
        //var filterFields = component.get("v.filterFields");
        //var sobject = component.get("v.objectName");
        
//        map['objectName'] = component.get('v.objectName');
//        map['filterFields'] = component.get('v.filterFields');

        console.log('map=' + JSON.stringify(map));
        
        var action = component.get("c.prepFilterFields");
        /*
        action.setParams({
            "params": JSON.stringify(map)
        });
        */
       action.setParams({
        "objectName": component.get('v.objectName'),
        "filterFields": component.get('v.filterFields')
       });
        action.setCallback(self, function(actionResult) {
            var state = actionResult.getState();
            console.log('filter=' + JSON.stringify(actionResult.getReturnValue()));
            if (state === "SUCCESS") {
                component.set("v.filterFieldComps", JSON.parse(actionResult.getReturnValue()));  
            }
            else {
                self.fireFilterStop(component);
                self.handleErrors(actionResult.getError());
            }
        });
        // Enqueue the action
        $A.enqueueAction(action);
    },
    fireFilterStart : function(component) {
        var cmpEvent = component.getEvent("filterEvent");
        cmpEvent.setParam("action", "start");
        cmpEvent.fire();
    },
    fireFilterStop : function(component) {
        var cmpEvent = component.getEvent("filterEvent");
        cmpEvent.setParam("action", "stop");
        cmpEvent.fire();
    },
    executeFilter2 : function(component) {
        console.log('executeFilter2 invoked...');
        var self = this;
        var map = {};
        
        //component.set('v.recList', []);
        self.fireFilterStart(component);
        
        console.debug('processorOptions=' + component.get('v.processorOptions'));
        
        map['objectName'] = component.get('v.objectName');
        map['selectFields'] = component.get('v.selectFields');
        map['filterFields'] = JSON.stringify(component.get('v.filterFieldComps'));
        map['filterCondition'] = component.get('v.filterCondition');
        map['processorName'] = component.get('v.processorName');
        map['processorOptions'] = JSON.stringify(component.get('v.processorOptions'));
        map['dateField'] = component.get('v.dateField');
        map['earliestDate'] = component.get('v.earliestDate');
        map['soqlLimit'] = component.get('v.soqlLimit');
        
        // save the case
        var action = component.get("c.queryObjectDataList");
        action.setParams({
            "params": JSON.stringify(map)
        });
        
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state === "SUCCESS") {
                var resp = actionResult.getReturnValue();
                //console.log(JSON.stringify(resp));
                
                component.set("v.processorResp", resp);
                self.fireFilterStop(component);
            }
            else {
                self.fireFilterStop(component);
                self.handleErrors(actionResult.getError());
            }
            
        });
        $A.enqueueAction(action);
        
    },
    handleErrors : function(errors) {
        // Configure error toast
        let toastParams = {
            title: "Error!",
            message: "Unknown error", // Default error message
            type: "error",
            mode: "sticky"
        };
        // Pass the error message if any
        if (errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }
        // Fire error toast
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }
})