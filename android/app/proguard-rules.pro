# --- WorkManager & Room ---
-keep class * extends androidx.room.RoomDatabase
-dontwarn androidx.work.impl.**
-keep class androidx.work.impl.** { *; }

# --- Google ML Kit ---
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Conserver les constructeurs par défaut des Registrars instanciés par réflexion
-keep public class * implements com.google.firebase.components.ComponentRegistrar {
    public <init>();
}
-keep public class * implements com.google.android.datatransport.runtime.backends.BackendFactory {
    public <init>();
}
