import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/data/dto/category/new_category_dto.dart';
import 'package:clothes_control/data/dto/category/category_dto.dart';
import 'package:clothes_control/shared/widgets/navigation/navigation_bar.dart';
import 'package:clothes_control/core/utils/navigation/navigation.dart';
import 'package:clothes_control/data/bloc/category/category_bloc.dart';
import 'package:clothes_control/data/local/database_helper.dart';
import 'package:clothes_control/data/repositories/category_repository.dart';

class CategoriesDetailScreen extends StatelessWidget {
  final CategoryDTO? category;

  const CategoriesDetailScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CategoryBloc(
          categoryRepository: CategoryRepositoryImpl(
            databaseHelper: DatabaseHelper(),
          ),
        );
        if (category != null) {
          bloc.add(LoadCategoryEvent(category: category!));
        }
        return bloc;
      },
      child: CategoriesDetailView(category: category),
    );
  }
}

class CategoriesDetailView extends StatelessWidget {
  final CategoryDTO? category;

  const CategoriesDetailView({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CreatedCategoryState || state is UpdatedCategoryState) {
          return AppNavigation.pop(context);
        }
      },
      builder: (context, state) {
        final formKey = GlobalKey<FormState>();
        final nameController = TextEditingController(
          text: state.categoryName,
        );
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => AppNavigation.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              title: Text(
                state.categoryName == null ? 'Новая категория' : state.categoryName!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
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
                      if (formKey.currentState!.validate()) {
                        if (state.category == null) {
                          context.read<CategoryBloc>().add(
                                AddNewCategoryEvent(
                                  newCategory: NewCategoryDTO(
                                    name: nameController.text,
                                  ),
                                ),
                              );
                        } else {
                          context.read<CategoryBloc>().add(
                                UpdateCategoryEvent(
                                  category: category!.copyWith(
                                    name: nameController.text,
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
            bottomNavigationBar: AppNavigationBar(currentIndex: 1),
          ),
        );
      },
    );
  }
}
