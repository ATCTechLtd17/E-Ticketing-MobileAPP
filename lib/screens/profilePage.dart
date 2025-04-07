import 'package:eticket_atc/controller/AuthController/authController.dart';
import 'package:eticket_atc/widgets/customTab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eticket_atc/controller/ProfileController/profileController.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  final String contactNumber;

  ProfilePage({super.key, required this.contactNumber}) {
    // Get existing controllers
    final authController = Get.find<AuthController>();
    final profileController = Get.find<ProfileController>();

    // Check authentication status before fetching profile data
    if (!authController.isAuthenticated.value) {
      // Redirect to login if not authenticated
      Get.offAllNamed('/login');
      return;
    }

    // Only fetch user data if it's not already loaded or if contact number changed
    if (profileController.user.value == null ||
        profileController.user.value?.contactNumber != contactNumber) {
      // Pass the auth token when fetching user data
      profileController.fetchUserData(contactNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get existing controller references
    final authController = Get.find<AuthController>();
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.lightBlue[100],
        
      ),
      body: SafeArea(
        child: Obx(() {
          // First check authentication status
          if (!authController.isAuthenticated.value) {
            // Redirect to login if not authenticated
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAllNamed('/login');
            });
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message if there's an error
          if (profileController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error: ${profileController.errorMessage.value}",
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        profileController.fetchUserData(contactNumber),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // Show loading indicator while data is being fetched
          if (profileController.isLoading.value ||
              profileController.user.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = profileController.user.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(user, profileController, authController),
                const SizedBox(height: 24),
                _buildStats(profileController),
                 CustomTabBar(),
                const SizedBox(height: 24),
                _buildSectionHeader("Account Management"),
                _buildAccountOptions(context,authController),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "Developed by ATC Tech Ltd.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileHeader(user, ProfileController profileController,
      AuthController authController) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueGrey.shade200,
          child: user.profileImage == null
              ? const Icon(Icons.person, size: 40)
              : ClipOval(
                  child: Image.network(
                    user.profileImage!,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 40);
                    },
                  ),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                user.contactNumber,
                style: const TextStyle(color: Colors.grey),
              ),
             /* TextButton(
                onPressed: () {
                  // Use AuthController's token to pass to edit profile page
                  Get.toNamed('/edit-profile', arguments: {
                    'user': user,
                    'token': authController.token.value
                  });
                },
                child: const Text("Edit Profile"),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats(ProfileController profileController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoBox(
              "Purchase", profileController.purchaseCount.value.toString()),
          _buildInfoBox(
              "All Tickets", profileController.purchaseCount.value.toString()),
          _buildInfoBox(
              "Canceled", profileController.canceledCount.value.toString()),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Divider(),
      ],
    );
  }

  

  Widget _buildAccountOptions(BuildContext context, AuthController authController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // ListTile(
          //   leading: const Icon(Icons.lock, color: Colors.blue),
          //   title: const Text("Change Password"),
          //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          //   onTap: () {
          //     // Navigate to change password screen with auth token
          //     Get.toNamed('/change-password',
          //         arguments: {'token': authController.token.value});
          //   },
          // ),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () async {
              await authController.logout();
              GoRouter.of(context).push('/login');
             
            },
          ),
        ],
      ),
    );
  }

}
