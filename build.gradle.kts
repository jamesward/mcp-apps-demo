plugins {
    java
    id("org.springframework.boot") version "4.1.0"
    id("io.spring.dependency-management") version "1.1.7"
    id("gg.jte.gradle") version("3.2.4")
}

jte {
    generate()
    binaryStaticContent = true
    jteExtension("gg.jte.models.generator.ModelExtension")
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}

dependencies {
    implementation(platform("org.springframework.ai:spring-ai-bom:2.0.0-M6"))
    implementation("org.springframework.ai:spring-ai-starter-mcp-server-webflux")
    implementation("gg.jte:jte-runtime:3.2.4")
    jteGenerate("gg.jte:jte-models:3.2.4")

    implementation("org.webjars:webjars-locator-lite:1.1.3")
    runtimeOnly("org.webjars.npm:modelcontextprotocol__ext-apps:1.5.0")
}
