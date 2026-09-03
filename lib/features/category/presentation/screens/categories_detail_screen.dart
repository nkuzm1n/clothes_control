import 'package:clothes_control/core/di/service_locator.dart';
import 'package:clothes_control/domain/repositories/params/category/create_category_params.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/_shared/bloc/category/category_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesDetailScreen extends StatelessWidget {
  final int? id;

  const CategoriesDetailScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CategoryBloc(categoryRepository: sl<ICategoryRepository>());
        if (id != null) {
          bloc.add(LoadCategoryEvent(id: id!));
        }
        return bloc;
      },
      child: CategoriesDetailView(id: id),
    );
  }
}

class CategoriesDetailView extends StatelessWidget {
  final int? id;

  const CategoriesDetailView({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CreatedCategoryState || state is UpdatedCategoryState) {
          context.pop();
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBar(
                  leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: Text(
                    state.categoryName == null ? 'Новая категория' : state.categoryName!,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
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
                                newCategory: CreateCategoryParams(
                                  name: nameController.text,
                                ),
                              ),
                            );
                      } else {
                        context.read<CategoryBloc>().add(
                              UpdateCategoryEvent(
                                category: state.category!.copyWith(
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
        );
      },
    );
  }
}
