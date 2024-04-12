// Import necessary modules
import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import {User} from '../models/user'; 

// Define controller methods
const UserController = {
  // Signup route handler
  signup: async (req: Request, res: Response) => {
    try {
      const { fullName, username, email, password } = req.body;
      // Check if user already exists
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res.status(400).json({ message: 'User already exists' });
      }
      // Hash the password
      const hashedPassword = await bcrypt.hash(password, 10);
      // Create new user instance
      const newUser = new User({
        fullName,
        username,
        email,
        password: hashedPassword,
      });
      // Save the user to the database
      await newUser.save();

      // Send success response
      res.status(201).json({ message: 'User registered successfully' });
    } catch (error) {
      // Handle errors
      console.error('Error in signup:', error);
      res.status(500).json({ message: 'Server error' });
    }
  },

  // Login route handler
  login: async (req: Request, res: Response) => {
    try {
      // Extract user input from request body
      const { email, password } = req.body;

      // Find user by email
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      // Compare passwords
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }

      // Generate JWT token
      const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });

      // Send success response with token
      res.status(200).json({ message: 'Login successful', token });
    } catch (error) {
      // Handle errors
      console.error('Error in login:', error);
      res.status(500).json({ message: 'Server error' });
    }
  },
};

// Export UserController
export default UserController;
