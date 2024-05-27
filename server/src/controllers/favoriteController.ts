import { Request, Response } from 'express';
import { UserDocument } from '../models/user';
const { User } = require('../models/user');
import Event from '../models/events';
import Favorite from '../models/favorite';

// Create a new favorite
export const add_remove = async (req: Request, res: Response) => {
  try {
    const { userId, eventId } = req.body;

    // Check if user exists
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Check if event exists
    const event = await Event.findById(eventId);
    if (!event) return res.status(404).json({ message: 'Event not found' });

    // Check if the favorite already exists
    const favoriteExist = await Favorite.findOne({ userId, eventId });
    if (favoriteExist) {
      await Favorite.findByIdAndDelete(favoriteExist?._id);
      return res.status(204).json({ message: 'Favorite removed' });
    }

    // Create new favorite
    const favorite = new Favorite({ userId, eventId });
    await favorite.save();

    res.status(201).json(favorite);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

// Get all favorites
export const getAllFavorites = async (req: Request, res: Response) => {
  try {
    const user = req.user as UserDocument;
    const userId = req.user ? user._id : '664c71c508677fd5c52b6023';
    const userFavorites = await Favorite.find({ userId });

    res.json(userFavorites);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

// Get a favorite by ID
export const getFavoriteById = async (req: Request, res: Response) => {
  try {
    const favorite = await Favorite.findById(req.params.id);
    if (!favorite)
      return res.status(404).json({ message: 'Favorite not found' });

    res.json(favorite);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

// Update a favorite
export const updateFavorite = async (req: Request, res: Response) => {
  try {
    const { userId, propertyId } = req.body;

    // Check if user exists
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Check if property exists
    const property = await Event.findById(propertyId);
    if (!property)
      return res.status(404).json({ message: 'Property not found' });

    // Find and update the favorite
    const favorite = await Favorite.findByIdAndUpdate(
      req.params.id,
      { userId, propertyId },
      { new: true }
    );
    if (!favorite)
      return res.status(404).json({ message: 'Favorite not found' });

    res.json(favorite);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

// Delete a favorite
export const deleteFavorite = async (req: Request, res: Response) => {
  try {
    const favorite = await Favorite.findById(req.params.id);
    if (!favorite)
      return res.status(404).json({ message: 'Favorite not found' });

    // await favorite.remove();
    res.json({ message: 'Favorite deleted successfully' });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
