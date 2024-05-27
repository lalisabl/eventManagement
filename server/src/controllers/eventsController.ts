import { NextFunction, Request, Response } from 'express';
import Event, { validateEvent } from '../models/events';
import multer from 'multer';
import sharp from 'sharp';
import Favorite from '../models/favorite';
import { UserDocument } from '../models/user';

const multerStorage = multer.memoryStorage();
const multerFilter = (req: Request, file: any, cb: any) => {
  if (file.mimetype.startsWith('image')) {
    cb(null, true);
  } else {
    cb(Error('Not an image! Please upload only images.'), false);
  }
};

const upload = multer({
  storage: multerStorage,
  fileFilter: multerFilter,
});
export const uploadThumbnailPhoto = upload.single('thumbnail');
export const resizeThumbnailPhoto = async (
  req: any,
  res: Response,
  next: NextFunction
) => {
  if (!req.file) return next();
  req.file.filename = `thumbnail-${req.body?.title}.jpeg`;
  await sharp(req.file.buffer)
    .resize(500, 500)
    .toFormat('jpeg')
    .jpeg({ quality: 90 })
    .toFile(`src/public/thumbnails/${req.file.filename}`);
  next();
};
// Create a new event
export const createEvent = async (req: Request, res: Response) => {
  try {
    const { error } = validateEvent(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    const event = new Event({ ...req.body, thumbnail: req?.file?.filename });
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
    const searchQuery = (this.queryString.q || '').toLowerCase();
    if (typeof searchQuery === 'string') {
      const regexSearch = {
        $or: [
          { title: { $regex: searchQuery, $options: 'i' } },
          { description: { $regex: searchQuery, $options: 'i' } },
          { location: { $regex: searchQuery, $options: 'i' } },
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
    const user = req.user as UserDocument;
    const userId = req.user ? user._id : '';
    console.log(userId);
    const features = new APIfeatures(Event.find(), req.query)
      .multfilter()
      .filter()
      .sort()
      .limiting()
      .paginatinating();
    const events = await features.query.select();

    if (userId) {
      // Fetch user's favorite events
      const favoriteEvents = await Favorite.find({ userId }).select('eventId');

      const favoriteEventIds = new Set(
        favoriteEvents.map((fav) => fav.eventId.toString())
      );

      // Add the favorite field to each event
      const eventsWithFavorite = events.map(
        (event: { toObject: () => any; _id: { toString: () => string } }) => ({
          ...event.toObject(),
          favorite: favoriteEventIds.has(event._id.toString()),
        })
      );

      res.send(eventsWithFavorite);
    } else {
      // If no userId, just send the events without the favorite field
      const eventsWithFavorite = events.map(
        (event: { toObject: () => any }) => ({
          ...event.toObject(),
          favorite: false,
        })
      );
      console.log(eventsWithFavorite);
      res.send(eventsWithFavorite);
    }
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
