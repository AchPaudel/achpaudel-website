package com.achpaudel.website.service;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.Map;

@Service
public class ExternalApiService {

    private final WebClient webClient;

    public ExternalApiService() {
        this.webClient = WebClient.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(2 * 1024 * 1024))
                .build();
    }

    public Object callExternalApi(String service, String endpoint, String params) {
        String baseUrl = getBaseUrlForService(service);
        String fullUrl = buildUrl(baseUrl, endpoint, params);
        
        return webClient.get()
                .uri(fullUrl)
                .retrieve()
                .bodyToMono(Object.class)
                .block();
    }

    private String getBaseUrlForService(String service) {
        return switch (service.toLowerCase()) {
            case "microsoft-graph" -> "https://graph.microsoft.com/v1.0";
            case "github" -> "https://api.github.com";
            case "weather" -> "https://api.openweathermap.org/data/2.5";
            case "news" -> "https://newsapi.org/v2";
            default -> throw new IllegalArgumentException("Unknown service: " + service);
        };
    }

    private String buildUrl(String baseUrl, String endpoint, String params) {
        StringBuilder url = new StringBuilder(baseUrl);
        
        if (endpoint != null && !endpoint.isEmpty()) {
            if (!endpoint.startsWith("/")) {
                url.append("/");
            }
            url.append(endpoint);
        }
        
        if (params != null && !params.isEmpty()) {
            url.append("?").append(params);
        }
        
        return url.toString();
    }

    // Example method for Microsoft Graph API
    public Mono<Object> callMicrosoftGraph(String endpoint, String accessToken) {
        return webClient.get()
                .uri("https://graph.microsoft.com/v1.0" + endpoint)
                .header("Authorization", "Bearer " + accessToken)
                .retrieve()
                .bodyToMono(Object.class);
    }

    // Example method for GitHub API
    public Mono<Object> callGitHubApi(String endpoint) {
        return webClient.get()
                .uri("https://api.github.com" + endpoint)
                .header("User-Agent", "achpaudel-website")
                .retrieve()
                .bodyToMono(Object.class);
    }
} 