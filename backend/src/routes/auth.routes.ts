import { Router } from 'express';
import { login, register } from '../controllers/auth.controller';

const router = Router();

// POST /api/v1/auth/login
router.post('/login', login);

// POST /api/v1/auth/register
router.post('/register', register);

export default router;
