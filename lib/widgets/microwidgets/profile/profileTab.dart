import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eticket_atc/controller/profileController.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    return Obx(() {
      if (profileController.user.value == null) {
        return const Center(child: CircularProgressIndicator());
      }
      final user = profileController.user.value!;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Overview"),
            _buildUserInfo(user),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
