enum EditType { CHANGE_TABLE, UPDATE }

class EditOrderResponse {
  final EditType type;
  final String orignalTable;
  final String targetTable;

  EditOrderResponse({required this.type, this.orignalTable = '', this.targetTable = ''});
}
