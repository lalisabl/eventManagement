// <<<<<<< HEAD
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

const router = express.Router();

// Routes with controller functions
router.post('/users', createUser);
router.post('/users/register-user', registerUser);
router.get('/users', getAllUsers);
router.get('/users/:id', getUserById);
router.put('/users/:id', updateUserById);
router.delete('/users/:id', deleteUserById);

// AUTHENTICATION
//login
router.post('/users/login', loginUser);
router.post('/users/logout');//finish logout here

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

export default router;
// >>>>>>> 8ec8d3edddac37408849f7af7e0d7977400c7d3e
