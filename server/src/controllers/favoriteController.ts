import { Request, Response } from 'express';
import { UserDocument } from '../models/user';
const { Favorite } = require('../models/favorite');
const { User } = require('../models/user');
import Event, { validateEvent } from '../models/events';

// Create a new favorite
exports.createFavorite = async (req: Request, res: Response) => {
  try {
    const { userId, propertyId } = req.body;
    // Check if user exists
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Check if property exists
    const property = await Event.findById(propertyId);
    if (!property)
      return res.status(404).json({ message: 'Property not found' });

    // Create new favorite
    const favorite = new Favorite({ userId, propertyId });
    await favorite.save();

    res.status(201).json(favorite);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

// Get all favorites
exports.getAllFavorites = async (req: Request, res: Response) => {
  try {
    const user = req.user as UserDocument;
    const userId = req.user ? user._id : '';
    const userFavorites = await Favorite.find({ userId });

    res.json(userFavorites);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

// Get a favorite by ID
exports.getFavoriteById = async (req: Request, res: Response) => {
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
exports.updateFavorite = async (req: Request, res: Response) => {
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
exports.deleteFavorite = async (req: Request, res: Response) => {
  try {
    const favorite = await Favorite.findById(req.params.id);
    if (!favorite)
      return res.status(404).json({ message: 'Favorite not found' });

    await favorite.remove();
    res.json({ message: 'Favorite deleted successfully' });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
