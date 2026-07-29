import 'package:clothes_control/data/dto/category/category_dto.dart';
import 'package:clothes_control/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/data/dto/status/status_dto.dart';
import 'package:clothes_control/features/_shared/widgets/ui/image/ui_image.dart';
import 'package:clothes_control/core/utils/extensions/hex_color.dart';
import 'package:clothes_control/core/utils/helpers/image_helper.dart';
import 'package:flutter/material.dart';

class ClothesListItem extends StatelessWidget {
  final ClothDTO cloth;
  final StatusDTO? status;
  final CategoryDTO? category;
  final Function()? onDelete;
  final void Function()? onTap;

  const ClothesListItem({
    super.key,
    required this.cloth,
    this.status,
    this.category,
    this.onDelete,
    this.onTap,
  });

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
              padding: const EdgeInsets.all(0),
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
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // const Expanded(child: Text('qweqwe')),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (category != null)
                                Row(
                                  children: [
                                    // const Text("Категория: "),
                                    Expanded(
                                      child: Text(
                                        category!.name,
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              // if (category != null && status != null) const SizedBox(height: 8),
                              if (status != null)
                                Chip(
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        status!.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: HexColor.fromHex(status!.color),
                                        ),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(0),
                                  side: BorderSide(color: HexColor.fromHex(status!.color)),
                                ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Text(
                              //         status!.name,
                              //         style: const TextStyle(fontWeight: FontWeight.w500),
                              //         softWrap: false,
                              //         maxLines: 1,
                              //         overflow: TextOverflow.ellipsis,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // TODO: do something with padding and accessibility
                  InkWell(
                    onTap: onDelete,
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 8,
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
