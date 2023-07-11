import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/model/properties_model.dart';
import 'package:real_estate_app/services/firestore_properties_methods.dart';
import 'package:shimmer/shimmer.dart';

import '../main/widget/property_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> imageUrls = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<String>> fetchPropertyImages(String properteId) async {
    try {
      final ListResult result =
          await storage.ref('house/$properteId/images').listAll();

      final List<String> urls = [];
      for (final ref in result.items) {
        final imageUrl = await ref.getDownloadURL();
        urls.add(imageUrl);
      }
      return urls;
    } catch (e) {
      log('Failed to fetch property images: $e');
    }
    return [];
  }

  final TextEditingController _searchController = TextEditingController();
  bool isForSale = true;
  bool isForRent = true;
  bool isPriceLowToHigh = false;
  bool isPriceHighToLow = false;
  bool isHouse = false;
  bool isApartment = false;
  bool isVilla = false;
  List<Property> properties = [];

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      List<Property> fetchedProperties =
          await context.read<PropertyService>().getProperties();
      setState(() {
        properties = fetchedProperties;
      });
    } catch (error) {
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            // Updated height value
            _buildFilterOptions(),
            SizedBox(height: 10.h), // Updated height value
            Expanded(
              child: properties.isEmpty
                  ? _buildLoadingIndicator()
                  : _buildResultList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filters',
          style: GoogleFonts.notoSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('For Sale', isForSale, (value) {
                setState(() {
                  isForSale = value;
                });
              }),
              _buildFilterChip('For Rental', isForRent, (value) {
                setState(() {
                  isForRent = value;
                });
              }),
              _buildFilterChip('Price Low to High', isPriceLowToHigh, (value) {
                setState(() {
                  isPriceLowToHigh = value;
                  isPriceHighToLow = false;
                });
              }),
              _buildFilterChip('Price High to Low', isPriceHighToLow, (value) {
                setState(() {
                  isPriceLowToHigh = false;
                  isPriceHighToLow = value;
                });
              }),
              _buildFilterChip('House', isHouse, (value) {
                setState(() {
                  isHouse = value;
                });
              }),
              _buildFilterChip('Apartment', isApartment, (value) {
                setState(() {
                  isApartment = value;
                });
              }),
              _buildFilterChip('Villa', isVilla, (value) {
                setState(() {
                  isVilla = value;
                });
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
      String label, bool selected, ValueChanged<bool> onSelected) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 16.sp,
        ),
        selected: selected,
        onSelected: onSelected,
        selectedColor: Theme.of(context).colorScheme.secondary,
        checkmarkColor: Theme.of(context).colorScheme.primary,
        showCheckmark: true,
        selectedShadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
      ),
    );
  }

  Widget _buildResultList() {
    List<Property> filteredProperties = _applyFilters();
    if (filteredProperties.isEmpty) {
      return Center(child: Text('No properties found!'));
    }
    return ListView.separated(
      itemCount: filteredProperties.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: fetchPropertyImages(filteredProperties[index].propertyId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: PropertyCard(property: filteredProperties[index]),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            filteredProperties[index].imageUrls = snapshot.data as List<String>;
            return PropertyCard(
              property: filteredProperties[index],
            );
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  List<Property> _applyFilters() {
    List<Property> filteredProperties = properties;

    if (!(isForSale ||
        isForRent ||
        isPriceLowToHigh ||
        isPriceHighToLow ||
        isHouse ||
        isApartment ||
        isVilla)) {
      // Return all properties if no filters are selected
      return filteredProperties;
    }

    if (!isForSale) {
      filteredProperties = filteredProperties
          .where(
            (property) => !property.forSale,
          )
          .toList();
    }
    if (!isForRent) {
      filteredProperties = filteredProperties
          .where(
            (property) => !property.forRent,
          )
          .toList();
    }

    if (isHouse || isApartment || isVilla) {
      filteredProperties = filteredProperties
          .where(
            (property) =>
                (isHouse && property.type == 'House') ||
                (isApartment && property.type == 'Apartment') ||
                (isVilla && property.type == 'Villa'),
          )
          .toList();
    }

    if (isPriceLowToHigh) {
      filteredProperties.sort((a, b) => a.price.compareTo(b.price));
    } else if (isPriceHighToLow) {
      filteredProperties.sort((a, b) => b.price.compareTo(a.price));
    }

    return filteredProperties;
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }
}
