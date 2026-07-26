import 'package:clothes_control/data/dto/category/category_dto.dart';
import 'package:clothes_control/data/dto/category/new_category_dto.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  late final ICategoryRepository _categoryRepository;

  CategoryBloc({required ICategoryRepository categoryRepository}) : super(const CategoryState()) {
    _categoryRepository = categoryRepository;

    on<LoadCategoryListEvent>((event, emit) async {
      emit(LoadingCategoryListState(list: state.list));
      try {
        final list = await _categoryRepository.getCategories();
        emit(LoadedCategoryListState(list: list));
      } catch (e) {
        emit(CategoryErrorState(error: e));
      }
    });

    on<DeleteCategoryFromListEvent>((event, emit) async {
      emit(LoadingCategoryListState(list: state.list));
      try {
        await _categoryRepository.deleteCategory(event.category);
        add(LoadCategoryListEvent());
      } catch (e) {
        emit(CategoryErrorState(error: e));
      }
    });

    on<LoadCategoryEvent>((event, emit) async {
      emit(LoadingCategoryState(category: event.category));
      try {
        final category = await _categoryRepository.getCategoryById(event.category.id);
        emit(LoadedCategoryState(category: category));
      } catch (e) {
        emit(CategoryErrorState(error: e));
      }
    });

    on<UpdateCategoryEvent>((event, emit) async {
      emit(LoadingCategoryState(category: event.category));
      try {
        await _categoryRepository.updateCategory(event.category);
        emit(UpdatedCategoryState(category: event.category));
      } catch (e) {
        emit(CategoryErrorState(error: e));
      }
    });

    on<AddNewCategoryEvent>((event, emit) async {
      emit(LoadingCategoryState(newCategory: event.newCategory));
      try {
        final category = await _categoryRepository.addCategory(event.newCategory);
        emit(CreatedCategoryState(category: category));
      } catch (e) {
        emit(CategoryErrorState(error: e));
      }
    });
  }
}
