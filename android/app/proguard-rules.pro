# Flutter Proguard Rules for Maximum App Size Reduction
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Sign In & Play Services
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.** { *; }

# Shared Preferences & AndroidX
-keep class androidx.preference.** { *; }
-keep class androidx.core.** { *; }

# Suppress harmless warnings
-dontwarn io.flutter.**
-dontwarn com.google.**
-dontwarn androidx.**

