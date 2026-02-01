# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["PcmBackend.csproj", "./"]
RUN dotnet restore "PcmBackend.csproj"
COPY . .
RUN dotnet build "PcmBackend.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "PcmBackend.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
# Copy SQLite database
COPY pcm.db ./

# Expose port and force override URLs
EXPOSE 8080
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Override the hardcoded URLs in Program.cs
ENTRYPOINT ["dotnet", "PcmBackend.dll", "--urls", "http://0.0.0.0:8080"]
