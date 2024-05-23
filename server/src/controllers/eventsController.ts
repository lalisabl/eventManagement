import { Request, Response } from 'express';
import Event, { validateEvent } from '../models/events';

// Create a new event
export const createEvent = async (req: Request, res: Response) => {
  try {
    const { error } = validateEvent(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const event = new Event(req.body);
    await event.save();
    res.status(201).send(event);
  } catch (error) {
    console.error('Error creating event:', error);
    res.status(500).send('Server error');
  }
};

// Get all events
class APIfeatures {
  query: any;
  queryString: any;
  constructor(query: any, queryString: any) {
    this.query = query;
    this.queryString = queryString;
  }
  multfilter() {
    const searchQuery = this.queryString.q || '';
    if (typeof searchQuery === 'string') {
      const regexSearch = {
        $or: [
          { title: { $regex: searchQuery, $options: 'i' } },
          { description: { $regex: searchQuery, $options: 'i' } },
        ],
      };
      this.query.find(regexSearch);
    }
    return this;
  }
  filter() {
    //1 build query
    const queryObj = { ...this.queryString };
    const excludedFields = ['page', 'limit', 'sort', 'fields', 'q'];
    excludedFields.forEach((el) => delete queryObj[el]);
    // advanced query
    let queryStr = JSON.stringify(queryObj);
    queryStr = queryStr.replace(
      /\b(gte|gt|lte|lt|eq)\b/g,
      (match) => `$${match}`
    );
    this.query = this.query.find(JSON.parse(queryStr));
    return this;
  }
  sort() {
    if (this.queryString.sort) {
      const sortBy = this.queryString.sort.split(',').join(' ');
      this.query = this.query.sort(sortBy);
    } else {
      this.query = this.query.sort('-createdAt');
    }
    return this;
  }
  limiting() {
    if (this.queryString.fields) {
      const selectedFields = this.queryString.fields.split(',').join(' ');
      this.query = this.query.select(selectedFields);
    } else {
      this.query = this.query.select('-__v');
    }
    return this;
  }
  paginatinating() {
    const page = this.queryString.page * 1 || 1;
    const limit = this.queryString.limit * 1 || 10;
    const skip = (page - 1) * limit;
    this.query = this.query.skip(skip).limit(limit);
    return this;
  }
}

export const getEvents = async (req: Request, res: Response) => {
  try {
    const features = new APIfeatures(Event.find(), req.query)
      .multfilter()
      .filter()
      .sort()
      .limiting()
      .paginatinating();
    const events = await features.query.select();
    res.send(events);
  } catch (error) {
    console.error('Error fetching events:', error);
    res.status(500).send('Server error');
  }
};

// Get event by ID
export const getEventById = async (req: Request, res: Response) => {
  try {
    const event = await Event.findById(req.params.id).populate('organiserId');
    if (!event) return res.status(404).send('Event not found');
    res.send(event);
  } catch (error) {
    console.error('Error fetching event by ID:', error);
    res.status(500).send('Server error');
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
    if (!event) return res.status(404).send('Event not found');
    res.send(event);
  } catch (error) {
    console.error('Error updating event:', error);
    res.status(500).send('Server error');
  }
};

// Delete event by ID
export const deleteEvent = async (req: Request, res: Response) => {
  try {
    const event = await Event.findByIdAndDelete(req.params.id);
    if (!event) return res.status(404).send('Event not found');
    res.send(event);
  } catch (error) {
    console.error('Error deleting event:', error);
    res.status(500).send('Server error');
  }
};
