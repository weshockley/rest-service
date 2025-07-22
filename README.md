# Basic Spring Web Application

This project contains a web service that will accept HTTP GET requests at
`http://localhost:8080/greeting`.

It will respond with a JSON representation of a greeting, as the following listing shows:

```json
{"id":1,"content":"Hello, World!"}
```

You can customize the greeting with an optional `name` parameter in the query string, as
the following listing shows:

```
http://localhost:8080/greeting?name=User
```

The `name` parameter value overrides the default value of `World` and is reflected in the
response, as the following listing shows:

```json
{"id":1,"content":"Hello, User!"}
```

## Building and running

```bash
./mvnw spring-boot:run
```

Then access the endpoint

```bash
curl http://localhost:8080/greeting?name=User
```

# Application Insights Setup
# follow this doc 

# https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/blob/main/opentelemetry-api/runtime-attach/CustomLoggerPerClass/README.md
