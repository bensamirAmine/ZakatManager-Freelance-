import 'package:flutter/material.dart';

import '../../constants.dart';

import '../small_dot.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.foodType,
    required this.price,
    required this.press,
  });

  final String? title, description, image, foodType;
  final double? price;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: titleColor.withOpacity(0.64),
          fontWeight: FontWeight.normal,
        );
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 110,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 1,
                    ),
                    Text(title!,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          child: SmallDot(),
                        ),
                        Text(
                          description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          child: SmallDot(),
                        ),
                        Text(foodType!, style: textStyle),
                        const Spacer(),
                        Text(
                          "DT$price",
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: primaryColor),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
