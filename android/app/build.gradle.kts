import java.util.Properties
import java.io.FileInputStream // Import may not be strictly needed if using extension funcs

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}


android {
    namespace = "com.mastertechsoftware.ring_assignments"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.mastertechsoftware.ring_assignments"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                    ?: throw GradleException("keyAlias not found in key.properties")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                    ?: throw GradleException("keyPassword not found in key.properties")
                storePassword = keystoreProperties.getProperty("storePassword")
                    ?: throw GradleException("storePassword not found in key.properties")
                storeFile = keystoreProperties.getProperty("storeFile")?.let { path ->
                    // Assuming the path in key.properties is relative to the *root* project
                    rootProject.file(path)
                    // If the path is relative to the *app module*, use:
                    // project.file(path) // or just file(path)
                } ?: throw GradleException("storeFile not found in key.properties")

                // Check if the resolved storeFile actually exists
                if (storeFile?.exists() == false) {
                    throw GradleException("Keystore file specified in key.properties not found at: ${storeFile?.absolutePath}")
                }
            } else {
                println("Keystore file not found")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true // Enable code shrinking and obfuscation
            isShrinkResources = false // Disable resource shrinking
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
