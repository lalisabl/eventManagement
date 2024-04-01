import { Request, Response } from 'express';
import User from '../models/user'; // Import your User model here

// Controller function to create a new user
export const createUser = async (req: Request, res: Response) => {
  try {
    const { fullName, username, email, password, role, profileImage } = req.body;
    const newUser = new User({ fullName, username, email, password, role, profileImage });
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
    const { fullName, username, email, password, role, profileImage } = req.body;
    const updatedUser = await User.findByIdAndUpdate(req.params.id, { fullName, username, email, password, role, profileImage }, { new: true });
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
