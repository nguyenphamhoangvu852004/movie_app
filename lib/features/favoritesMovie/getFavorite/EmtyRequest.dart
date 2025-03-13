import '../../../constants/interfaces/RequestData.dart';

class EmptyRequest implements RequestData {
  final int userId;

  EmptyRequest(this.userId);
}
