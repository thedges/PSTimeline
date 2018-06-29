({
    jsLoaded : function(component, event, helper) {
        var globalId = component.getGlobalId();
        
        // DOM element where the Timeline will be attached
        var container = document.getElementById(globalId + '_timeline');
        
        /*
        var items = new vis.DataSet([
            {id: 1, content: '<img src="/resource/WazeIcons/police.png"/><a href="http://www.google.com">Chatter post</a>', start: '2013-04-20', type: 'point', className: 'red'},
            {id: 2, content: 'item 2', start: '2013-04-14', className: 'red'},
            {id: 3, content: 'item 3', start: '2013-04-18'},
            {id: 4, content: 'item 4', start: '2013-04-16', end: '2013-04-19'},
            {id: 5, content: 'item 5', start: '2013-04-25'},
            {id: 6, content: 'item 6', start: '2013-04-27'}
        ]);
        */
        
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
        options['showTooltips'] = (showTooltips);
        
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
        
        timeline.on('changed', function (properties) {
           helper.updateVisibleCount(component);
        });
        
        component.set('v.timeline', timeline);
        
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
        
        var min = range.min;
        var max = range.max;
        
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
        helper.getData(component);
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
    },
    toggleGroup : function (component, event, helper) {     
        var timeline = component.get("v.timeline");
        
        if (component.get('v.groupItems'))
        {
           component.set('v.groupItems', false);
           timeline.setGroups(null);             
        }
        else
        {
           component.set('v.groupItems', true);
           timeline.setGroups(component.get('v.groups')); 
        }

    }
})