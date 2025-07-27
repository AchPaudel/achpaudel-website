package com.achpaudel.website.controller;

import com.achpaudel.website.model.Project;
import com.achpaudel.website.service.ProjectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/test")
@CrossOrigin(origins = "*")
@Tag(name = "Projects", description = "Project management APIs")
public class ProjectController {

  @GetMapping("")
  @Operation(summary = "test api", description = "")
  public ResponseEntity<String> getAllProjects() {
    return ResponseEntity.ok("Hello Test World.");
  }
}