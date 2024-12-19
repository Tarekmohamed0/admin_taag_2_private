import 'package:admin_taag/models/user_entity.dart';
import 'package:admin_taag/services/firestore_servise.dart';
import 'package:flutter/material.dart';

class UsersDashboard extends StatelessWidget {
  const UsersDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users Dashboard")),
      body: StreamBuilder<List<UserModel>>(
        stream: FirestoreServise().fetchUsersStream(), // get data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //
            return const Center(child: CircularProgressIndicator());
            //
          } else if (snapshot.hasError) {
            //
            return Center(child: Text("Error: ${snapshot.error}"));
            //
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //
            return const Center(child: Text("No users found."));
          }
          final users = snapshot.data!;
          //
          return ListView.builder(
            itemCount: users.length,
            //
            itemBuilder: (context, index) {
              //
              final user = users[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10.0),
                  leading: CircleAvatar(
                    backgroundImage: user.image.isNotEmpty
                        ? NetworkImage(user.image)
                        : null, // Show image if available
                    child: user.image.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null, // Fallback icon
                  ),

                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${user.email}"),
                      Text("Phone: ${user.phone}"),
                    ],
                  ),
                  trailing: Text(user.nation),
                  // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Add navigation or action if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
