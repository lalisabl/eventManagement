// we use one file for route don't create multiple file i guess it would be better to use one file
// comments
import express from "express";
const router = express.Router();
import {UserController} from "../controllers/userController";

import {
  createEvent,
  deleteEvent,
  getEventById,
  getEvents,
  updateEvent,
} from "../controllers/eventsController";
// Define user routes

// user Routes with controller functions
router.post('/signup', UserController.signup);
router.post('/login', UserController.login);
router
  .route("/me")
  .get(UserController.getMe, UserController.getOneUser);router.patch(
  "/updateMe",
  UserController.updateMe
);
router.patch('/password', UserController.updatePassword);
router
  .route("/:userId")
  .get(UserController.getOneUser)
  .delete(UserController.deleteUser);


// event routes
// VIEW
router.get("/events", getEvents);
router.get("/events/:id", getEventById);
// API
router.post("/events", createEvent);
router.put("/events/:id", updateEvent);
router.delete("/events/:id", deleteEvent);
// from murtessa
// attendant routes
// package routes
export default router;
