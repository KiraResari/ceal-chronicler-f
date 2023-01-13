abstract class DisplayField<T>{
  String fieldName;
  T value;

  DisplayField(this.fieldName, this.value);

  String getDisplayValue();
}