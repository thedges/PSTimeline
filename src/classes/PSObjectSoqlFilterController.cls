public class PSObjectSoqlFilterController {
    @AuraEnabled
    public static Object prepFilterFields(String objectName, String filterFields) 
    {
        System.debug('prepFilterFields invoked...');
        //Map<String, String> paramMap = (Map<String, String>)JSON.deserialize(params,   Map<String, String>.class);
        //System.debug(JSON.serializePretty(paramMap));
        //System.debug('filterField.3=' + paramMap.get('filterFields'));
        
        try
        {  
            //String objectName = paramMap.get('objectName');
            //String filterFields = paramMap.get('filterFields');
            //System.debug('result=' + JSON.serializePretty(PSMetaUtils.getMetaFieldDesc3(objectName, filterFields)));
            return PSMetaUtils.getMetaFieldDesc3(objectName, filterFields);
        }
        catch (exception e)
        {
            throw new AuraHandledException(e.getTypeName() + ' - ' + e.getMessage() + ' [Line: ' + e.getLineNumber() + ']');
        }
        
    }

    @AuraEnabled
    public static Object queryObjectDataList(String params)
    {
        System.debug('queryObjectDataList...');
        Map<String, String> paramMap = (Map<String, String>)JSON.deserialize(params,   Map<String, String>.class);
        System.debug(JSON.serializePretty(paramMap));

        try
        {
            Object filterFieldComps = null;
            if (paramMap.containsKey('filterFieldComps')) filterFieldComps = paramMap.get('filterFieldComps');
            
            // setup record processor
            PSRecordProcessorIF processor = null;
            if (paramMap.containsKey('processorName'))
            {
                Type customType = Type.forName(paramMap.get('processorName'));
                processor = (PSRecordProcessorIF)customType.newInstance();
                
                if (paramMap.containsKey('processorOptions'))
                {
                    System.debug('processorOptions=' + paramMap.containsKey('processorOptions'));
                    Map<String,String> options = (Map<String,String>)JSON.deserialize(paramMap.get('processorOptions'), Map<String,String>.class);
                    processor.setConfig(options);
                }
            }
            
            String objectName = paramMap.get('objectName');
            String selectFields = paramMap.get('selectFields');
            String filterFields = paramMap.get('filterFields');
            String filterCondition = paramMap.get('filterCondition');
            String dateField = paramMap.get('dateField');
            
            // check for DateTime field
            PSField fld = PSMetaUtils.getFieldDef(objectName, dateField, null);
            if (fld.ftype != PSField.TYPE_DATETIME)
            {
                throw new PSIllegalArgumentException('The object date field must be of type DATETIME');
            }
            
            PSSoqlBuilder soqlBldr = new PSSoqlBuilder();
            soqlBldr.selectx(PSDemoUtils.parseCSVString(selectFields));

            soqlBldr.fromx(objectName);
            
            PSConditionGroup filterClause = null;
            if (filterCondition == 'OR')
            {
                filterClause = new PSOrCondition();   
            }
            else
            {
                filterClause = new PSAndCondition();
            }
            filterClause.add(new PSFieldCondition(dateField).notEquals(null));
            
            if (filterFields != null && filterFields.length() > 0)
            {
                List<PSField> filterList = (List<PSField>)JSON.deserialize(filterFields, List<PSField>.class);
                for (PSField filter : filterList)
                {

                    System.debug('filterField=' + JSON.serializePretty(filter));
                    if (filter.value != null && filter.value.length() > 0)
                    {
                        filter.value = filter.value.trim(); 
                        if (filter.ftype == PSField.TYPE_STRING || filter.ftype == PSField.TYPE_EMAIL || filter.ftype == PSField.TYPE_PHONE)
                        {
                            if (filter.wildcard)
                            {
                                if (filter.value.contains('%') || filter.value.contains('_'))
                                {
                                   filterClause.add(new PSFieldCondition(filter.name).likex(filter.value)); 
                                }
                                else
                                {
                                   filterClause.add(new PSFieldCondition(filter.name).likex('%' + filter.value + '%'));  
                                }
                            }
                            else if (filter.value.contains('%') || filter.value.contains('_'))
                            {
                                filterClause.add(new PSFieldCondition(filter.name).likex(filter.value));
                            }
                            else
                            {
                                filterClause.add(new PSFieldCondition(filter.name).equals(filter.value));  
                            }
                        }
                        else if (filter.ftype == PSField.TYPE_PICKLIST)
                        {
                            filterClause.add(new PSFieldCondition(filter.name).equals(filter.value));  
                        }
                        else if (filter.ftype == PSField.TYPE_MULTIPICKLIST)
                        {
                            if (filter.value.contains(';'))
                            {
                               filterClause.add(new PSSetCondition(filter.name).includes(PSDemoUtils.parseDelimitedString(filter.value, ';')));  
                            }
                            else
                            {
                               filterClause.add(new PSFieldCondition(filter.name).equals(filter.value));    
                            }
                        }
                        else if (filter.ftype == PSField.TYPE_BOOLEAN)
                        {
                          filterClause.add(new PSFieldCondition(filter.name).equals(Boolean.valueOf(filter.value)));                               
                        }
                        else if (filter.ftype == PSField.TYPE_CURRENCY)
                        {
                            filterClause.add(new PSFieldCondition(filter.name).equals(filter.value));                              
                        }
                        else if (filter.ftype == PSField.TYPE_DATE)
                        {
                           filterClause.add(new PSFieldCondition(filter.name).equals(Date.parse(filter.value)));                            
                        }
                        else if (filter.ftype == PSField.TYPE_DATETIME)
                        {
                           filterClause.add(new PSFieldCondition(filter.name).equals(DateTime.parse(filter.value)));                                                        
                        }
                        else if (filter.ftype == PSField.TYPE_DOUBLE)
                        {
                           if (filter.value.contains('-'))
                           {
                               PSAndCondition tmpCond = new PSAndCondition();
                               List<String> vals = PSDemoUtils.parseDelimitedString(filter.value, '-');
                               if (vals.size() != 2)
                               {
                                   throw new PSIllegalArgumentException('Incorrect range value [' + filter.value + ']');
                               }
                               tmpCond.add(new PSFieldCondition(filter.name).greaterThanOrEqualTo(Double.valueOf(vals[0])));
                               tmpCond.add(new PSFieldCondition(filter.name).lessThanOrEqualTo(Double.valueOf(vals[1])));
                               filterClause.add(tmpCond);
                           }
                           else if (filter.value.startsWith('>='))
                           {
                              filterClause.add(new PSFieldCondition(filter.name).greaterThanOrEqualTo(Double.valueOf(filter.value.substring(2)))); 
                           }
                           else if (filter.value.startsWith('<='))
                           {
                              filterClause.add(new PSFieldCondition(filter.name).lessThanOrEqualTo(Double.valueOf(filter.value.substring(2))));  
                           }
                           else if (filter.value.startsWith('>'))
                           {
                              filterClause.add(new PSFieldCondition(filter.name).greaterThan(Double.valueOf(filter.value.substring(1))));  
                           }
                           else if (filter.value.startsWith('<'))
                           {
                              filterClause.add(new PSFieldCondition(filter.name).lessThan(Double.valueOf(filter.value.substring(1))));  
                           }
                           else
                           {
                             filterClause.add(new PSFieldCondition(filter.name).equals(Double.valueOf(filter.value)));
                           }
                        }
                    }
                }
            }
            
            // get earliest date if not null
            DateTime edt = null;
            String earliestDate = paramMap.get('earliestDate');
            if (earliestDate != null)
            {
                if (earliestDate.contains('/') && earliestDate.length() == 10)
                {
                    Date tmpDate = Date.parse(earliestDate);
                    edt = DateTime.newInstance(tmpDate, Time.newInstance(00,00,00,00));
                }
                else if (earliestDate.length() > 0)
                {
                    Integer val = 0 - Integer.valueOf(earliestDate);
                    Date tmpDate = Date.today();
                    tmpDate = tmpDate.addDays(val);
                    edt = DateTime.newInstance(tmpDate, Time.newInstance(00,00,00,00));
                }
            }
            
            if ((edt != null) && (filterClause != null) && (filterClause.conditions.size() > 0))
            {
               PSAndCondition wrapCondition = new PSAndCondition();
               wrapCondition.add(new PSFieldCondition(dateField).greaterThanOrEqualTo(edt));
               wrapCondition.add(filterClause);
               soqlBldr.wherex(wrapCondition);
            }
            else if ((edt != null) && (filterClause == null))
            {
               soqlBldr.wherex(new PSFieldCondition(dateField).greaterThanOrEqualTo(edt)); 
            }
            else if ((edt == null) && (filterClause != null) && (filterClause.conditions.size() > 0 ))
            {
               soqlBldr.wherex(filterClause);
            }
            

            PSOrderBy ob = new PSOrderBy(dateField);
            ob.descending();
            soqlBldr.orderbyx(ob);
            
            String soqlLimit = paramMap.get('soqlLimit');
            if (soqlLimit != null && soqlLimit.length() > 0) soqlBldr.limitx(Integer.valueOf(soqlLimit));
            
            System.debug('soqlBldr=' + soqlBldr.toSoql());
            
            //String queryStr = 'SELECT Id, Subject, MarkerHTML__c,CreatedDate,Color__c,MapIcon__c FROM Case LIMIT 200';
            String queryStr = soqlBldr.toSoql();
            
            List<sObject> recList = Database.query(queryStr);
            if (processor == null)
            {
                Map<String, Object> resp = new Map<String, Object>();
                resp.put('type', 'SOQL');
                resp.put('data', recList);

                return resp;
                //return recList;
            }
            else 
            {
                for (sObject rec : recList)
                {
                    processor.processRecord(rec);
                }
                processor.postProcess();

                //return processor.getItemList();
                return processor.getResponse();
            }
        }
            catch (exception e)
    {
      throw new AuraHandledException(e.getMessage());
    }
    }
}