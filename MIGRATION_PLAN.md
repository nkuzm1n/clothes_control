# План миграции на Feature-First структуру

## 1. Анализ текущего состояния

**Текущая структура (Clean Architecture, но flat):** `lib/{core,data,domain,presentation,app}`.

**Найденные домены-фичи:**

- **clothes** — список/детали одежды (screens, blocs, widgets, DTO, mapper, model)
- **category** — категории (screens, bloc)
- **status** — статусы (screens, bloc)
- **settings** — настройки (thin screen)

**Ключевое наблюдение о связях (зависимости):**

```
clothes  ──►  category entity + ICategoryRepository   ← cross-feature!
clothes  ──►  status entity +    IStatusRepository     ← cross-feature!
category ──►  create_category_params (only used in category feature)
status   ──►  create_status_params  (only used in status feature)
```

Все три фичи используют **общие** репозитории категорий и статусов (для выпадающих списков), но у каждой свой домен одежды. Категории/статусы — это **reference-данные**, используемые несколькими фичами одновременно → их нужно вынести в `shared/`.

## 2. Проектирование новой структуры

```
lib/
├── main.dart
├── app/
│   ├── di/di_config.dart              # регистрация всех репозитиев (core DI)
│   ├── router/router.dart             # роуты, ссылаются на features/* и shared
│   └── theme/.gitkeep
├── core/                              # фичам НЕ принадлежит — глобальные утилиты
│   ├── di/service_locator.dart        # sl
│   ├── utils/{image_helper, image_picker_helper, hex_color}  # cross-cutting util
│   └── router/route_names.dart + extensions/app_router_navigation.dart
├── shared/                            ← НОВАЯ папка (общий домен для фич)
│   ├── domain/
│   │   ├── entities/{category,status}.dart (+.freezed, .g)      # reference-данные
│   │   └── repositories/{category_repository,status_repository}.dart  # shared ports
│   └── presentation/
│       ├── bloc/category/ (bloc,event,state)                     # шаренный CategoryBloc
│       ├── bloc/status/ (bloc,event,state)                     # шаренный StatusBloc
│       └── widgets/{ui/*, layout/*}                              # все UI-компоненты
├── features/                          ← НОВАЯ папка (фичи по домену)
│   ├── clothes/
│   │   ├── domain/entities/cloth.dart (+freezed)
│   │   ├── domain/repositories/{clothes_repository, params/cloth/create_cloth_params}.dart
│   │   ├── data/mappers/cloth_mapper.dart
│   │   ├── data/database/models/cloth_model.dart (+freezed,.g)
│   │   └── presentation/{screens,bloc,cloth_list_item, detail_form,dto}
│   ├── category/
│   │   ├── data/database/models/category_model.dart (+freezed,.g)
│   │   ├── data/mappers/category_mapper.dart
│   │   └── presentation/screens/categories_*.dart
│   └── status/
│       ├── data/database/models/status_model.dart (+freezed,.g)
│       ├── data/mappers/status_mapper.dart
│       └── presentation/screens/statuses_*.dart
```

## 3. Правила разделения (по вашим требованиям)

- **Фичи не импортируют друг друга** ✓ (`lib/features/*` ↔ `lib/features/*` — запрещено).
- **Всё, что используется в >1 фиче → `lib/shared/`.** Это:
  - entities `Category`, `Status` (используются clothes + своими screens);
  - интерфейсы репозиториев `ICategoryRepository`, `IStatusRepository`;
  - BLOC'ы `CategoryBloc`, `StatusBloc` (были в `/lib/presentation/_shared` — остаются шаренными);
  - все UI-виджеты (`ui/*`, `layout/*`), `hex_color`.
- **Фичи импортируют только `lib/shared/` и `lib/core/`** ✓.
- **Что остаётся внутри фичи (не делится):** `Cloth` entity, `IClothesRepository`, `CreateClothParams`, `ClothesMapper`, `ClothModel`, UI именно одежды (`ClothesListScreen`, `ClothesDetailForm`, `ClothesListItem`).

## 4. Решение проблемы циклической зависимости clothes ↔ category/status

Фича **clothes** не должна импортировать `lib/features/category` / `lib/features/status`. Это решается тем, что сущности и интерфейсы репозитория выносятся в `lib/shared/domain`:

- clothes-фича получает категории/статусы из `lib/shared/domain/repositories/{category,status}_repository.dart`;
- `CategoryBloc`/`StatusBloc` живут в `lib/shared/presentation/bloc`, а не в своих фичах.

Так clothes остаётся «тяжёлой» фичей, оперирующей своим доменом одежды, но читающей reference-данные из shared без прямого импорта чужих фич.

## 5. Порядок действий (по шагам)

**Этап 0 — подготовка**

1. Убедиться, что `fvm flutter pub get` отработан; проект собирается (`fvm flutter analyze`).

**Этап 1 — ядро и shared (безопасно)** 2. Создать `lib/shared/`, переместить туда `lib/presentation/_shared/widgets/{ui,layout}` → `lib/shared/presentation/widgets`. 3. Переместить `lib/presentation/_shared/bloc/category` и `lib/presentation/_shared/bloc/status` → `lib/shared/presentation/bloc/{category,status}`. 4. `lib/core/utils/{image_helper, image_picker_helper, hex_color}` — остаются в `lib/core/` (глобальные). 5. `lib/core/router/*` — остаются в `lib/core/`.

**Этап 2 — shared домен** 6. Создать `lib/shared/domain/entities/`, переместить `category.dart`+`status.dart` (+freezed/.g). 7. Создать `lib/shared/domain/repositories/`, переместить интерфейсы `category_repository.dart`+`status_repository.dart`.

**Этап 3 — фичи** 8. Создать `lib/features/clothes/`: переместить cloth entity, clothes repository + params, mapper, model, всё presentation (bloc/widgets/dto/screens). 9. Создать `lib/features/category/`: model + mapper + screens. 10. Создать `lib/features/status/`: model + mapper + screens.

**Этап 4 — обновление DI и роутов** 11. Обновить imports в `lib/app/di/di_config.dart` (регистрация всех реполитриев по новым путям). 12. Обновить imports в `lib/app/router/router.dart`. 13. Проверить, что `route_names.dart`/`app_router_navigation.dart` — в `lib/core/router`, а роуты импортируют screens из `lib/features/*`.

**Этап 5 — финализация** 14. Удалить старые пустые директории `lib/data/`, `lib/domain/`, старое `lib/presentation/`. 15. `fvm dart run build_runner build -d` (перегенерировать freezed/gif для новых путей). 16. `fvm flutter analyze .` → `fvm flutter test .`.

## 6. Что НЕ менять

- Папки вне `lib/` — нетронуты.
- Содержимое файлов (логика) не меняется — только перемещение и обновление import-путей.
