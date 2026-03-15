allprojects {
    repositories {
        google()
        maven { url = uri("https://storage.flutter-io.cn/download.flutter.io") }
        maven {url = uri("https://maven.aliyun.com/repository/google/")}
        maven {url = uri("https://maven.aliyun.com/repository/releases/")}
        maven {url = uri("https://maven.aliyun.com/repository/central/")}
        maven {url = uri("https://maven.aliyun.com/repository/public/")}
        maven {url = uri("https://maven.aliyun.com/repository/gradle-plugin/")}
        maven {url = uri("https://maven.aliyun.com/repository/apache-snapshots/")}
        maven {url = uri("https://maven.aliyun.com/nexus/content/groups/public/")}
        maven {url = uri("https://jitpack.io/")}
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.library")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.LibraryExtension
            if (android.namespace == null) {
                android.namespace = project.group.toString().ifBlank { "dev.isar.isar_flutter_libs" }
            }
            android.compileSdk = 36
            android.defaultConfig.minSdk = 24
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
