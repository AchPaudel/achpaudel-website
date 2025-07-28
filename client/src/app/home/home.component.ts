import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../services/api.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="home-container">
      <header class="header">
        <div class="container">
          <h1 class="title">Achyut Paudel</h1>
          <p class="subtitle">Software Developer & Technology Enthusiast</p>
        </div>
      </header>

      <main class="main-content">
        <div class="container">
          <section class="hero-section">
            <h2>Welcome to my personal website</h2>
            <p>I'm a passionate software developer who loves building innovative solutions and exploring new technologies.</p>
            
            <div class="cta-buttons">
              <button class="btn btn-primary" (click)="testApi()">Test API Connection</button>
              <button class="btn btn-secondary" (click)="getApiInfo()">Get API Info</button>
            </div>
          </section>

          <section class="api-status" *ngIf="apiStatus">
            <h3>API Status</h3>
            <div class="status-card" [class]="apiStatus.status">
              <p><strong>Status:</strong> {{ apiStatus.message }}</p>
              <pre *ngIf="apiStatus.data">{{ apiStatus.data | json }}</pre>
            </div>
          </section>

          <section class="features">
            <h3>What I Do</h3>
            <div class="features-grid">
              <div class="feature-card">
                <h4>Web Development</h4>
                <p>Building modern, responsive web applications with Angular, React, and Spring Boot.</p>
              </div>
              <div class="feature-card">
                <h4>API Development</h4>
                <p>Creating robust REST APIs and microservices with Spring Boot and Java.</p>
              </div>
              <div class="feature-card">
                <h4>DevOps</h4>
                <p>Deploying applications with Docker, CI/CD pipelines, and cloud infrastructure.</p>
              </div>
            </div>
          </section>
        </div>
      </main>

      <footer class="footer">
        <div class="container">
          <p>&copy; 2024 Achyut Paudel. All rights reserved.</p>
        </div>
      </footer>
    </div>
  `,
  styles: [`
    .home-container {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 4rem 0;
      text-align: center;
    }

    .title {
      font-size: 3rem;
      font-weight: 700;
      margin: 0 0 1rem 0;
    }

    .subtitle {
      font-size: 1.25rem;
      opacity: 0.9;
      margin: 0;
    }

    .main-content {
      flex: 1;
      padding: 4rem 0;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 2rem;
    }

    .hero-section {
      text-align: center;
      margin-bottom: 4rem;
    }

    .hero-section h2 {
      font-size: 2.5rem;
      margin-bottom: 1rem;
      color: #333;
    }

    .hero-section p {
      font-size: 1.25rem;
      color: #666;
      margin-bottom: 2rem;
    }

    .cta-buttons {
      display: flex;
      gap: 1rem;
      justify-content: center;
      flex-wrap: wrap;
    }

    .btn {
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 0.5rem;
      font-size: 1rem;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .btn-primary {
      background: #667eea;
      color: white;
    }

    .btn-primary:hover {
      background: #5a6fd8;
      transform: translateY(-2px);
    }

    .btn-secondary {
      background: #f8f9fa;
      color: #333;
      border: 1px solid #dee2e6;
    }

    .btn-secondary:hover {
      background: #e9ecef;
      transform: translateY(-2px);
    }

    .api-status {
      margin-bottom: 4rem;
    }

    .api-status h3 {
      text-align: center;
      margin-bottom: 2rem;
      color: #333;
    }

    .status-card {
      background: #f8f9fa;
      border-radius: 0.5rem;
      padding: 1.5rem;
      border-left: 4px solid #28a745;
    }

    .status-card.error {
      border-left-color: #dc3545;
      background: #f8d7da;
    }

    .status-card pre {
      background: #f1f3f4;
      padding: 1rem;
      border-radius: 0.25rem;
      overflow-x: auto;
      margin-top: 1rem;
    }

    .features {
      margin-bottom: 4rem;
    }

    .features h3 {
      text-align: center;
      margin-bottom: 2rem;
      color: #333;
    }

    .features-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 2rem;
    }

    .feature-card {
      background: white;
      padding: 2rem;
      border-radius: 0.5rem;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease;
    }

    .feature-card:hover {
      transform: translateY(-4px);
    }

    .feature-card h4 {
      color: #667eea;
      margin-bottom: 1rem;
      font-size: 1.25rem;
    }

    .feature-card p {
      color: #666;
      line-height: 1.6;
    }

    .footer {
      background: #333;
      color: white;
      text-align: center;
      padding: 2rem 0;
      margin-top: auto;
    }

    @media (max-width: 768px) {
      .title {
        font-size: 2rem;
      }

      .hero-section h2 {
        font-size: 2rem;
      }

      .cta-buttons {
        flex-direction: column;
        align-items: center;
      }

      .features-grid {
        grid-template-columns: 1fr;
      }
    }
  `]
})
export class HomeComponent implements OnInit {
  apiStatus: any = null;

  constructor(private apiService: ApiService) {}

  ngOnInit(): void {
    // Test API connection on component load
    this.testApi();
  }

  testApi(): void {
    this.apiService.getHealth().subscribe({
      next: (response) => {
        this.apiStatus = {
          status: 'success',
          message: 'API is connected and running',
          data: response
        };
      },
      error: (error) => {
        this.apiStatus = {
          status: 'error',
          message: 'Failed to connect to API',
          data: error
        };
      }
    });
  }

  getApiInfo(): void {
    this.apiService.getApiInfo().subscribe({
      next: (response) => {
        this.apiStatus = {
          status: 'success',
          message: 'API information retrieved',
          data: response
        };
      },
      error: (error) => {
        this.apiStatus = {
          status: 'error',
          message: 'Failed to get API information',
          data: error
        };
      }
    });
  }
} 