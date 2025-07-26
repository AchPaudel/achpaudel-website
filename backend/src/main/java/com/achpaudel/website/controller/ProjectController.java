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
@RequestMapping("/projects")
@CrossOrigin(origins = "*")
@Tag(name = "Projects", description = "Project management APIs")
public class ProjectController {

  @Autowired
  private ProjectService projectService;

  @GetMapping
  @Operation(summary = "Get all projects", description = "Retrieve a list of all projects")
  public ResponseEntity<List<Project>> getAllProjects() {
    return ResponseEntity.ok(projectService.getAllProjects());
  }

  @GetMapping("/{id}")
  @Operation(summary = "Get project by ID", description = "Retrieve a specific project by its ID")
  public ResponseEntity<Project> getProjectById(@PathVariable Long id) {
    return projectService.getProjectById(id)
        .map(ResponseEntity::ok)
        .orElse(ResponseEntity.notFound().build());
  }

  @PostMapping
  @Operation(summary = "Create new project", description = "Create a new project")
  public ResponseEntity<Project> createProject(@RequestBody Project project) {
    return ResponseEntity.ok(projectService.saveProject(project));
  }

  @PutMapping("/{id}")
  @Operation(summary = "Update project", description = "Update an existing project")
  public ResponseEntity<Project> updateProject(@PathVariable Long id, @RequestBody Project project) {
    return ResponseEntity.ok(projectService.updateProject(id, project));
  }

  @DeleteMapping("/{id}")
  @Operation(summary = "Delete project", description = "Delete a project by its ID")
  public ResponseEntity<Void> deleteProject(@PathVariable Long id) {
    projectService.deleteProject(id);
    return ResponseEntity.ok().build();
  }
}