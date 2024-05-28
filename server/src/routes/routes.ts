// we use one file for route don't create multiple file i guess it would be better to use one file
// comments
import express from 'express';
import passport from 'passport';
// user routes
import { User, UserDocument } from '../models/user';
import {
  getAllUsers,
  getUserById,
  updateUserById,
  deleteUserById,
  registerUser,
  loginUser,
  protect,
  getMe,
  uploadUserPhoto,
  resizeUserPhoto,
  updateProfile,
  forgotPassword,
  resetPassword,
  googleSignInRedirect,
} from '../controllers/userController';
// event routes
import {
  createEvent,
  deleteEvent,
  getEventById,
  getEvents,
  resizeThumbnailPhoto,
  updateEvent,
  uploadThumbnailPhoto,
} from '../controllers/eventsController';

// Product Route
import {
  createProduct,
  getAllProducts,
  getProductById,
  updateProductById,
  deleteProductById,
} from '../controllers/productController';
// package routes
import {
  createPackage,
  getAllPackages,
  getPackageById,
  updatePackageById,
  deletePackageById,
} from '../controllers/packageController';
// tickte routes
import {
  createTicket,
  deleteTicket,
  getMyTickets,
  getTicketById,
  getTickets,
  updateTicket,
} from '../controllers/ticketController';
import { tryChapa } from '../controllers/transactionController';
import {
  add_remove,
  deleteFavorite,
  getAllFavorites,
  getFavoriteById,
  updateFavorite,
} from '../controllers/favoriteController';

const router = express.Router();

// Routes with controller functions
router.post('/users/create', registerUser);
router.get('/users', getAllUsers);
router.get('/profile', protect, getMe, getUserById);
router.get('/users/:id', getUserById);
router.put('/users/:id', updateUserById);
router.delete('/users/:id', deleteUserById);
router.patch(
  '/updateProfile',
  protect,
  uploadUserPhoto,
  resizeUserPhoto,
  updateProfile
);
router.post('/forgotPassword', forgotPassword);
router.patch('/resetPassword/:token', resetPassword);

// AUTHENTICATION
//login
router.post('/users/login', loginUser);

// Google OAuth login route
router.get(
  '/auth/google',
  passport.authenticate('google', { scope: ['profile', 'email'] })
);

// Google OAuth callback route

router.get(
  '/auth/google/callback',
  passport.authenticate('google', { failureRedirect: '/login' }),
  (req, res) => {
    // Redirect the user to the home page upon successful authentication
    res.redirect('http://localhost:3000/home');
  }
);

// router.get(
//   '/auth/google/callback',
//   passport.authenticate('google', { failureRedirect: '/login' }),googleSignInRedirect
// );

router.post('/users/logout'); //finish logout here

// event routes
// VIEW
router.get('/events', getEvents);
router.get('/events/:id', getEventById);

// API
router.post('/events', uploadThumbnailPhoto, resizeThumbnailPhoto, createEvent);
router.put(
  '/events/:id',
  uploadThumbnailPhoto,
  resizeThumbnailPhoto,
  updateEvent
);
router.delete('/events/:id', deleteEvent);

// favorites routes
// VIEW
router.get('/favorites',protect, getAllFavorites);
router.get('/favorites/:id', getFavoriteById);

// API
router.post('/favorites', add_remove);
router.put('/favorites/:id', updateFavorite);
router.delete('/favorites/:id', deleteFavorite);

// TICKET routes
// VIEW
router.get('/tickets', getTickets);
router.get('/tickets/:id', getTicketById);
router.get('/mytickets/:id', getMyTickets);

// API
router.post('/tickets', createTicket);
router.put('/tickets/:id', updateTicket);
router.delete('/tickets/:id', deleteTicket);

// product route with controller function
//VIEWs
router.get('/product', getAllProducts);
router.get('/product/:id', getProductById);
// API
router.post('/product', createProduct);
router.put('/product/:id', updateProductById);
router.delete('/product/:id', deleteProductById);

// attendant routes
// package routes
//views
router.get('/package', getAllPackages);
router.get('/package/:id', getPackageById);
// Routes for Package CRUD operations
router.post('/package', createPackage);
router.put('/package/:id', updatePackageById);
router.delete('/package/:id', deletePackageById);

export default router;
