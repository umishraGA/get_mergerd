class CommentModel {
  final String id;
  final String username;
  final String userImage;
  final String text;
  final DateTime timestamp;
  final String? parentId;
  final bool isReply;

  CommentModel({
    required this.id,
    required this.username,
    required this.userImage,
    required this.text,
    required this.timestamp,
    this.parentId,
    this.isReply = false,
  });

  // Factory method to create a dummy comment
  factory CommentModel.dummy() {
    return CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: 'User',
      userImage: 'assets/images/profile_pic.png',
      text:
          'Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development.',
      timestamp: DateTime.now(),
    );
  }

  CommentModel copyWith({String? id}) {
    return CommentModel(
      id: id ?? this.id,
      username: username,
      userImage: userImage,
      text: text,
      timestamp: timestamp,
      parentId: parentId,
      isReply: isReply,
    );
  }
}
