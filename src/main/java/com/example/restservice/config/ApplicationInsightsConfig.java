package com.example.restservice.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Bean;
import com.microsoft.applicationinsights.TelemetryClient;
import com.microsoft.applicationinsights.TelemetryConfiguration;

/**
 * Configuration class for Application Insights integration.
 * This class sets up the telemetry client and configuration for Azure Application Insights.
 */
@Configuration
public class ApplicationInsightsConfig {

    /**
     * Creates a TelemetryClient bean for custom telemetry tracking.
     * The TelemetryClient will automatically use the connection string from:
     * 1. APPLICATIONINSIGHTS_CONNECTION_STRING environment variable
     * 2. applicationinsights.json configuration file
     * 
     * @return TelemetryClient instance for custom telemetry
     */
    @Bean
    public TelemetryClient telemetryClient() {
        return new TelemetryClient(TelemetryConfiguration.getActive());
    }
}
