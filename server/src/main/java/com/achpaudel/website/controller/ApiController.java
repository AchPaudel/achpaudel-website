package com.achpaudel.website.controller;

import com.achpaudel.website.model.ApiResponse;
import com.achpaudel.website.service.ExternalApiService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
@Tag(name = "API", description = "REST API endpoints")
public class ApiController {

    @Autowired
    private ExternalApiService externalApiService;

    @GetMapping("/health")
    @Operation(summary = "Health check", description = "Check if the API is running")
    public ResponseEntity<ApiResponse> healthCheck() {
        return ResponseEntity.ok(new ApiResponse("success", "API is running", null));
    }

    @GetMapping("/info")
    @Operation(summary = "Get API info", description = "Get information about the API")
    public ResponseEntity<ApiResponse> getApiInfo() {
        Map<String, Object> info = Map.of(
            "name", "Achyut Paudel Website API",
            "version", "1.0.0",
            "description", "Personal website backend API",
            "endpoints", Map.of(
                "/api/health", "Health check endpoint",
                "/api/info", "API information",
                "/api/external/{service}", "External API proxy"
            )
        );
        return ResponseEntity.ok(new ApiResponse("success", "API information retrieved", info));
    }

    @GetMapping("/external/{service}")
    @Operation(summary = "External API proxy", description = "Proxy requests to external APIs")
    public ResponseEntity<ApiResponse> callExternalApi(
            @PathVariable String service,
            @RequestParam(required = false) String endpoint,
            @RequestParam(required = false) String params) {
        
        try {
            Object result = externalApiService.callExternalApi(service, endpoint, params);
            return ResponseEntity.ok(new ApiResponse("success", "External API call successful", result));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse("error", "Failed to call external API: " + e.getMessage(), null));
        }
    }

    // Example CRUD endpoints for demonstration
    @PostMapping("/data")
    @Operation(summary = "Create data", description = "Create new data entry")
    public ResponseEntity<ApiResponse> createData(@RequestBody Map<String, Object> data) {
        // In a real application, this would save to a database
        return ResponseEntity.ok(new ApiResponse("success", "Data created successfully", data));
    }

    @GetMapping("/data")
    @Operation(summary = "Get all data", description = "Retrieve all data entries")
    public ResponseEntity<ApiResponse> getAllData() {
        // In a real application, this would fetch from a database
        Map<String, Object> sampleData = Map.of(
            "items", java.util.List.of(
                Map.of("id", 1, "name", "Sample Item 1"),
                Map.of("id", 2, "name", "Sample Item 2")
            )
        );
        return ResponseEntity.ok(new ApiResponse("success", "Data retrieved successfully", sampleData));
    }

    @GetMapping("/data/{id}")
    @Operation(summary = "Get data by ID", description = "Retrieve data by ID")
    public ResponseEntity<ApiResponse> getDataById(@PathVariable String id) {
        // In a real application, this would fetch from a database
        Map<String, Object> data = Map.of("id", id, "name", "Sample Item " + id);
        return ResponseEntity.ok(new ApiResponse("success", "Data retrieved successfully", data));
    }

    @PutMapping("/data/{id}")
    @Operation(summary = "Update data", description = "Update existing data")
    public ResponseEntity<ApiResponse> updateData(@PathVariable String id, @RequestBody Map<String, Object> data) {
        // In a real application, this would update in a database
        data.put("id", id);
        return ResponseEntity.ok(new ApiResponse("success", "Data updated successfully", data));
    }

    @DeleteMapping("/data/{id}")
    @Operation(summary = "Delete data", description = "Delete data by ID")
    public ResponseEntity<ApiResponse> deleteData(@PathVariable String id) {
        // In a real application, this would delete from a database
        return ResponseEntity.ok(new ApiResponse("success", "Data deleted successfully", Map.of("id", id)));
    }
} 