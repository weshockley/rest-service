# Application Insights Setup Script for Windows
# This script helps you configure and run the Spring Boot application with Application Insights

param(
    [Parameter(Mandatory=$false)]
    [string]$ConnectionString = "",
    [Parameter(Mandatory=$false)]
    [switch]$Help
)

if ($Help) {
    Write-Host "Application Insights Setup Script" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\setup-appinsights.ps1 -ConnectionString '<your-connection-string>'"
    Write-Host ""
    Write-Host "Parameters:" -ForegroundColor Yellow
    Write-Host "  -ConnectionString  : Application Insights connection string"
    Write-Host "  -Help             : Show this help message"
    Write-Host ""
    Write-Host "Example:" -ForegroundColor Yellow
    Write-Host "  .\setup-appinsights.ps1 -ConnectionString 'InstrumentationKey=abc123;IngestionEndpoint=https://eastus-8.in.applicationinsights.azure.com/'"
    exit 0
}

Write-Host "🚀 Application Insights Setup for Spring Boot REST Service" -ForegroundColor Green
Write-Host ""

# Check if connection string is provided
if ([string]::IsNullOrEmpty($ConnectionString)) {
    Write-Host "⚠️  No connection string provided." -ForegroundColor Yellow
    Write-Host "You can either:" -ForegroundColor Yellow
    Write-Host "1. Run this script with -ConnectionString parameter"
    Write-Host "2. Set the APPLICATIONINSIGHTS_CONNECTION_STRING environment variable manually"
    Write-Host "3. Add it to application.properties (not recommended for production)"
    Write-Host ""
    
    $input = Read-Host "Enter your Application Insights connection string (or press Enter to skip)"
    if (![string]::IsNullOrEmpty($input)) {
        $ConnectionString = $input
    }
}

# Set environment variable if connection string is provided
if (![string]::IsNullOrEmpty($ConnectionString)) {
    Write-Host "🔧 Setting Application Insights connection string..." -ForegroundColor Blue
    $env:APPLICATIONINSIGHTS_CONNECTION_STRING = $ConnectionString
    Write-Host "✅ Environment variable set successfully!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "⚠️  Running without Application Insights connection string." -ForegroundColor Yellow
    Write-Host "Telemetry data will not be sent to Azure." -ForegroundColor Yellow
    Write-Host ""
}

# Build the application
Write-Host "🔨 Building the application..." -ForegroundColor Blue
try {
    mvn clean compile
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed"
    }
    Write-Host "✅ Build successful!" -ForegroundColor Green
} catch {
    Write-Host "❌ Build failed. Please check the error messages above." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🎯 Application is ready!" -ForegroundColor Green
Write-Host ""
Write-Host "To run the application:" -ForegroundColor Yellow
Write-Host "  mvn spring-boot:run"
Write-Host ""
Write-Host "Test endpoints:" -ForegroundColor Yellow
Write-Host "  curl http://localhost:8080/greeting"
Write-Host "  curl http://localhost:8080/greeting?name=Azure"
Write-Host "  curl http://localhost:8080/actuator/health"
Write-Host ""

if (![string]::IsNullOrEmpty($ConnectionString)) {
    Write-Host "📊 Application Insights is configured!" -ForegroundColor Green
    Write-Host "Telemetry data will be sent to Azure Application Insights." -ForegroundColor Green
    Write-Host ""
    Write-Host "To view telemetry data:" -ForegroundColor Yellow
    Write-Host "1. Go to Azure Portal"
    Write-Host "2. Navigate to your Application Insights resource"
    Write-Host "3. Check Live Metrics, Logs, and Application Map"
} else {
    Write-Host "⚠️  Application Insights is not configured." -ForegroundColor Yellow
    Write-Host "To enable telemetry, set the APPLICATIONINSIGHTS_CONNECTION_STRING environment variable." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📚 For more information, see APPLICATION_INSIGHTS_SETUP.md" -ForegroundColor Cyan
