# Isar rules
-keep class io.isar.** { *; }
-keep class dev.isar.** { *; }
-dontwarn io.isar.**
-dontwarn dev.isar.**
-keep class * extends io.isar.IsarLink { *; }
-keep class * extends io.isar.IsarLinks { *; }

# Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.editing.** { *; }
-keep class io.flutter.plugin.platform.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.runtime.broadcast.** { *; }
-keep class io.flutter.util.** { *; }
-keep class com.pravera.flutter_foreground_task.** { *; }

# Play Store deferred components (added to fix R8 missing classes)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
