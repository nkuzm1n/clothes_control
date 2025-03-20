import 'package:clothes_control/shared/presentation/widgets/ui/image/ui_image.dart';
import 'package:clothes_control/shared/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';

class ClothesListItem extends StatelessWidget {
  const ClothesListItem({
    super.key,
    required this.clothesItem,
    this.onDelete,
    this.onTap,
  });

  final Cloth clothesItem;
  final Function()? onDelete;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          // TODO:
          // color: Colors.white,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: UiImage(
                        image: ImageHelper.networkImageOrNull(clothesItem.imageUrl),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clothesItem.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (clothesItem.status != null)
                          Row(
                            children: [
                              const Text("Статус: "),
                              Text(
                                clothesItem.status!.name,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        if (clothesItem.condition != null)
                          Row(
                            children: [
                              const Text("Состояние: "),
                              Text(
                                clothesItem.condition!.name,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // TODO: do something with padding and accessibility
                  InkWell(
                    onTap: onDelete,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 2,
                        top: 4,
                        bottom: 4,
                      ),
                      child: Icon(Icons.delete),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
