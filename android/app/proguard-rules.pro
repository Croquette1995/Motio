# --- WorkManager & Room ---
-keep class * extends androidx.room.RoomDatabase
-dontwarn androidx.work.impl.**
-keep class androidx.work.impl.** { *; }

# --- Google ML Kit & Flutter Plugins ---
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**
-keep class com.google_mlkit_digital_ink_recognition.** { *; }
-dontwarn com.google_mlkit_digital_ink_recognition.**
-keep class com.google_mlkit_commons.** { *; }
-dontwarn com.google_mlkit_commons.**

# --- Google Play Services (GMS) ---
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Conserver les constructeurs par défaut des Registrars instanciés par réflexion
-keep public class * implements com.google.firebase.components.ComponentRegistrar {
    public <init>();
}
-keep public class * implements com.google.android.datatransport.runtime.backends.BackendFactory {
    public <init>();
}
