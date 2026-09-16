import 'package:clothes_control/core/di/service_locator.dart';
import 'package:clothes_control/domain/repositories/params/category/create_category_params.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';
import 'package:clothes_control/presentation/_shared/widgets/layout/custom_sliver_layout.dart';
import 'package:clothes_control/presentation/_shared/widgets/layout/custom_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/presentation/_shared/bloc/category/category_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesDetailScreen extends StatefulWidget {
  final int? id;

  const CategoriesDetailScreen({super.key, this.id});

  @override
  State<CategoriesDetailScreen> createState() => _CategoriesDetailScreenState();
}

class _CategoriesDetailScreenState extends State<CategoriesDetailScreen> {
  late TextEditingController _nameController;
  late CategoryBloc bloc;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bloc = CategoryBloc(categoryRepository: sl<ICategoryRepository>());
    if (widget.id != null) {
      bloc.add(LoadCategoryEvent(id: widget.id!));
    }
    _nameController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CreatedCategoryState || state is UpdatedCategoryState) {
            context.pop();
          }
          if (state is CategoryErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error?.toString() ?? 'Ошибка')),
            );
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: CustomSliverLayout(
              appBar: CustomSliverAppBar(
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                titleText: state.categoryName ?? 'Новая категория',
              ),
              body: SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    spacing: 30,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Заполните поле';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Наименование *',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            if (state.category == null) {
                              bloc.add(
                                AddNewCategoryEvent(
                                  newCategory: CreateCategoryParams(
                                    name: _nameController.text,
                                  ),
                                ),
                              );
                            } else {
                              bloc.add(
                                UpdateCategoryEvent(
                                  category: state.category!.copyWith(
                                    name: _nameController.text,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Сохранить'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
