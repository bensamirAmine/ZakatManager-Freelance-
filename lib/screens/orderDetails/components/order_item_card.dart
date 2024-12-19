import 'package:flutter/material.dart';
import '../../../constants.dart';

class OrderedItemCard extends StatefulWidget {
  const OrderedItemCard({
    super.key,
    required this.quantity,
    required this.name,
    required this.description,
    required this.price,
    required this.onDismissed,
    required this.onUpdate,
  });

  final int quantity;
  final String name, description;
  final double price;
  final VoidCallback onDismissed;
  final Function(int newQuantity) onUpdate;  

  @override
  // ignore: library_private_types_in_public_api
  _OrderedItemCardState createState() => _OrderedItemCardState();
}

class _OrderedItemCardState extends State<OrderedItemCard> {
  bool isChecked = false;
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),  
      direction: DismissDirection.endToStart,  
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        widget.onDismissed();
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NumOfItems(numOfItem: widget.quantity),
              const SizedBox(width: defaultPadding * 0.75),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: defaultPadding / 4),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              const SizedBox(width: defaultPadding / 2),
              Text(
                "USD${widget.price}",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: primaryColor),
              ),
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
              ),
            ],
          ),
          // const SizedBox(height: defaultPadding / 2),

          // Stepper pour changer la quantité, activé par la Checkbox
          if (isChecked)
            Column(
              children: [
                StepperWidget(
                  currentQuantity: selectedQuantity,
                  onQuantityChanged: (int value) {
                    setState(() {
                      selectedQuantity = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onUpdate(selectedQuantity);
                  },
                  child: const Text('Update'),
                ),
              ],
            ),

          const Divider(),
        ],
      ),
    );
  }
}

class NumOfItems extends StatelessWidget {
  const NumOfItems({
    super.key,
    required this.numOfItem,
  });

  final int numOfItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
            width: 0.5, color: const Color(0xFF868686).withOpacity(0.3)),
      ),
      child: Text(
        numOfItem.toString(),
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: primaryColor),
      ),
    );
  }
}

class StepperWidget extends StatelessWidget {
  const StepperWidget({
    super.key,
    required this.currentQuantity,
    required this.onQuantityChanged,
  });

  final int currentQuantity;
  final Function(int) onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quantity:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: currentQuantity > 1
              ? () => onQuantityChanged(currentQuantity - 1)
              : null, // Désactiver le bouton si la quantité est 1
        ),
        Text(
          currentQuantity.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onQuantityChanged(currentQuantity + 1),
        ),
      ],
    );
  }
}
