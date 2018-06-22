({
    getData : function(component) {
        console.log('getData invoked...');
        var self = this;
        var map = {};
        
        self.showSpinner(component);
        
        map['recordId'] = component.get('v.recordId');
        map['itemType'] = component.get('v.itemType');
        map['sldsIconResource'] = component.get('v.sldsIconResource');
        map['truncSize'] = component.get('v.truncSize');
        
        var context = component.get('v.context');
        if (context.networkPrefix != null)
        {
          map['networkPrefix'] = context.networkPrefix;
        }
        
        if (component.get('v.activityFlag') == 'true')
        {
            map['activityFlag'] = component.get('v.activityFlag');
            map['taskIcon'] = component.get('v.taskIcon');
            map['eventIcon'] = component.get('v.eventIcon');
            map['emailIcon'] = component.get('v.emailIcon');
            map['callIcon'] = component.get('v.callIcon');
        }
        
        if (component.get('v.chatterFlag') == 'true')
        {
            map['chatterFlag'] = component.get('v.chatterFlag');
            map['chatterIcon'] = component.get('v.chatterIcon');
        }
        
        if (component.get('v.contentFlag') == 'true')
        {
            map['contentFlag'] = component.get('v.contentFlag');
            map['contentIcon'] = component.get('v.contentIcon');
        }
        
        if (component.get('v.caseCommentFlag') == 'true')
        {
            map['caseCommentFlag'] = component.get('v.caseCommentFlag');
            map['caseCommentIcon'] = component.get('v.caseCommentIcon');
        }
        
        if (component.get('v.child1Flag') == 'true')
        {
            map['child1Flag'] = component.get('v.child1Flag');
            map['child1Icon'] = component.get('v.child1Icon');
            map['child1Object'] = component.get('v.child1Object');
            map['child1ParentField'] = component.get('v.child1ParentField');
            map['child1LabelField'] = component.get('v.child1LabelField');
            map['child1DateField'] = component.get('v.child1DateField');
        }
        
        if (component.get('v.child2Flag') == 'true')
        {        
            map['child2Flag'] = component.get('v.child2Flag');
            map['child2Icon'] = component.get('v.child2Icon');
            map['child2Object'] = component.get('v.child2Object');
            map['child2ParentField'] = component.get('v.child2ParentField');
            map['child2LabelField'] = component.get('v.child2LabelField');
            map['child2DateField'] = component.get('v.child2DateField');
        }
        
        if (component.get('v.child3Flag') == 'true')
        {
            map['child3Flag'] = component.get('v.child3Flag');
            map['child3Icon'] = component.get('v.child3Icon');
            map['child3Object'] = component.get('v.child3Object');
            map['child3ParentField'] = component.get('v.child3ParentField');
            map['child3LabelField'] = component.get('v.child3LabelField');
            map['child3DateField'] = component.get('v.child3DateField');   
        }
        
        if (component.get('v.child4Flag') == 'true')
        {
            map['child4Flag'] = component.get('v.child4Flag');
            map['child4Icon'] = component.get('v.child4Icon');
            map['child4Object'] = component.get('v.child4Object');
            map['child4ParentField'] = component.get('v.child4ParentField');
            map['child4LabelField'] = component.get('v.child4LabelField');
            map['child4DateField'] = component.get('v.child4DateField');
        }
        
        if (component.get('v.child5Flag') == 'true')
        {
            map['child5Flag'] = component.get('v.child5Flag');
            map['child5Icon'] = component.get('v.child5Icon');
            map['child5Object'] = component.get('v.child5Object');
            map['child5ParentField'] = component.get('v.child5ParentField');
            map['child5LabelField'] = component.get('v.child5LabelField');
            map['child5DateField'] = component.get('v.child5DateField');
        }
        
        // save the case
        var action = component.get("c.queryData");
        action.setParams({
            "params": JSON.stringify(map)
        });
        
        console.log('1');
        action.setCallback(this, function(actionResult) {
            var resp = JSON.parse(actionResult.getReturnValue());
            
            if (resp.status == 'SUCCESS') {
                var itemData = JSON.parse(resp.data);
                
                var timeline = component.get('v.timeline');
                timeline.setItems(new vis.DataSet(itemData));
                //self.hideSpinner(component);
                
                self.showControlIcons(component);
                
            } else {
                console.log('3');
                self.hideSpinner(component);
                
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
        
    },
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
        
        if (!id.includes('-'))
        {
            var navToNewWindow = component.get('v.navToNewWindow');
            
            if (navToNewWindow == 'true')
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
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());
            var context = JSON.parse(a.getReturnValue());
            
            var baseURL = window.location.hostname;
            console.log('baseURL=' + baseURL);
            if (baseURL.includes("livepreview"))
            {
                context.networkPrefix = '/sfsites/c';   // override when in community builder mode
            }
            
            component.set("v.context", context);
            
            this.getData(component);
        });
        $A.enqueueAction(action);
    },
    showControlIcons: function(component) {
      var target = component.find("resetDiv");
      $A.util.removeClass(target, 'hide');
        
      var target = component.find("fitDiv");
      $A.util.removeClass(target, 'hide');
    },
    initComplete: function(component) {
        console.log('initComplete...');
        this.hideSpinner(component);
    }
})