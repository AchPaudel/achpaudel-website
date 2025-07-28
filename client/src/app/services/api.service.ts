import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ApiResponse {
  status: string;
  message: string;
  data: any;
}

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = '/api'; // This will be relative to the current domain

  constructor(private http: HttpClient) {}

  getHealth(): Observable<ApiResponse> {
    return this.http.get<ApiResponse>(`${this.apiUrl}/health`);
  }

  getApiInfo(): Observable<ApiResponse> {
    return this.http.get<ApiResponse>(`${this.apiUrl}/info`);
  }

  callExternalApi(service: string, endpoint?: string, params?: string): Observable<ApiResponse> {
    let url = `${this.apiUrl}/external/${service}`;
    const queryParams = new URLSearchParams();
    
    if (endpoint) {
      queryParams.append('endpoint', endpoint);
    }
    if (params) {
      queryParams.append('params', params);
    }
    
    if (queryParams.toString()) {
      url += `?${queryParams.toString()}`;
    }
    
    return this.http.get<ApiResponse>(url);
  }

  // CRUD operations
  getAllData(): Observable<ApiResponse> {
    return this.http.get<ApiResponse>(`${this.apiUrl}/data`);
  }

  getDataById(id: string): Observable<ApiResponse> {
    return this.http.get<ApiResponse>(`${this.apiUrl}/data/${id}`);
  }

  createData(data: any): Observable<ApiResponse> {
    return this.http.post<ApiResponse>(`${this.apiUrl}/data`, data);
  }

  updateData(id: string, data: any): Observable<ApiResponse> {
    return this.http.put<ApiResponse>(`${this.apiUrl}/data/${id}`, data);
  }

  deleteData(id: string): Observable<ApiResponse> {
    return this.http.delete<ApiResponse>(`${this.apiUrl}/data/${id}`);
  }
} 