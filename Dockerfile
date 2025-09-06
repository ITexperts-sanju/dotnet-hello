# 1. Build stage using .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY dotnet-hello-world.sln .
COPY hello-world-api/ ./hello-world-api/

# Restore and publish
RUN dotnet restore
RUN dotnet publish hello-world-api/hello-world-api.csproj -c Release -o /app/publish

# 2. Runtime stage with ASP.NET runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./

# Expose the port the app runs on
EXPOSE 5000

# Start the app
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
