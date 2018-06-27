({
	doInit : function(component, event, helper) {
      console.log('PSObjectSoqlFilterController...');
      console.log('  > selectFields=' + component.get('v.selectFields'));
      console.log('  > filterFields=' + component.get('v.filterFields'));
        helper.initFilterParams(component);
	},
    onFilter : function(component, event, helper) {
      console.log('onFilter...');
      console.log('  > selectFields=' + component.get('v.selectFields'));
      console.log('  > filterFields=' + component.get('v.filterFields')); 
      helper.executeFilter2(component);
	}
})