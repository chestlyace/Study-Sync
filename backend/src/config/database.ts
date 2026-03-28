import { Pool, PoolClient } from 'pg';
import { env } from './env';

// Create connection pool
export const pool = new Pool({
  connectionString: env.DATABASE_URL,
  min: 2,
  max: 10,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Handle pool errors
pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

pool.on('connect', () => {
  console.log('New database connection established');
});

// Health check function
export async function checkDatabaseConnection(): Promise<boolean> {
  try {
    const result = await pool.query('SELECT NOW()');
    console.log('✓ Database connection successful at:', result.rows[0].now);
    return true;
  } catch (error) {
    console.error('✗ Database connection failed:', error);
    return false;
  }
}

// Get client from pool
export async function getClient(): Promise<PoolClient> {
  return pool.connect();
}

// Query wrapper
export async function query(text: string, params?: any[]) {
  return pool.query(text, params);
}

// Close the pool (call this when shutting down the app)
export async function closePool(): Promise<void> {
  await pool.end();
  console.log('Database connection pool closed');
}
