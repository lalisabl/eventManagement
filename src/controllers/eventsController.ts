import { Request, Response } from "express";
import Event, { validateEvent } from "../models/events";

// Create a new event
export const createEvent = async (req: Request, res: Response) => {
  try {
    const { error } = validateEvent(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const event = new Event(req.body);
    await event.save();
    res.status(201).send(event);
  } catch (error) {
    console.error("Error creating event:", error);
    res.status(500).send("Server error");
  }
};

// Get all events
export const getEvents = async (req: Request, res: Response) => {
  try {
    const events = await Event.find();
    res.send(events);
  } catch (error) {
    console.error("Error fetching events:", error);
    res.status(500).send("Server error");
  }
};

// Get event by ID
export const getEventById = async (req: Request, res: Response) => {
  try {
    const event = await Event.findById(req.params.id);
    if (!event) return res.status(404).send("Event not found");
    res.send(event);
  } catch (error) {
    console.error("Error fetching event by ID:", error);
    res.status(500).send("Server error");
  }
};

// Update event by ID
export const updateEvent = async (req: Request, res: Response) => {
  try {
    const { error } = validateEvent(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const event = await Event.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!event) return res.status(404).send("Event not found");
    res.send(event);
  } catch (error) {
    console.error("Error updating event:", error);
    res.status(500).send("Server error");
  }
};

// Delete event by ID
export const deleteEvent = async (req: Request, res: Response) => {
  try {
    const event = await Event.findByIdAndDelete(req.params.id);
    if (!event) return res.status(404).send("Event not found");
    res.send(event);
  } catch (error) {
    console.error("Error deleting event:", error);
    res.status(500).send("Server error");
  }
};
