import { Request, Response } from 'express';
import Ticket, { validateTicket } from '../models/tickets';
import Event from '../models/events';
import { v4 as uuidv4 } from 'uuid';
import {
  generateTransactionGateway,
  verifyTransaction,
} from './transactionController';

// Function to check if a ticket code is unique
const isTicketCodeUnique = async (ticketCode: string) => {
  const existingTicket = await Ticket.findOne({ ticketCode });
  return !existingTicket;
};

// Create a new ticket
export const createTicket = async (req: Request, res: Response) => {
  try {
    const { error } = validateTicket(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const { eventId, email, firstName, lastName, userId, type } = req.body;

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

    const transaction = {
      firstName: firstName,
      lastName: lastName,
      email: email,
      amount: price,
      userId: userId,
    };
    const resp = await generateTransactionGateway(transaction);

    const transactionId = resp._id;
    if (transactionId) {
      const ticket = new Ticket({
        eventId,
        userId,
        type,
        transactionId,
        firstName,
        lastName,
        email,
        price,
        ticketCode,
        status: 'pending',
      });

      await ticket.save();
      res.status(201).json({ ticket: ticket, tranx: resp });
    } else {
      res.status(500).json({ message: 'Server error' });
    }
    // Saving
  } catch (error) {
    console.error('Error creating ticket:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Get all tickets
export const getTickets = async (req: Request, res: Response) => {
  try {
    const tickets = await Ticket.find().populate(
      'transactionId',
      '-checkout_url -__v'
    );

    for (const ticket of tickets) {
      let transaction: any = ticket?.transactionId;

      if (transaction?.status !== 'completed') {
        await verifyTransaction(ticket?.transactionId._id);

        // Repopulate the ticket after verification
        // await ticket.populate('transactionId', '-__v');
      }
    }
    const ticketRes = await Ticket.find().populate(
      'transactionId',
      '-checkout_url -__v'
    );

    res.json(ticketRes);
  } catch (error) {
    console.error('Error fetching tickets:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const getMyTickets = async (req: Request, res: Response) => {
  try {
    const userId = req.params.id;

    // Fetch all tickets for the user with event details populated
    const tickets = await Ticket.find({ userId })
      .populate({
        path: 'eventId',
        select: 'title thumbnail', // Include only title and thumbnail
      })
      .populate('transactionId', '-__v');

    if (!tickets.length) {
      return res
        .status(404)
        .json({ message: 'No tickets found for this user' });
    }

    // Verify transactions for each ticket
    for (let ticket of tickets) {
      let transaction: any = ticket.transactionId;
      if (transaction.status !== 'completed') {
        await verifyTransaction(transaction._id);
      }
    }

    // Re-fetch tickets to get updated transaction status
    const updatedTickets = await Ticket.find({ userId })
      .populate({
        path: 'eventId',
        select: 'title thumbnail',
      })
      .populate('transactionId', '-__v');

    // Prepare response data with checkout URL for pending transactions
    const responseData = updatedTickets.map((ticket) => {
      let transaction: any = ticket.transactionId;
      if (transaction.status === 'pending') {
        return {
          ...ticket.toObject(),
          checkoutUrl: transaction.checkout_url,
        };
      } else {
        return ticket.toObject();
      }
    });

    res.json(responseData);
  } catch (error) {
    console.error('Error fetching tickets for user:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// Get ticket by ID
export const getTicketById = async (req: Request, res: Response) => {
  try {
    const ticket = await Ticket.findById(req.params.id).populate(
      'transactionId',
      '-checkout_url -__v'
    );

    if (!ticket) {
      return res.status(404).json({ message: 'Ticket not found' });
    }
    let transaction: any = ticket.transactionId;
    console.log(transaction);
    if (transaction.status !== 'completed') {
      await verifyTransaction(ticket.transactionId._id);

      const ticketVerified = await Ticket.findById(req.params.id).populate(
        'transactionId',
        '-__v'
      );
      res.json(ticketVerified);
    } else {
      res.json(ticket);
    }
    // console.log(VerifyTransaction);
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
