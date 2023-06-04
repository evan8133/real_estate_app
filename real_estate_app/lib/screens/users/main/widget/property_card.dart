
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../../model/properties_model.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
  });

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(
                15.0,
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: 'https://via.placeholder.com/150',
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      LineAwesome.home_solid,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const Icon(
                      Bootstrap.cash,
                    ),
                    const SizedBox(width: 10.0),

                    Text(
                      'Price: \$${property.price.toString()}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 10.0),
                Row(
                  children: [
                     const Icon(
                      BoxIcons.bx_area,
                    ),
                    const SizedBox(width: 10.0),

                    Text(
                      'Size: ${property.size.toString()} sqm',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const Icon(
                     BoxIcons.bx_bed,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'Bed Rooms: ${property.bedroomCount.toString()}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Tags(
                  itemCount: 3, // required
                  itemBuilder: (index) {
                    final List<String> labels = [
                      property.type,
                      property.forSale ? "For Sale" : "Not For Sale",
                      property.forRent ? "For Rent" : "Not For Rent",
                    ];
                    return ItemTags(
                      index: index, // required
                      title: labels[index],
                      active: true,
                      pressEnabled: false,
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                      combine: ItemTagsCombine.withTextBefore,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
