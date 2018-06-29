({
    showSpinner:function(component){
        component.set("v.IsSpinner",true);
    },
    hideSpinner:function(component){
        component.set("v.IsSpinner",false);
    },
    getIconHTML:function(component, icon, size){
        var iconHTML = null;
        
        var resourceURL = component.get('v.sldsIconResource');
        var context = component.get('v.context');
        console.log('resourceURL=' + resourceURL);
        console.log('context=' + JSON.stringify(context));
        
        if (icon.startsWith('http'))
        {
            iconHTML = '<img src="' + icon + '"></img>';
        }
        else if (icon.startsWith('/resource'))
        {
            if (context.networkPrefix != null)
            {
                icon = context.networkPrefix + icon;
            }
            
            iconHTML = '<img src="' + icon + '"></img>';
        }
            else if (icon.includes(':'))
            {
                var res = icon.split(':');
                if (res.size() == 2)
                {
                    var category = res[0];
                    var name = res[1];
                    
                    
                    if (context.networkPrefix != null)
                    {
                        resourceURL = context.networkPrefix + resourceURL;
                    }
                    
                    iconHTML = '<span class="slds-icon_container slds-icon-' + category + '-' + name + '" >'
                    + '<svg aria-hidden="true" class="slds-icon slds-icon--' + size + '" name="' + name + '">' 
                    + '<use xlink:href="' + resourceURL + '/assets/icons/' + category + '-sprite/svg/symbols.svg#' + name +'"></use>'
                    + '</svg></span>';
                }
            }   
        console.log('iconHTML=' + iconHTML);
        return iconHTML;
    },
    navToRecord: function(component, id) {
        console.log("navToRecord called");
        console.log("id=" + id);
        
        if (id != null && !id.includes('-'))
        {
            var navToNewWindow = component.get('v.navToNewWindow');
            
            if (navToNewWindow)
            {
                window.open('/' + id);
            }
            else
            {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": id,
                    "slideDevName": "detail"
                });
                navEvt.fire(); 
            }
        }
        
    },
    setRuntimeContext: function(component) {
        var self = this;
        console.log('helper setRuntimeContext started...');
        var action = component.get("c.getRuntimeContext");
        
        //Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();
            if (state === "SUCCESS") 
            {     
                var context = actionResult.getReturnValue();
                
                var baseURL = window.location.hostname;
                console.log('baseURL=' + baseURL);
                console.log('window.location=' + window.location);
                if (baseURL.includes("livepreview"))
                {
                    context.networkPrefix = '/sfsites/c';   // override when in community builder mode
                    var target = component.find("filterDiv");
                    $A.util.removeClass(target, 'hide');
                }
                else if (window.location.href.indexOf("flexipageEditor") > -1)
                {
                    var target = component.find("filterDiv");
                    $A.util.removeClass(target, 'hide');
                }
                
                component.set("v.context", context);
                
                //self.getGenericData(component);
                self.setProcessorOptions(component);
                self.filterData(component);
            }
            else 
            {   
                self.handleErrors(actionResult.getError());
            }            
            
        });
        $A.enqueueAction(action);
    },
    showControlIcons: function(component) {
        var target = component.find("controlDiv");
        $A.util.removeClass(target, 'hide');
        
        var target = component.find("fitDiv");
        $A.util.removeClass(target, 'hide');
    },
    initComplete: function(component) {
        console.log('initComplete...');
        this.hideSpinner(component);
    },
    addCSVValue: function(str, val)
    {
        if (val != null && val.length > 0)
        {
            if (str == null)
            {
                str = val;
            }
            else
            {
                str += ',' + val;
            }
        }
        return str;
    },
    filterData : function(component) {
        console.log('filterData...');
        var childComponent = component.find('filterComp');
        childComponent.executeFilter();
    },
    setProcessorOptions : function(component)
    {
        // build processor options
        var options = {};
        options['objectName'] = component.get('v.objectName');
        options['objectIcon'] = component.get('v.objectIcon');
        options['objectLabelField'] = component.get('v.objectLabelField');
        options['objectDescField'] = component.get('v.objectDescField');
        options['objectDateField'] = component.get('v.objectDateField');
        options['objectColorField'] = component.get('v.objectColorField');
        options['objectIconField'] = component.get('v.objectIconField');
        options['objectGroupByField'] = component.get('v.objectGroupByField');
        options['sldsIconResource'] = component.get('v.sldsIconResource');
        options['itemType'] = component.get('v.itemType');
        options['truncSize'] = component.get('v.truncSize');
        var context = component.get('v.context');
        options['networkPrefix'] = context['networkPrefix'];
        
        console.log('options=' + JSON.stringify(options));
        component.set('v.processorOptions', options); 
    },
    hideDateSel : function (component) {
        var target = component.find("dateSelDiv");
        $A.util.addClass(target, 'hide');
    },
    updateVisibleCount : function (component) {
        var timeline = component.get("v.timeline");
        component.set("v.visibleCount", timeline.getVisibleItems().length);
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