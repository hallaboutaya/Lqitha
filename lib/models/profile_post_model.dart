class ProfilePost {
  final String title;
  final String location;
  final String imageUrl;
  final String status; // validated, on_hold, rejected
  final String date;
  final String? note; // optional, e.g., “Waiting for admin approval”

  const ProfilePost({
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.status,
    required this.date,
    this.note,
  });
}
