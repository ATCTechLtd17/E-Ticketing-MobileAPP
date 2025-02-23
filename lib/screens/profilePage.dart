import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:eticket_atc/controller/profileController.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
 
    if (profileController.contactNumber.isNotEmpty) {
      profileController.fetchUserData();
    }

    return Scaffold(
      
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
              
                Row(
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
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                           
                            },
                            child: const Text("Edit Profile"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

       
                SingleChildScrollView(
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
                ),
                const SizedBox(height: 16),

          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoBox(
                      "Purchase",
                      profileController.purchaseCount.value.toString(),
                    ),
                    _buildInfoBox("All Ticket", "All Ticket"), 
                    _buildInfoBox(
                      "Cancel",
                      profileController.canceledCount.value.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  "Important Links",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                ListTile(
                  title: const Text("Home"),
                  onTap: () => context.go('/'), 
                ),
                ListTile(
                  title: const Text("View Ticket"),
                  onTap: () {
                 
                  },
                ),
                ListTile(
                  title: const Text("Logout"),
                  onTap: () {
                    
                  },
                ),
                const SizedBox(height: 24),

                
                const Text(
                  "Overview",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const Text(
                  "User Information",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

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
                  _buildUserInfoRow(
                      "Permanent Address", user.permanentAddress!),

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

  Widget _buildTabButton(BuildContext context, String label,
      {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: isSelected ? Colors.blue : Colors.grey.shade300,
        ),
        onPressed: () {
        },
        child: Text(label),
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
