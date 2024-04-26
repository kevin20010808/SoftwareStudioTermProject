import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class RecentPhoto extends StatelessWidget {
  const RecentPhoto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4, // Number of items in your list
      itemBuilder: (context, itenId) {
        // Return a widget for your food data here, e.g., an image inside a card
        return Container(
          width: 160,
          margin: const EdgeInsets.only(right: 16), // Fixed width for each item
          child: InkWell(
            onTap: () => context.go('/list/$itenId'),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/food_$itenId.jpg'),
            ),
          ),
        );
      },
    );
  }
}

