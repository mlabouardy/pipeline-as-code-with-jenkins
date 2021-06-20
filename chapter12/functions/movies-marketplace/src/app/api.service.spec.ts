import { TestBed } from '@angular/core/testing';
import { HttpModule } from '@angular/http';
import { ApiService } from './api.service';

describe('ApiService', () => {
  beforeEach(() => TestBed.configureTestingModule({
    imports: [HttpModule]
  }));

  it('should be created', () => {
    const service: ApiService = TestBed.get(ApiService);
    expect(service).toBeTruthy();
  });
});
