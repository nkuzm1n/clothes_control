import 'package:clothes_control/shared/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/status/status_dto.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:clothes_control/shared/domain/services/cloth_service.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/image/ui_image.dart';
import 'package:clothes_control/shared/utils/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';

class ClothesListItem extends StatelessWidget {
  final ClothDTO cloth;
  final StatusDTO? status;
  final Function()? onDelete;
  final void Function()? onTap;

  const ClothesListItem({
    super.key,
    required this.cloth,
    this.status,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    print("IMAGE $cloth )");
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
                        image: ImageHelper.fileImageOrNull(cloth.imageUrl),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cloth.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (status != null)
                          Row(
                            children: [
                              const Text("Статус: "),
                              Text(
                                status!.name,
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
                        right: 0,
                        top: 0,
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
