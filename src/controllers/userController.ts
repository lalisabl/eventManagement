import { Request, Response } from 'express';
import { User, validateUser } from '../models/user'; // Import your User model here

// User registration controller
export const registerUser = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    // Check if the email is already registered
    let user = await User.findOne({ email });
    if (user) {
      return res.status(400).json({ message: 'Email already registered' });
    }
    // Create new user
    user = new User({ email, password });
    await user.save();
    // Generate JWT token
    const token = user.generateAuthToke();
    res.status(201).json({ token });
  } catch (error) {
    console.error('Error registering user:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// User login controller
export const loginUser = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    // Find user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }
    // Check password
    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }
    // Generate JWT token
    const token = user.generateAuthToken();
    res.json({ token });
  } catch (error) {
    console.error('Error logging in:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Controller function to create a new user
export const createUser = async (req: Request, res: Response) => {
  try {
    const { fullName, username, email, password, role, profileImage } =
      req.body;
    const newUser = new User({
      fullName,
      username,
      email,
      password,
      role,
      profileImage,
    });
    await newUser.save();
    res.status(201).json(newUser);
  } catch (err) {
    res.status(500).json({ error: 'Could not create user' });
  }
};

// Controller function to get all users
export const getAllUsers = async (req: Request, res: Response) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: 'Could not retrieve users' });
  }
};

// Controller function to get a user by ID
export const getUserById = async (req: Request, res: Response) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: 'Could not retrieve user' });
  }
};

// Controller function to update a user by ID
export const updateUserById = async (req: Request, res: Response) => {
  try {
    const { fullName, username, email, password, role, profileImage } =
      req.body;
    const updatedUser = await User.findByIdAndUpdate(
      req.params.id,
      { fullName, username, email, password, role, profileImage },
      { new: true }
    );
    if (!updatedUser) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(updatedUser);
  } catch (err) {
    res.status(500).json({ error: 'Could not update user' });
  }
};

// Controller function to delete a user by ID
export const deleteUserById = async (req: Request, res: Response) => {
  try {
    const deletedUser = await User.findByIdAndDelete(req.params.id);
    if (!deletedUser) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(deletedUser);
  } catch (err) {
    res.status(500).json({ error: 'Could not delete user' });
  }
};
