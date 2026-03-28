# StudySync Development Setup

## Quick Start

### Prerequisites
- Node.js 18+
- npm 9+
- PostgreSQL 16 (optional, skip if migrations are disabled)

### Installation

```bash
# Install backend dependencies
cd backend
npm install

# Install frontend dependencies
cd ../studysync-frontend
npm install
```

### Running Both Frontend and Backend

#### Option 1: Running in Separate Terminals (Recommended)

**Terminal 1 - Backend Server:**
```bash
cd backend
npm run dev
```
The backend will start on `http://localhost:3000`

**Terminal 2 - Frontend Dev Server:**
```bash
cd studysync-frontend
npm run dev
```
The frontend will start on `http://localhost:5173`

#### Option 2: Concurrently (requires npm-run-all)

Install concurrently:
```bash
npm install -g npm-run-all
```

From the root directory, you can run:
```bash
npm-run-all --parallel "npm:dev:backend" "npm:dev:frontend"
```

### Environment Configuration

#### Backend (.env)
```
NODE_ENV=development
PORT=3000
FRONTEND_URL=http://localhost:5173
DATABASE_URL=postgresql://postgres:angelzee@localhost:5432/studysync
API_VERSION=v1
JWT_SECRET=your-super-secret-key-change-in-production
JWT_REFRESH_SECRET=your-refresh-secret-key
JWT_EXPIRY=1h
JWT_REFRESH_EXPIRY=30d
```

#### Frontend (.env.local)
```
VITE_API_URL=http://localhost:3000/api/v1
```

### API Connection

The frontend communicates with the backend via:
- **Development**: Uses Vite proxy (`/api` → `http://localhost:3000`)
- **API Base URL**: `http://localhost:3000/api/v1`

### Available API Endpoints

#### Authentication
- `POST /api/v1/auth/login` - User login
  - Body: `{ email: string, password: string }`
  - Returns: `{ user, accessToken, refreshToken }`

- `POST /api/v1/auth/register` - User registration
  - Body: `{ name: string, email: string, password: string, phone: string }`
  - Returns: `{ user, message }`

#### Health Check
- `GET /health` - API health status

### Testing the Connection

1. Make sure both servers are running
2. Open the browser to `http://localhost:5173`
3. Navigate to the Login or Register page
4. Try to submit the form to test the API connection
5. Check the browser console for any errors

### Common Issues

**CORS Errors:**
- Ensure `FRONTEND_URL` in backend `.env` matches your frontend URL
- Development proxy should handle this automatically

**Connection Refused:**
- Make sure backend is running on port 3000
- Check firewall settings

**API URL Issues:**
- Frontend defaults to `/api/v1` in development (proxied)
- In production, update `VITE_API_URL` to the actual backend URL

### Database Setup (Optional)

If you want to enable database migrations:
```bash
cd backend
npm run db:migrate
```

Note: Currently migrations have some compatibility issues with PostGIS. You can comment out PostGIS-dependent code or install PostGIS separately.

### Building for Production

```bash
# Build backend
cd backend
npm run build

# Build frontend
cd studysync-frontend
npm run build
```

### Running Production Build

**Backend:**
```bash
cd backend
npm run start
```

**Frontend:**
```bash
cd studysync-frontend
npm run preview
```
