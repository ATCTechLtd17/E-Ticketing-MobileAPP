import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:eticket_atc/controller/profileController.dart';

class ProfilePage extends StatelessWidget {
  final String contactNumber;

  ProfilePage({super.key, required this.contactNumber}) {
    print(contactNumber);
    final ProfileController profileController = Get.put(ProfileController());
    profileController.fetchUserData(contactNumber);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
print(profileController.user);
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: SafeArea(
        child: Obx(() {
          if (profileController.user.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = profileController.user.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 24),
                _buildTabBar(context),
                const SizedBox(height: 16),
                _buildStats(profileController),
                const SizedBox(height: 24),
                _buildSectionHeader("Overview"),
                _buildUserInfo(user),
                const SizedBox(height: 32),
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

  Widget _buildProfileHeader(user) {
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
              TextButton(
                onPressed: () {},
                child: const Text("Edit Profile"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabButton(context, "Profile", isSelected: true),
          _buildTabButton(context, "Insights"),
          _buildTabButton(context, "Tickets"),
          _buildTabButton(context, "Total Buy"),
          _buildTabButton(context, "Cancel Request"),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String label,
      {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: isSelected ? Colors.blue : Colors.grey.shade300,
        ),
        onPressed: () {},
        child: Text(label),
      ),
    );
  }

  Widget _buildStats(ProfileController profileController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoBox(
            "Purchase", profileController.purchaseCount.value.toString()),
        _buildInfoBox("All Ticket", "All Ticket"),
        _buildInfoBox(
            "Cancel", profileController.canceledCount.value.toString()),
      ],
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



  Widget _buildUserInfo(user) {
    return Column(
      children: [
        _buildUserInfoRow("Full Name", user.fullName),
        _buildUserInfoRow("Contact Number", user.contactNumber),
        _buildUserInfoRow(
            "Emergency Contact Number", user.emergencyContactNumber),
        _buildUserInfoRow("Email", user.email),
        _buildUserInfoRow("Date of Birth", user.dateOfBirth),
        _buildUserInfoRow("Gender", user.gender),
        if (user.nidCardNumber != null)
          _buildUserInfoRow("NID Card Number", user.nidCardNumber!),
        if (user.presentAddress != null)
          _buildUserInfoRow("Present Address", user.presentAddress!),
        if (user.permanentAddress != null)
          _buildUserInfoRow("Permanent Address", user.permanentAddress!),
      ],
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
