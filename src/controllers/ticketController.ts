import { Request, Response } from 'express';
import Ticket from '../models/tickets';
import Event from '../models/events';

// Create a new ticket
export const createTicket = async (req: Request, res: Response) => {
  try {
    const { eventId, userId, type, price, ticketCode } = req.body;

    // Check if tickets are available for the event
    const event = await Event.findById(eventId);
    if (!event) {
      return res.status(404).json({ message: 'Event not found' });
    }

    if (event.ticketsAvailable <= 0) {
      return res
        .status(400)
        .json({ message: 'Tickets are not available for this event' });
    }

    // Decrement the ticketsAvailable count for the event
    event.ticketsAvailable -= 1;
    await event.save();

    // Create a new ticket instance
    const ticket = new Ticket({
      eventId,
      userId,
      type,
      price,
      ticketCode,
      status: 'pending', // Set the initial status of the ticket
    });

    // Save the ticket to the database
    await ticket.save();

    // Return the newly created ticket in the response
    res.status(201).json(ticket);
  } catch (error) {
    console.error('Error creating ticket:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Get all tickets
export const getTickets = async (req: Request, res: Response) => {
  try {
    const tickets = await Ticket.find();
    res.json(tickets);
  } catch (error) {
    console.error('Error fetching tickets:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Get ticket by ID
export const getTicketById = async (req: Request, res: Response) => {
  try {
    const ticket = await Ticket.findById(req.params.id);
    if (!ticket) {
      return res.status(404).json({ message: 'Ticket not found' });
    }
    res.json(ticket);
  } catch (error) {
    console.error('Error fetching ticket by ID:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Update ticket by ID
export const updateTicket = async (req: Request, res: Response) => {
  try {
    const { eventId, userId, type, price, ticketCode } = req.body;

    const ticket = await Ticket.findByIdAndUpdate(
      req.params.id,
      { eventId, userId, type, price, ticketCode },
      { new: true }
    );

    if (!ticket) {
      return res.status(404).json({ message: 'Ticket not found' });
    }

    res.json(ticket);
  } catch (error) {
    console.error('Error updating ticket:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Delete ticket by ID
export const deleteTicket = async (req: Request, res: Response) => {
  try {
    const ticket = await Ticket.findByIdAndDelete(req.params.id);
    if (!ticket) {
      return res.status(404).json({ message: 'Ticket not found' });
    }
    res.json(ticket);
  } catch (error) {
    console.error('Error deleting ticket:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
