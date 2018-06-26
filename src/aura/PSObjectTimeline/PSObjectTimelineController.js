({
	jsLoaded : function(component, event, helper) {
        var globalId = component.getGlobalId();
        
        // build select field list
        var tmpStr;
        tmpStr = helper.addCSVValue(tmpStr, component.get('v.objectLabelField'));
        tmpStr = helper.addCSVValue(tmpStr, component.get('v.objectDescField'));
        tmpStr = helper.addCSVValue(tmpStr, component.get('v.objectDateField'));
        tmpStr = helper.addCSVValue(tmpStr, component.get('v.objectColorField'));
        tmpStr = helper.addCSVValue(tmpStr, component.get('v.objectIconField'));
        component.set('v.selectFields', tmpStr);
        
        // DOM element where the Timeline will be attached
        var container = document.getElementById(globalId + '_timeline_generic');
        
        var items = null;
        
        // Configuration for the Timeline
        var options = {width: '100%',
                       clickToUse: false,
                       margin: {
                           item: 20
                       },
                       onInitialDrawComplete: function(){helper.initComplete(component)}};
        
        var today = new Date();
        var showTooltips = component.get('v.tooltips');
        options['showTooltips'] = (showTooltips == 'true');
        
        var minHeight = component.get('v.minHeight');
        if (minHeight != null && minHeight.length > 0) options['minHeight'] = minHeight;

        var maxHeight = component.get('v.maxHeight');
        if (maxHeight != null && maxHeight.length > 0) options['maxHeight'] = maxHeight;

        var daysBefore = component.get('v.daysBefore');
        if (daysBefore != null)
        {
            var dt = new Date(today.getFullYear(), today.getMonth(), today.getDate() - daysBefore);
            options['start'] = dt;
        }
        
        var daysAfter = component.get('v.daysAfter');
        if (daysAfter != null)
        {
            var dt = new Date(today.getFullYear(), today.getMonth(), today.getDate() + daysAfter);
            options['end'] = dt;
        }
        
        console.log('options=' + JSON.stringify(options));
        
        // Create a Timeline
        var timeline = new vis.Timeline(container, items, options);
        
        timeline.on('doubleClick', function (properties) {
           helper.navToRecord(component, properties.item);
        });
        
        component.set('v.timeline', timeline);
        
        var showFilter = component.get('v.showFilter');
        if (showFilter == 'true')
        {
            var target = component.find("filterDiv");
            $A.util.removeClass(target, 'hide');
        }
        
        helper.setRuntimeContext(component);
        
    },
    destroyCmp : function (component, event, helper) {
        component.destroy();
    },
    centerTimeline : function (component, event, helper) {
        var timeline = component.get("v.timeline");
        timeline.moveTo(new Date());
    },
    fitTimeline : function (component, event, helper) {
        
        var timeline = component.get("v.timeline");
        var range = timeline.getItemRange();
        var today = new Date();
        
        var min;
        var max;
        
        if (range == null || range.min == null || range.max == null)
        {
            min = today;
            max = today;
        }
        else
        {
            min = range.min;
            max = range.max;
        }

        
        if (today < range.min)
        {
            min = today;
        }
        
        if (today > range.max)
        {
            max = today;
        }
        
        timeline.setWindow(min.setDate(min.getDate() - 2), max.setDate(max.getDate() + 2));
    },
    resetTimeline : function (component, event, helper) {
        
        var timeline = component.get("v.timeline");
        timeline.setItems(new vis.DataSet(null));
        //helper.getGenericData(component);
        helper.filterData(component);
    },
    toggleFilter : function (component, event, helper) {
        var target = component.find("filterDiv");
        if ($A.util.hasClass(target, 'hide'))
        {
           $A.util.removeClass(target, 'hide');
        }
        else
        {
           $A.util.addClass(target, 'hide');
        }
    },
    handleFilterEvent : function (component, event, helper) {
        console.log('handleFilterEvent...');
        var action = event.getParam("action");
        console.log('  > action=' + action);
        if (action == 'start')
        {
           helper.showSpinner(component);
        }
        else
        {
           helper.hideSpinner(component); 
           helper.showControlIcons(component);
        }

    },
    itemsChange: function (component, event, helper) {
        console.log('itemsChange...');
        var timeline = component.get("v.timeline");
        
        var recs = component.get("v.recs");
        if (recs != null && recs.length > 0)
        {
          timeline.setItems(new vis.DataSet(recs));
        }
        else
        {
          timeline.setItems(null);
        }
    },
    toggleDateSel : function (component, event, helper) {
        var target = component.find("dateSelDiv");
        if ($A.util.hasClass(target, 'hide'))
        {
           $A.util.removeClass(target, 'hide');
        }
        else
        {
           $A.util.addClass(target, 'hide');
        }
    },
    onDateSel : function (component, event, helper) {
        //console.log('onDateSel');
        var moveToDate = component.get('v.dateSel');
        //console.log('dateStr=' + moveToDate);
        
        helper.hideDateSel(component);
        
        var timeline = component.get("v.timeline");
        //timeline.moveTo(moveToDate);
        
        var startDate = new Date(moveToDate);
        startDate.setDate(startDate.getDate() - 1);
        var endDate = new Date(moveToDate);
        endDate.setDate(endDate.getDate() + 2);
        timeline.setWindow(startDate, endDate);
    }
})