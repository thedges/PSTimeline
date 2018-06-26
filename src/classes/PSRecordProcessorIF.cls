public Interface PSRecordProcessorIF {
  void setConfig(Map<String, String> config);
  void addConfig(String name, String value);
    
  void processRecord(SObject rec);
  void postProcess();
  String toJSON();
}