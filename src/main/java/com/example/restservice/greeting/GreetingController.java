package com.example.restservice.greeting;

import java.util.concurrent.atomic.AtomicLong;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.microsoft.applicationinsights.TelemetryClient;

@RestController
public class GreetingController {

	private static final Logger logger = LoggerFactory.getLogger(GreetingController.class);
	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();
	
	@Autowired(required = false)
	private TelemetryClient telemetryClient;

	@GetMapping("/greeting")
	public Greeting greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
		long id = counter.incrementAndGet();
		logger.info("Processing greeting request #{} for name: {}", id, name);
		
		// Track custom event with Application Insights (if configured)
		if (telemetryClient != null) {
			telemetryClient.trackEvent("GreetingRequested");
			telemetryClient.trackMetric("GreetingCounter", id);
		}
		
		// Custom telemetry will be automatically captured by Application Insights
		Greeting response = new Greeting(id, String.format(template, name));
		
		logger.debug("Generated greeting response: {}", response);
		return response;
	}
}
