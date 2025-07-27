-- Initialize database with sample data
-- This script runs when the PostgreSQL container starts

-- Create sample projects
INSERT INTO projects (title, description, technologies, github_url, live_url, image_url, featured, created_at, updated_at) VALUES
(
    'Personal Portfolio Website',
    'A modern personal portfolio website built with Spring Boot and Angular, featuring a responsive design and dynamic content management.',
    'Spring Boot, Angular, Docker, PostgreSQL, Nginx',
    'https://github.com/achpaudel/portfolio-website',
    'https://achpaudel.dev',
    '/assets/images/portfolio-project.jpg',
    true,
    NOW(),
    NOW()
),
(
    'E-Commerce Platform',
    'A full-stack e-commerce solution with user authentication, product management, and payment integration.',
    'Spring Boot, React, Stripe, Redis, MongoDB',
    'https://github.com/achpaudel/ecommerce-platform',
    'https://demo-ecommerce.achpaudel.dev',
    '/assets/images/ecommerce-project.jpg',
    true,
    NOW(),
    NOW()
),
(
    'Task Management App',
    'A collaborative task management application with real-time updates and team collaboration features.',
    'Node.js, Express, Socket.io, React, PostgreSQL',
    'https://github.com/achpaudel/task-manager',
    'https://task-manager.achpaudel.dev',
    '/assets/images/task-manager-project.jpg',
    false,
    NOW(),
    NOW()
),
(
    'Weather Dashboard',
    'A real-time weather dashboard with location-based forecasts and interactive charts.',
    'Angular, OpenWeather API, Chart.js, PWA',
    'https://github.com/achpaudel/weather-dashboard',
    'https://weather.achpaudel.dev',
    '/assets/images/weather-project.jpg',
    false,
    NOW(),
    NOW()
),
(
    'Blog Platform',
    'A content management system for blogs with markdown support and SEO optimization.',
    'Spring Boot, Thymeleaf, Bootstrap, MySQL',
    'https://github.com/achpaudel/blog-platform',
    'https://blog.achpaudel.dev',
    '/assets/images/blog-project.jpg',
    false,
    NOW(),
    NOW()
); 