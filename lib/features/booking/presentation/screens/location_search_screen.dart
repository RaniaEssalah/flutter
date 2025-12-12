import 'package:flutter/material.dart';
import 'package:chauffeur_app/core/theme/app_colors.dart';
import 'package:chauffeur_app/core/router/app_router.dart';

/// Location search screen with autocomplete
class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final _pickupFocus = FocusNode();
  final _destinationFocus = FocusNode();

  // Mock search results
  final List<_LocationResult> _recentLocations = [
    _LocationResult(
      title: 'San Francisco Airport',
      subtitle: 'San Francisco International Airport, CA',
      icon: Icons.flight_rounded,
    ),
    _LocationResult(
      title: 'Golden Gate Bridge',
      subtitle: 'Golden Gate Bridge, San Francisco, CA',
      icon: Icons.location_on_rounded,
    ),
    _LocationResult(
      title: 'Fisherman\'s Wharf',
      subtitle: 'Fisherman\'s Wharf, San Francisco, CA',
      icon: Icons.location_on_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pickupController.text = 'Current Location';
    _destinationFocus.requestFocus();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocus.dispose();
    _destinationFocus.dispose();
    super.dispose();
  }

  void _selectLocation(_LocationResult location) {
    setState(() {
      _destinationController.text = location.title;
    });
    Navigator.pushNamed(context, AppRouter.vehicleSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Select Location'),
      ),
      body: Column(
        children: [
          // Location Input Fields
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Pickup Location
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3),
                              width: 3,
                            ),
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 40,
                          color: AppColors.divider,
                        ),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3),
                              width: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: _pickupController,
                            focusNode: _pickupFocus,
                            decoration: const InputDecoration(
                              hintText: 'Pickup location',
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _destinationController,
                            focusNode: _destinationFocus,
                            decoration: const InputDecoration(
                              hintText: 'Where to?',
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Saved Places
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _QuickLocationChip(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  onTap: () => _selectLocation(_LocationResult(
                    title: 'Home',
                    subtitle: '123 Main Street',
                    icon: Icons.home_rounded,
                  )),
                ),
                const SizedBox(width: 12),
                _QuickLocationChip(
                  icon: Icons.work_rounded,
                  label: 'Work',
                  onTap: () => _selectLocation(_LocationResult(
                    title: 'Work',
                    subtitle: '456 Office Ave',
                    icon: Icons.work_rounded,
                  )),
                ),
                const SizedBox(width: 12),
                _QuickLocationChip(
                  icon: Icons.add_rounded,
                  label: 'Add',
                  onTap: () {
                    // Add new location
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recent/Search Results
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'RECENT LOCATIONS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._recentLocations.map((location) => _LocationListItem(
                        location: location,
                        onTap: () => _selectLocation(location),
                      )),
                  const SizedBox(height: 24),
                  
                  // Choose on Map
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.map_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    title: const Text(
                      'Choose on map',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    onTap: () {
                      // Open map picker
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationResult {
  final String title;
  final String subtitle;
  final IconData icon;

  _LocationResult({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _QuickLocationChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickLocationChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationListItem extends StatelessWidget {
  final _LocationResult location;
  final VoidCallback onTap;

  const _LocationListItem({
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          location.icon,
          color: AppColors.textSecondary,
        ),
      ),
      title: Text(
        location.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        location.subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
      onTap: onTap,
    );
  }
}

