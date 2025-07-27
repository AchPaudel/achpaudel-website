import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  template: `
    <div class="app-container">
      <header class="app-header">
        <h1>Achyut Paudel</h1>
        <nav>
          <a href="#home">Home</a>
          <a href="#projects">Projects</a>
          <a href="#about">About</a>
          <a href="#contact">Contact</a>
        </nav>
      </header>
      
      <main class="app-main">
        <section id="home" class="hero-section">
          <div class="hero-content">
            <h2>Full Stack Developer</h2>
            <p>Building modern web applications with Spring Boot and Angular</p>
            <button class="cta-button">View My Work</button>
          </div>
        </section>
        
        <section id="projects" class="projects-section">
          <h3>Featured Projects</h3>
          <div class="projects-grid">
            <div class="project-card" *ngFor="let project of projects">
              <h4>{{ project.title }}</h4>
              <p>{{ project.description }}</p>
              <div class="project-links">
                <a [href]="project.githubUrl" target="_blank">GitHub</a>
                <a [href]="project.liveUrl" target="_blank">Live Demo</a>
              </div>
            </div>
          </div>
        </section>
      </main>
      
      <footer class="app-footer">
        <p>&copy; 2024 Achyut Paudel. All rights reserved.</p>
      </footer>
    </div>
  `,
  styles: [`
    .app-container {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    
    .app-header {
      background: #2c3e50;
      color: white;
      padding: 1rem 2rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    
    .app-header nav a {
      color: white;
      text-decoration: none;
      margin-left: 2rem;
      transition: color 0.3s;
    }
    
    .app-header nav a:hover {
      color: #3498db;
    }
    
    .app-main {
      flex: 1;
    }
    
    .hero-section {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 4rem 2rem;
      text-align: center;
    }
    
    .hero-content h2 {
      font-size: 3rem;
      margin-bottom: 1rem;
    }
    
    .cta-button {
      background: #3498db;
      color: white;
      border: none;
      padding: 1rem 2rem;
      font-size: 1.1rem;
      border-radius: 5px;
      cursor: pointer;
      transition: background 0.3s;
    }
    
    .cta-button:hover {
      background: #2980b9;
    }
    
    .projects-section {
      padding: 4rem 2rem;
      background: #f8f9fa;
    }
    
    .projects-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 2rem;
      margin-top: 2rem;
    }
    
    .project-card {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      transition: transform 0.3s;
    }
    
    .project-card:hover {
      transform: translateY(-5px);
    }
    
    .project-links {
      margin-top: 1rem;
    }
    
    .project-links a {
      color: #3498db;
      text-decoration: none;
      margin-right: 1rem;
    }
    
    .app-footer {
      background: #2c3e50;
      color: white;
      text-align: center;
      padding: 2rem;
    }
  `]
})
export class AppComponent {
  projects = [
    {
      title: 'Personal Portfolio Website',
      description: 'A modern personal portfolio website built with Spring Boot and Angular.',
      githubUrl: 'https://github.com/achpaudel/portfolio-website',
      liveUrl: 'https://achpaudel.dev'
    },
    {
      title: 'E-Commerce Platform',
      description: 'A full-stack e-commerce solution with user authentication and payment integration.',
      githubUrl: 'https://github.com/achpaudel/ecommerce-platform',
      liveUrl: 'https://demo-ecommerce.achpaudel.dev'
    },
    {
      title: 'Task Management App',
      description: 'A collaborative task management application with real-time updates.',
      githubUrl: 'https://github.com/achpaudel/task-manager',
      liveUrl: 'https://task-manager.achpaudel.dev'
    }
  ];
} 