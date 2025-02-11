import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  final SharedPreferences _prefs;
  String _currentLanguage = 'es';

  LocalizationService(this._prefs) {
    _currentLanguage = _prefs.getString(_languageKey) ?? 'es';
  }

  String get currentLanguage => _currentLanguage;

  static final Map<String, Map<String, dynamic>> _localizedStrings = {
    'es': {
      'app_title': 'CrochetMate',
      'projects': 'Proyectos',
      'patterns': 'Patrones',
      'counters': 'Contadores',
      'settings': 'Ajustes',
      'search_patterns': 'Buscar patrones...',
      'new_pattern': 'Nuevo Patrón',
      'edit_pattern': 'Editar Patrón',
      'pattern_name': 'Nombre del patrón',
      'description': 'Descripción',
      'difficulty': 'Dificultad',
      'instructions': 'Instrucciones',
      'beginner': 'Principiante',
      'intermediate': 'Intermedio',
      'advanced': 'Avanzado',
      'expert': 'Experto',
      'no_patterns': 'No hay patrones guardados',
      'create_pattern': 'Crea o importa un patrón nuevo',
      'language_changed_es': 'Idioma cambiado a Español',
      'filter_by_difficulty': 'Filtrar por dificultad',
      'all': 'Todos',
      'language': 'Idioma',
      'select_language': 'Seleccionar idioma',
      'theme': 'Tema',
      'select_theme': 'Seleccionar tema',
      'system': 'Sistema',
      'light': 'Claro',
      'dark': 'Oscuro',
      'error_loading_patterns': 'Error al cargar los patrones',
      'error_exporting_pdf': 'Error al exportar el PDF',
      'search_projects': 'Buscar proyectos...',
      'new_project': 'Nuevo Proyecto',
      'edit_project': 'Editar Proyecto',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'delete': 'Eliminar',
      'export': 'Exportar',
      'import': 'Importar',
      'confirm': 'Confirmar',
      'yes': 'Sí',
      'no': 'No',
      'enter_pattern_name': 'Por favor ingresa un nombre',
      'pattern_name_label': 'Nombre del patrón',
      'description_label': 'Descripción',
      'instructions_label': 'Instrucciones',
      'difficulty_label': 'Dificultad',
      'save_pattern': 'Guardar patrón',
      'delete_pattern': 'Eliminar patrón',
      'confirm_delete': '¿Estás seguro de que deseas eliminar este patrón?',
      'pattern_saved': 'Patrón guardado exitosamente',
      'pattern_deleted': 'Patrón eliminado exitosamente',
      'error_saving': 'Error al guardar el patrón',
      'error_deleting': 'Error al eliminar el patrón',
      'spanish': 'Español',
      'english': 'English',
      'no_projects': 'No hay proyectos guardados',
      'no_counters': 'No hay contadores guardados',
      'create_counter': 'Crear contador',
      'edit_counter': 'Editar contador',
      'counter_name': 'Nombre del contador',
      'current_count': 'Conteo actual',
      'app_subtitle': 'Tu compañero de crochet',
      'manage_projects': 'Gestiona tus Proyectos',
      'explore_patterns': 'Explora Patrones',
      'count_rounds': 'Cuenta Vueltas',
      'customize_app': 'Personaliza la App',
      'language_es': 'Español',
      'language_en': 'English',
      'project_name': 'Nombre del proyecto',
      'enter_project_name': 'Por favor ingresa un nombre',
      'add_round': 'Añadir ronda',
      'hook_size': 'Tamaño del gancho',
      'yarn_type': 'Tipo de hilo',
      'status': 'Estado',
      'deadline': 'Fecha límite',
      'rounds': 'Rondas',
      'add_image': 'Añadir imagen',
      'in_progress': 'En progreso',
      'completed': 'Completado',
      'abandoned': 'Abandonado',
      'new_counter': 'Nuevo Contador',
      'enter_counter_name': 'Por favor ingresa un nombre para el contador',
      'reset': 'Reiniciar',
      'increment': 'Incrementar',
      'decrement': 'Decrementar',
      'delete_counter': 'Eliminar contador',
      'confirm_delete_counter':
          '¿Estás seguro de que deseas eliminar este contador?',
      'counter_saved': 'Contador guardado exitosamente',
      'counter_deleted': 'Contador eliminado exitosamente',
      'error_saving_counter': 'Error al guardar el contador',
      'error_deleting_counter': 'Error al eliminar el contador',
      'tutorial_welcome_title': '¡Bienvenido a CrochetMate!',
      'tutorial_welcome_desc':
          'Tu compañero perfecto para tus proyectos de crochet. Vamos a explorar las principales funciones.',
      'tutorial_projects_title': 'Proyectos',
      'tutorial_projects_desc':
          'Aquí podrás gestionar todos tus proyectos de crochet, con fotos, notas y seguimiento de progreso.',
      'tutorial_patterns_title': 'Patrones',
      'tutorial_patterns_desc':
          'Explora y guarda tus patrones favoritos. Puedes crear los tuyos propios o importar otros.',
      'tutorial_counters_title': 'Contadores',
      'tutorial_counters_desc':
          'Lleva el control de tus vueltas con contadores personalizables para cada proyecto.',
      'show_tutorial': 'Ver tutorial',
      'show_tutorial_desc': 'Vuelve a ver el tutorial de introducción',
      'previous': 'Anterior',
      'next': 'Siguiente',
      'finish': 'Finalizar',
      'preview': 'Vista Previa',
      'round': 'Ronda',
      'no_instructions': 'Sin instrucciones',
      'new_counter_dialog_title': 'Nuevo Contador',
      'counter_name_hint': 'Ej: Proyecto Amigurumi',
      'create': 'Crear',
      'deadline_title': 'Fecha límite',
      'no_deadline': 'Sin fecha límite',
      'round_undone': 'Vuelta deshecha',
      'undo': 'Deshacer',
      'project_details': 'Detalles del Proyecto',
      'tutorial_settings_title': 'Configuración',
      'tutorial_settings_desc':
          'Personaliza la aplicación según tus preferencias. Ajusta el tema, el idioma y otras opciones importantes.',
      'customize_settings': 'Personaliza la app',
      'language_changed_en': 'Language changed to English',
      'delete_project_confirmation':
          '¿Estás seguro de que deseas eliminar este proyecto?',
      'project_deleted': 'Proyecto eliminado exitosamente',
      'error_deleting_project': 'Error al eliminar el proyecto',
      'project_saved': 'Proyecto guardado exitosamente',
      'error_saving_project': 'Error al guardar el proyecto',
      'select_image': 'Seleccionar imagen',
      'camera': 'Cámara',
      'gallery': 'Galería',
      'remove_image': 'Eliminar imagen',
      'hook_size_hint': 'Ej: 3.5mm',
      'yarn_type_hint': 'Ej: Algodón 4 hebras',
      'description_hint': 'Describe tu proyecto...',
      'notes_hint': 'Agrega notas adicionales...',
      'project_name_hint': 'Ej: Amigurumi Conejo',
      'required_field': 'Este campo es requerido',
      'invalid_hook_size': 'Ingresa un tamaño de gancho válido',
      'pattern_link': 'Enlace al patrón',
      'pattern_link_hint': 'https://ejemplo.com/patron',
      'difficulty_easy': 'Fácil',
      'difficulty_medium': 'Medio',
      'difficulty_hard': 'Difícil',
      'error_loading_projects': 'Error al cargar los proyectos',
      'error_loading_counters': 'Error al cargar los contadores',
      'select_pattern': 'Seleccionar patrón',
      'no_pattern_selected': 'Sin patrón seleccionado',
      'pattern_details': 'Detalles del patrón',
      'share': 'Compartir',
      'share_project': 'Compartir proyecto',
      'share_pattern': 'Compartir patrón',
      'share_counter': 'Compartir contador',
      'no_description': 'Sin descripción',
      'create_new_counter': 'Crear nuevo contador',
      'create_new_pattern': 'Crear nuevo patrón',
      'create_new_project': 'Crea un nuevo proyecto',
      'empty_state_message': 'Comienza creando uno nuevo',
      'empty_state_counters': 'No tienes contadores guardados',
      'empty_state_patterns': 'No tienes patrones guardados',
      'empty_state_projects': 'No tienes proyectos guardados',
      'no_counters_title': 'No hay contadores guardados',
      'no_patterns_title': 'No hay patrones guardados',
      'no_projects_title': 'No hay proyectos guardados',
      'create_counters': 'Crea un nuevo contador',
      'create_patterns': 'Crea un nuevo patrón',
      'create_projects': 'Crea un nuevo proyecto',
      'loading_quotes': [
        'El crochet es como la vida: un punto a la vez',
        'Cada puntada es un paso hacia tu meta',
        'La creatividad fluye a través de tus manos',
        'Tejer es meditar con hilo y gancho',
        'La paciencia es la clave del crochet perfecto',
        'Crea con amor, teje con pasión',
        'En cada proyecto hay una historia única',
        'El crochet es el arte de la perseverancia',
      ],
      'export_pdf': 'Exportar a PDF',
      'pdf_saved': 'PDF guardado exitosamente',
      'open': 'Abrir',
      'statistics': 'Estadísticas',
      'total_projects': 'Total de proyectos',
      'completed_projects': 'Proyectos completados',
      'in_progress_projects': 'Proyectos en progreso',
      'average_completion_time': 'Tiempo promedio de finalización',
      'monthly_progress': 'Progreso mensual',
      'projects_by_status': 'Proyectos por estado',
      'days': 'días',
    },
    'en': {
      'app_title': 'CrochetMate',
      'projects': 'Projects',
      'patterns': 'Patterns',
      'counters': 'Counters',
      'settings': 'Settings',
      'search_patterns': 'Search patterns...',
      'new_pattern': 'New Pattern',
      'edit_pattern': 'Edit Pattern',
      'pattern_name': 'Pattern name',
      'description': 'Description',
      'difficulty': 'Difficulty',
      'instructions': 'Instructions',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',
      'expert': 'Expert',
      'no_patterns': 'No saved patterns',
      'create_pattern': 'Create or import a new pattern',
      'language_changed_en': 'Language changed to English',
      'filter_by_difficulty': 'Filter by difficulty',
      'all': 'All',
      'language': 'Language',
      'select_language': 'Select language',
      'theme': 'Theme',
      'select_theme': 'Select theme',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'error_loading_patterns': 'Error loading patterns',
      'error_exporting_pdf': 'Error exporting PDF',
      'search_projects': 'Search projects...',
      'new_project': 'New Project',
      'edit_project': 'Edit Project',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'export': 'Export',
      'import': 'Import',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'enter_pattern_name': 'Please enter a name',
      'pattern_name_label': 'Pattern name',
      'description_label': 'Description',
      'instructions_label': 'Instructions',
      'difficulty_label': 'Difficulty',
      'save_pattern': 'Save pattern',
      'delete_pattern': 'Delete pattern',
      'confirm_delete': 'Are you sure you want to delete this pattern?',
      'pattern_saved': 'Pattern saved successfully',
      'pattern_deleted': 'Pattern deleted successfully',
      'error_saving': 'Error saving pattern',
      'error_deleting': 'Error deleting pattern',
      'spanish': 'Spanish',
      'english': 'English',
      'no_projects': 'No saved projects',
      'no_counters': 'No saved counters',
      'create_counter': 'Create counter',
      'edit_counter': 'Edit counter',
      'counter_name': 'Counter name',
      'current_count': 'Current count',
      'app_subtitle': 'Your crochet companion',
      'manage_projects': 'Manage your Projects',
      'explore_patterns': 'Explore Patterns',
      'count_rounds': 'Count Rounds',
      'customize_app': 'Customize App',
      'language_es': 'Spanish',
      'language_en': 'English',
      'project_name': 'Project name',
      'enter_project_name': 'Please enter a name',
      'add_round': 'Add round',
      'hook_size': 'Hook Size',
      'yarn_type': 'Yarn Type',
      'status': 'Status',
      'deadline': 'Deadline',
      'rounds': 'Rounds',
      'add_image': 'Add image',
      'in_progress': 'In progress',
      'completed': 'Completed',
      'abandoned': 'Abandoned',
      'new_counter': 'New Counter',
      'enter_counter_name': 'Please enter a counter name',
      'reset': 'Reset',
      'increment': 'Increment',
      'decrement': 'Decrement',
      'delete_counter': 'Delete counter',
      'confirm_delete_counter': 'Are you sure you want to delete this counter?',
      'counter_saved': 'Counter saved successfully',
      'counter_deleted': 'Counter deleted successfully',
      'error_saving_counter': 'Error saving counter',
      'error_deleting_counter': 'Error deleting counter',
      'tutorial_welcome_title': 'Welcome to CrochetMate!',
      'tutorial_welcome_desc':
          'Your perfect companion for your crochet projects. Let\'s explore the main features.',
      'tutorial_projects_title': 'Projects',
      'tutorial_projects_desc':
          'Here you can manage all your crochet projects, with photos, notes and progress tracking.',
      'tutorial_patterns_title': 'Patterns',
      'tutorial_patterns_desc':
          'Explore and save your favorite patterns. You can create your own or import others.',
      'tutorial_counters_title': 'Counters',
      'tutorial_counters_desc':
          'Keep track of your rounds with customizable counters for each project.',
      'show_tutorial': 'Show tutorial',
      'show_tutorial_desc': 'See the introduction tutorial again',
      'previous': 'Previous',
      'next': 'Next',
      'finish': 'Finish',
      'preview': 'Preview',
      'round': 'Round',
      'no_instructions': 'No instructions',
      'new_counter_dialog_title': 'New Counter',
      'counter_name_hint': 'Ex: Amigurumi Project',
      'create': 'Create',
      'deadline_title': 'Deadline',
      'no_deadline': 'No deadline',
      'round_undone': 'Round undone',
      'undo': 'Undo',
      'project_details': 'Project Details',
      'tutorial_settings_title': 'Settings',
      'tutorial_settings_desc':
          'Customize the application to your preferences. Adjust the theme, language, and other important options.',
      'customize_settings': 'Customize app',
      'language_changed_es': 'Idioma cambiado a Español',
      'delete_project_confirmation':
          'Are you sure you want to delete this project?',
      'project_deleted': 'Project successfully deleted',
      'error_deleting_project': 'Error deleting project',
      'project_saved': 'Project saved successfully',
      'error_saving_project': 'Error saving project',
      'select_image': 'Select image',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'remove_image': 'Remove image',
      'hook_size_hint': 'Ex: 3.5mm',
      'yarn_type_hint': 'Ex: Cotton 4 ply',
      'description_hint': 'Describe your project...',
      'notes_hint': 'Add additional notes...',
      'project_name_hint': 'Ex: Bunny Amigurumi',
      'required_field': 'This field is required',
      'invalid_hook_size': 'Enter a valid hook size',
      'pattern_link': 'Pattern link',
      'pattern_link_hint': 'https://example.com/pattern',
      'difficulty_easy': 'Easy',
      'difficulty_medium': 'Medium',
      'difficulty_hard': 'Hard',
      'error_loading_projects': 'Error loading projects',
      'error_loading_counters': 'Error loading counters',
      'select_pattern': 'Select pattern',
      'no_pattern_selected': 'No pattern selected',
      'pattern_details': 'Pattern details',
      'share': 'Share',
      'share_project': 'Share project',
      'share_pattern': 'Share pattern',
      'share_counter': 'Share counter',
      'no_description': 'No description',
      'create_new_counter': 'Create new counter',
      'create_new_pattern': 'Create new pattern',
      'create_new_project': 'Create a new project',
      'empty_state_message': 'Start by creating a new one',
      'empty_state_counters': 'You have no saved counters',
      'empty_state_patterns': 'You have no saved patterns',
      'empty_state_projects': 'You have no saved projects',
      'no_counters_title': 'No saved counters',
      'no_patterns_title': 'No saved patterns',
      'no_projects_title': 'No saved projects',
      'create_counters': 'Create a new counter',
      'create_patterns': 'Create a new pattern',
      'create_projects': 'Create a new project',
      'loading_quotes': [
        'Crochet is like life: one stitch at a time',
        'Every stitch is a step towards your goal',
        'Creativity flows through your hands',
        'Crocheting is meditating with yarn and hook',
        'Patience is the key to perfect crochet',
        'Create with love, crochet with passion',
        'Every project tells a unique story',
        'Crochet is the art of perseverance',
      ],
      'export_pdf': 'Export to PDF',
      'pdf_saved': 'PDF saved successfully',
      'open': 'Open',
    },
  };

  Future<void> setLanguage(String languageCode) async {
    if (_currentLanguage != languageCode) {
      await _prefs.setString(_languageKey, languageCode);
      _currentLanguage = languageCode;
      notifyListeners();
    }
  }

  dynamic translate(String key) {
    try {
      return _localizedStrings[_currentLanguage]![key];
    } catch (e) {
      return key;
    }
  }

  Map<String, String> getAllTranslationsForLanguage(String languageCode) {
    final Map<String, dynamic> translations =
        _localizedStrings[languageCode] ?? {};
    return Map<String, String>.fromEntries(
      translations.entries
          .where((e) => e.value is String)
          .map((e) => MapEntry(e.key, e.value as String)),
    );
  }

  Future<String> getLanguage() async {
    return _prefs.getString(_languageKey) ?? 'es';
  }
}
