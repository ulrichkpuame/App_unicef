class IssueUpdate {
  String status;
  String comment;
  String closedById;
  String closedByName;

  IssueUpdate(
      {required this.status,
      required this.comment,
      required this.closedById,
      required this.closedByName});

  factory IssueUpdate.fromJson(Map<String, dynamic> json) {
    return IssueUpdate(
      status: json['status'],
      comment: json['comment'],
      closedById: json['closedById'],
      closedByName: json['closedByName'],
    );
  }
}
