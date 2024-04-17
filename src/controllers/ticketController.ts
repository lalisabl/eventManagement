import { Request, Response } from 'express';
import Ticket from '../models/tickets';
import Event from '../models/events';
import { v4 as uuidv4 } from 'uuid';

// Function to check if a ticket code is unique
const isTicketCodeUnique = async (ticketCode: string) => {
  const existingTicket = await Ticket.findOne({ ticketCode });
  return !existingTicket;
};

// Create a new ticket
export const createTicket = async (req: Request, res: Response) => {
  try {
    const { eventId, userId, type } = req.body;

    // Check if tickets are available for the event
    const event = await Event.findById(eventId);
    if (!event) {
      return res.status(404).json({ message: 'Event not found' });
    }
    let price;
    if (type === 'VIP') {
      if (event.normalTicketsAvailable <= 0) {
        return res
          .status(400)
          .json({ message: 'Tickets are not available for this event' });
      }
      event.vipTicketsAvailable -= 1;
      price = event.vipPrice;
      await event.save();
    } else {
      if (event.normalTicketsAvailable <= 0) {
        return res
          .status(400)
          .json({ message: 'Tickets are not available for this event' });
      }

      event.normalTicketsAvailable -= 1;
      price = event.vipPrice;
      await event.save();
    }
    let ticketCode;
    let uniqueCodeFound = false;

    while (!uniqueCodeFound) {
      ticketCode = uuidv4().substring(0, 8);
      uniqueCodeFound = await isTicketCodeUnique(ticketCode);
    }

    const ticket = new Ticket({
      eventId,
      userId,
      type,
      price,
      ticketCode,
      status: 'pending',
    });

    // Saving
    await ticket.save();

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
    const { status } = req.body;

    const ticket = await Ticket.findByIdAndUpdate(
      req.params.id,
      { status },
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