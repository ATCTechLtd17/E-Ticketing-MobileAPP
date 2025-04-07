import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eticket_atc/controller/ProfileController/profileController.dart';
import 'package:eticket_atc/controller/TicketController/ticketDetailsController.dart';
import 'package:eticket_atc/screens/ticketDetails.dart';
import 'package:intl/intl.dart';

class TicketTab extends StatefulWidget {
  const TicketTab({super.key});

  @override
  State<TicketTab> createState() => _TicketTabState();
}

class _TicketTabState extends State<TicketTab> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final RxList<Map<String, dynamic>> _tickets = <Map<String, dynamic>>[].obs;
  final RxBool _isLoading = true.obs;
  final RxString _errorMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // Check if user is authenticated and profile is loaded
      if (_profileController.user.value == null) {
        _errorMessage.value = 'Please log in to view your tickets';
        _isLoading.value = false;
        return;
      }

      final contactNumber = _profileController.user.value!.contactNumber;

      // Using profileController to handle API instead of direct HTTP call
      final result = await _profileController.fetchUserTickets(contactNumber);

      if (result.isNotEmpty) {
        _tickets.value = result;
      } else {
        _errorMessage.value = 'No tickets found';
      }
    } catch (e) {
      _errorMessage.value = 'Error fetching tickets: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  void _viewTicketDetails(Map<String, dynamic> ticket) {
    // Register TicketDetailsController if not registered
    if (!Get.isRegistered<TicketDetailsController>()) {
      Get.put(TicketDetailsController());
    }

    final TicketDetailsController ticketController =
        Get.find<TicketDetailsController>();

    // Format ticket data for the details view
    final Map<String, dynamic> formattedTicket = {
      "passengerName":
          ticket['name'] ?? _profileController.user.value?.fullName ?? "N/A",
      "phone": ticket['contactNumber'] ?? "N/A",
      "fromCity": ticket['from'] ?? "N/A",
      "toCity": ticket['to'] ?? "N/A",
      "issueDate": _formatDate(ticket['createdAt']),
      "journeyDate": _formatDate(ticket['depertureDate']),
      "boardingPoint": ticket['boardingPoint'] ?? "N/A",
      "droppingPoint": ticket['droppingPoint'] ?? "N/A",
      "departureTime": ticket['depertureTime'] ?? "N/A",
      "busName": ticket['busDetails']?['busName'] ?? "Hanif Enterprise",
      "busType": ticket['busType'] ?? "N/A",
      "coachType": ticket['coachType'] ?? "N/A",
      "seatNumbers": ticket['seatNumber'] ?? [],
      "originalPrice": "${ticket['ticketPrice'] ?? 0} BDT",
    };

    // Set ticket data in controller
    ticketController.setTicketData(formattedTicket);

    // Navigate to ticket details page
    Get.to(() => const TicketDetailsPage());
  }

  String _formatDate(dynamic dateString) {
    if (dateString == null) return "N/A";

    try {
      DateTime date;
      if (dateString is String) {
        date = DateTime.parse(dateString);
      } else {
        return dateString.toString();
      }

      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return dateString.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchTickets,
        child: Obx(() {
          if (_isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_errorMessage.value.isNotEmpty) {
            return _buildErrorView();
          }

          if (_tickets.isEmpty) {
            return _buildEmptyTicketsView();
          }

          return _buildTicketsList();
        }),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: SingleChildScrollView(
        // Added SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchTickets,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTicketsView() {
    return Center(
      child: SingleChildScrollView(
        // Added SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No tickets found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You haven\'t purchased any tickets yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchTickets,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketsList() {
    // Adding SafeArea to ensure content is within safe bounds
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tickets.length,
        itemBuilder: (context, index) {
          final ticket = _tickets[index];
          return _buildTicketCard(ticket);
        },
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final busDetails = ticket['busDetails'] ?? {};
    // Extract bus type and coach type from the correct location
    final String busType = ticket['busType'] ?? busDetails['busType'] ?? 'N/A';
    final String coachType =
        ticket['coachType'] ?? busDetails['coachType'] ?? 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewTicketDetails(ticket),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBusCompanyHeader(busDetails, busType, coachType),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildRouteInformation(ticket),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildTravelDateAndSeats(ticket),
              const SizedBox(height: 12),
              _buildTransactionAndPrice(ticket, context),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: () => _viewTicketDetails(ticket),
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Ticket Details'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusCompanyHeader(
      Map<String, dynamic> busDetails, String busType, String coachType) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Ensure proper alignment
      children: [
        _buildBusCompanyLogo(busDetails),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                busDetails['busName'] ?? 'Hanif Enterprise',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                // Prevent long text from overflowing
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              _buildBusTypeInfo(busType, coachType),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusCompanyLogo(Map<String, dynamic> busDetails) {
    final String? logoUrl = busDetails['busCompany']?['logo'];

    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          logoUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (ctx, _, __) => _buildDefaultBusIcon(),
        ),
      );
    }

    return _buildDefaultBusIcon();
  }

  Widget _buildDefaultBusIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.directions_bus),
    );
  }

  Widget _buildBusTypeInfo(String busType, String coachType) {
    return Wrap(
      // Using Wrap instead of Row to handle long text
      children: [
        Text(
          busType,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const Text(' • '),
        Text(
          coachType,
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRouteInformation(Map<String, dynamic> ticket) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to top
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FROM',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                ticket['from'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Text(
                ticket['boardingPoint'] ?? 'N/A',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              const Icon(
                Icons.arrow_forward,
                color: Colors.grey,
              ),
              Text(
                ticket['depertureTime'] ?? 'N/A',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'TO',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                ticket['to'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 4),
              Text(
                ticket['droppingPoint'] ?? 'N/A',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTravelDateAndSeats(Map<String, dynamic> ticket) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          // Added Expanded to ensure proper space allocation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Travel Date',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                _formatDate(ticket['depertureDate']),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Expanded(
          // Added Expanded to ensure proper space allocation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Seats',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                _formatSeatNumbers(ticket['seatNumber']),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatSeatNumbers(dynamic seatNumbers) {
    if (seatNumbers is List) {
      return seatNumbers.join(', ');
    }
    return seatNumbers?.toString() ?? 'N/A';
  }

  Widget _buildTransactionAndPrice(
      Map<String, dynamic> ticket, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          // Added Expanded to ensure proper space allocation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transaction ID',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                ticket['transactionId'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow
                    .ellipsis, // Add this to handle long transaction IDs
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '৳ ${ticket['ticketPrice'] ?? '0'}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
