package com.achpaudel.website.repository;

import com.achpaudel.website.model.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProjectRepository extends JpaRepository<Project, Long> {
    
    List<Project> findByFeaturedOrderByCreatedAtDesc(boolean featured);
    
    List<Project> findAllByOrderByCreatedAtDesc();
} 