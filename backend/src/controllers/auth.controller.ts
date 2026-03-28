import { Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { env } from '../config/env';

export const login = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    // For demo purposes, accept any email/password
    // In real app, validate against database
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    // Mock user
    const user = {
      id: '123',
      email,
      name: 'Test User',
    };

    // Generate tokens
    const accessToken = jwt.sign(
      { userId: user.id, email: user.email },
      'secret-key',
      { expiresIn: '1h' }
    );

    const refreshToken = jwt.sign(
      { userId: user.id },
      'refresh-secret-key',
      { expiresIn: '30d' }
    );

    res.json({
      user,
      accessToken,
      refreshToken,
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const register = async (req: Request, res: Response) => {
  try {
    const { email, password, name, phone } = req.body;

    if (!email || !password || !name || !phone) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    // Mock user creation
    const user = {
      id: '123',
      email,
      name,
      phone,
    };

    res.status(201).json({
      user,
      message: 'User registered successfully',
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
