// we use one file for route don't create multiple file i guess it would be better to use one file
// comments
// from murtessa

// user routes
import express from 'express';
import {
  createUser,
  getAllUsers,
  getUserById,
  updateUserById,
  deleteUserById,
  registerUser,
  loginUser,
  protect,
  getMe,
} from '../controllers/userController';
import {
  createEvent,
  deleteEvent,
  getEventById,
  getEvents,
  updateEvent,
} from '../controllers/eventsController';

// Product Route
import {
  createProduct,
  getAllProducts,
  getProductById,
  updateProductById,
  deleteProductById,
} from '../controllers/productController';

import {
  createPackage,
  getAllPackages,
  getPackageById,
  updatePackageById,
  deletePackageById,
} from '../controllers/packageController';
import {
  createTicket,
  deleteTicket,
  getTicketById,
  getTickets,
  updateTicket,
} from '../controllers/ticketController';
import { tryChapa } from '../controllers/transactionController';
import passport from 'passport';

const router = express.Router();
//try payment gateway
router.get('/trychapa', tryChapa);

// Routes with controller functions
router.post('/users', createUser);
router.post('/users/register-user', registerUser);
router.get('/users', getAllUsers);
router.get("/me",protect,getMe,getUserById);
router.get('/users/:id', getUserById);
router.put('/users/:id', updateUserById);
router.delete('/users/:id', deleteUserById);

// AUTHENTICATION
//login
router.post('/users/login', loginUser);

// Google OAuth login route
router.get('/auth/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

// Google OAuth callback route
router.get(
  '/auth/google/callback',
  passport.authenticate('google', { failureRedirect: '/login' }),
  (req, res) => {
    // Generate JWT token for the user
    const token = jwt.sign({ id: (req.user as UserDocument)._id }, 'YOUR_SECRET_KEY', {
      expiresIn: '1h',
    });
    // Redirect or send token as response
    res.redirect(`/profile?token=${token}`);
  }
);


router.post('/users/logout'); //finish logout here

// event routes
// VIEW
router.get('/events', getEvents);
router.get('/events/:id', getEventById);

// API
router.post('/events', createEvent);
router.put('/events/:id', updateEvent);
router.delete('/events/:id', deleteEvent);

// TICKET routes
// VIEW
router.get('/tickets', getTickets);
router.get('/tickets/:id', getTicketById);

// API
router.post('/tickets', createTicket);
router.put('/tickets/:id', updateTicket);
router.delete('/tickets/:id', deleteTicket);

// product route with controller function

// Routes for Product CRUD operations
router.post('/product', createProduct);
router.get('/product', getAllProducts);
router.get('/product/:id', getProductById);
router.put('/product/:id', updateProductById);
router.delete('/product/:id', deleteProductById);

// attendant routes
// package routes
// Routes for Package CRUD operations
router.post('/package', createPackage);
router.get('/package', getAllPackages);
router.get('/package/:id', getPackageById);
router.put('/package/:id', updatePackageById);
router.delete('/package/:id', deletePackageById);

export default router