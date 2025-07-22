package com.example.restservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.microsoft.applicationinsights.attach.ApplicationInsights;

@SpringBootApplication
public class Application {

    public static void main(String[] args) {

        // Attach Application Insights to the application
        ApplicationInsights.attach();

        SpringApplication.run(Application.class, args);
    }

}
