package com.mongodb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

import io.swagger.v3.oas.models.ExternalDocumentation;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;

@SpringBootApplication
public class MongoDb {

	public static void main(String[] args) {
		SpringApplication.run(MongoDb.class, args);
	}
	// Bean created to display the swaager information in swagger-ui
	@Bean
    public OpenAPI springShopOpenAPI() {
        return new OpenAPI()
                .info(new Info().title("Mongodb File upload API")
                .description("Spring-boot mongodb fileupload application")
                .version("v0.0.1")
                .license(new License().name("Tecnotree").url("http://springdoc.org")))
                .externalDocs(new ExternalDocumentation()
                .description("Http proxy connector Wiki Documentation")
                .url("https://git.tecnotree.com/3pp/digital-3pp-integration/http-proxy-connector/tree/develop"));
    }
}

