import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? profilePhoto;

  const ProfileAvatar({super.key, this.profilePhoto});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: Colors.white,
      child: profilePhoto != null && profilePhoto!.isNotEmpty
          ? ClipOval(
              child: FutureBuilder<Image>(
                future: _loadNetworkImage(profilePhoto!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFEA580C),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.person,
                        size: 35, color: Colors.grey);
                  } else {
                    return snapshot.data!;
                  }
                },
              ),
            )
          : const Icon(Icons.person, size: 35, color: Colors.grey),
    );
  }

  Future<Image> _loadNetworkImage(String url) async {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: 70,
      height: 70,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFFEA580C),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, size: 35, color: Colors.grey);
      },
    );
  }
}
