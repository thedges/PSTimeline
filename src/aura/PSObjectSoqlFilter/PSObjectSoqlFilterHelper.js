({
	initFilterParams: function(component) {
        console.log('initFilterParams begin...');
        var map = {};
        
        var self = this; // safe reference
        var filterFields = component.get("v.filterFields");
        var sobject = component.get("v.objectName");
        
        map['objectName'] = component.get('v.objectName');
        map['filterFields'] = component.get('v.filterFields');
        
        var action = component.get("c.prepFilterFields");
        action.setParams({
            "params": JSON.stringify(map)
        });
        action.setCallback(self, function(actionResult) {
            console.log('initFilterparams complete!');
            var resp = JSON.parse(actionResult.getReturnValue());
            
            if (resp.status == 'SUCCESS') {
                component.set("v.filterFieldComps", JSON.parse(resp.data));            
            } else {
                self.fireFilterStop(component);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": resp.msg,
                    //"duration": 2000,
                    "type": "warning",
                    mode: "sticky"
                });
                toastEvent.fire();
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
    executeFilter : function(component) {
        console.log('executeFilter invoked...');
        var self = this;
        var map = {};
        
        component.set('v.recList', []);
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
        
        // save the case
        var action = component.get("c.queryObjectData");
        action.setParams({
            "params": JSON.stringify(map)
        });
        
        action.setCallback(this, function(actionResult) {
            var resp = JSON.parse(actionResult.getReturnValue());
            
            if (resp.status == 'SUCCESS') {
                var itemData = JSON.parse(resp.data);
                component.set('v.recList', itemData);
                //console.log('itemData=' + resp.data);
                
                self.fireFilterStop(component);
                
            } else {
                self.fireFilterStop(component);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": resp.msg,
                    //"duration": 2000,
                    "type": "warning",
                    mode: "sticky"
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
        
    }
})