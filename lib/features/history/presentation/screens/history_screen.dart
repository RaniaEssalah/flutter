import 'package:flutter/material.dart';
import 'package:chauffeur_app/core/theme/app_colors.dart';

/// Ride history screen with past rides
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_RideHistory> _completedRides = [
    _RideHistory(
      id: '1',
      pickup: '123 Main Street',
      destination: 'San Francisco Airport',
      date: DateTime.now().subtract(const Duration(days: 1)),
      price: 18.00,
      driverName: 'Michael Johnson',
      driverRating: 4.9,
      vehicleType: 'Premium',
      status: RideStatus.completed,
    ),
    _RideHistory(
      id: '2',
      pickup: '456 Oak Avenue',
      destination: 'Golden Gate Bridge',
      date: DateTime.now().subtract(const Duration(days: 3)),
      price: 24.50,
      driverName: 'Sarah Williams',
      driverRating: 4.8,
      vehicleType: 'Luxury',
      status: RideStatus.completed,
    ),
    _RideHistory(
      id: '3',
      pickup: 'Fisherman\'s Wharf',
      destination: 'Union Square',
      date: DateTime.now().subtract(const Duration(days: 5)),
      price: 12.00,
      driverName: 'David Chen',
      driverRating: 4.7,
      vehicleType: 'Economy',
      status: RideStatus.completed,
    ),
  ];

  final List<_RideHistory> _cancelledRides = [
    _RideHistory(
      id: '4',
      pickup: '789 Pine Street',
      destination: 'Market Street',
      date: DateTime.now().subtract(const Duration(days: 7)),
      price: 0,
      driverName: '',
      driverRating: 0,
      vehicleType: 'Economy',
      status: RideStatus.cancelled,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ride History'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRideList(_completedRides),
          _buildRideList(_cancelledRides),
        ],
      ),
    );
  }

  Widget _buildRideList(List<_RideHistory> rides) {
    if (rides.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.inputBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No rides yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your ride history will appear here',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        return _RideHistoryCard(ride: rides[index]);
      },
    );
  }
}

enum RideStatus { completed, cancelled }

class _RideHistory {
  final String id;
  final String pickup;
  final String destination;
  final DateTime date;
  final double price;
  final String driverName;
  final double driverRating;
  final String vehicleType;
  final RideStatus status;

  _RideHistory({
    required this.id,
    required this.pickup,
    required this.destination,
    required this.date,
    required this.price,
    required this.driverName,
    required this.driverRating,
    required this.vehicleType,
    required this.status,
  });
}

class _RideHistoryCard extends StatelessWidget {
  final _RideHistory ride;

  const _RideHistoryCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(ride.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ride.status == RideStatus.completed
                            ? AppColors.success.withValues(alpha: 0.1)
                            : AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ride.status == RideStatus.completed
                            ? 'Completed'
                            : 'Cancelled',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: ride.status == RideStatus.completed
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Route
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 24,
                          color: AppColors.divider,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ride.pickup,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            ride.destination,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (ride.status == RideStatus.completed) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Driver info
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride.driverName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppColors.starColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${ride.driverRating} • ${ride.vehicleType}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${ride.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Actions
          Container(
            decoration: const BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.receipt_long_rounded, size: 18),
                    label: const Text('Receipt'),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: AppColors.divider,
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Rebook'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

