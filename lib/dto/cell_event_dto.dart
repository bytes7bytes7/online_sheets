const _cellIDKey = 'cellID';
const _valueKey = 'value';

class CellEventDTO {
  const CellEventDTO({
    required this.cellID,
    required this.value,
  });

  final String cellID;
  final String value;

  factory CellEventDTO.fromJson(Map<String, Object?> json) {
    return CellEventDTO(
      cellID: json[_cellIDKey] as String,
      value: json[_valueKey] as String,
    );
  }

  Map<String, Object?> toJson() => {
        _cellIDKey: cellID,
        _valueKey: value,
      };
}
