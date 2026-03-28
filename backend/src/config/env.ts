import dotenv from 'dotenv';

dotenv.config();

export const env = {
  NODE_ENV: process.env.NODE_ENV || 'development',
  PORT: parseInt(process.env.PORT || '3000'),
  API_VERSION: process.env.API_VERSION || 'v1',
  DATABASE_URL: process.env.DATABASE_URL!,
  REDIS_URL: process.env.REDIS_URL!,
  JWT_SECRET: process.env.JWT_SECRET!,
  JWT_REFRESH_SECRET: process.env.JWT_REFRESH_SECRET!,
  JWT_EXPIRY: process.env.JWT_EXPIRY!,
  JWT_REFRESH_EXPIRY: process.env.JWT_REFRESH_EXPIRY!,
  FRONTEND_URL: process.env.FRONTEND_URL!,
};
