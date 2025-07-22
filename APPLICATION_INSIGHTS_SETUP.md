# Application Insights Setup for Spring Boot REST Service

This guide explains how to configure and use Azure Application Insights with your Spring Boot application.

## Prerequisites

1. Azure subscription
2. Application Insights resource in Azure
3. Java 17+
4. Maven 3.6+

## Configuration Steps

### 1. Create Application Insights Resource

Create an Application Insights resource in Azure Portal:

```bash
# Using Azure CLI
az extension add --name application-insights
az monitor app-insights component create \
  --app myapp \
  --location eastus \
  --resource-group myresourcegroup \
  --application-type web
```

### 2. Get Connection String

After creating the Application Insights resource, copy the connection string from:
- Azure Portal → Application Insights → Overview → Connection String

### 3. Configure Environment Variable

Set the connection string as an environment variable:

**Windows (PowerShell):**
```powershell
$env:APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=your-key;IngestionEndpoint=https://eastus-8.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/"
```

**Linux/Mac:**
```bash
export APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=your-key;IngestionEndpoint=https://eastus-8.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/"
```

### 4. Alternative Configuration

You can also set the connection string directly in `application.properties` (not recommended for production):

```properties
azure.application-insights.connection-string=InstrumentationKey=your-key;IngestionEndpoint=https://eastus-8.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/
```

## Running the Application

1. Build the application:
```bash
mvn clean compile
```

2. Run the application:
```bash
mvn spring-boot:run
```

3. Test the endpoint:
```bash
curl http://localhost:8080/greeting?name=Azure
```

## What Gets Monitored

The Application Insights integration will automatically capture:

### Automatic Telemetry
- **HTTP Requests**: All incoming web requests with response times, status codes
- **Dependencies**: Outbound HTTP calls, database calls
- **Exceptions**: Unhandled exceptions with stack traces
- **Performance Counters**: JVM metrics, memory usage, CPU usage
- **Custom Logs**: All SLF4J/Logback logs from your application

### Available Endpoints
- **Health Check**: `http://localhost:8080/actuator/health`
- **Metrics**: `http://localhost:8080/actuator/metrics`
- **Application Info**: `http://localhost:8080/actuator/info`

## Custom Telemetry (Optional)

You can add custom telemetry using the `TelemetryClient` bean:

```java
@Autowired
private TelemetryClient telemetryClient;

public void someBusinessMethod() {
    // Track custom events
    telemetryClient.trackEvent("CustomEvent");
    
    // Track custom metrics
    telemetryClient.trackMetric("CustomMetric", 42.0);
    
    // Track custom dependencies
    telemetryClient.trackDependency("HTTP", "external-api", "GET /users", "12:34:56", 
                                   Duration.ofMillis(150), true);
}
```

## Viewing Telemetry Data

1. Go to Azure Portal
2. Navigate to your Application Insights resource
3. Use the following features:
   - **Live Metrics**: Real-time monitoring
   - **Logs**: Query telemetry data using KQL
   - **Application Map**: View application topology
   - **Performance**: Analyze request performance
   - **Failures**: View failed requests and exceptions

## Troubleshooting

### Common Issues

1. **No telemetry data appearing**:
   - Verify the connection string is correct
   - Check environment variable is set
   - Look for Application Insights logs in console

2. **Connection errors**:
   - Ensure internet connectivity
   - Check firewall settings
   - Verify Azure endpoints are accessible

3. **Performance impact**:
   - Application Insights adds minimal overhead (~1-2ms per request)
   - Sampling is configured to 100% by default (can be reduced)

### Logs
Enable debug logging to troubleshoot:
```properties
logging.level.com.microsoft.applicationinsights=DEBUG
```

## Security Best Practices

1. **Never commit connection strings** to version control
2. **Use environment variables** or Azure Key Vault for production
3. **Enable Managed Identity** when running on Azure services
4. **Use least privilege access** for Application Insights resources
5. **Monitor costs** as telemetry data incurs charges

## Cost Optimization

- **Sampling**: Reduce sampling percentage in production if needed
- **Log filtering**: Configure log levels appropriately
- **Data retention**: Configure retention policies in Application Insights
- **Custom dimensions**: Limit cardinality of custom properties
