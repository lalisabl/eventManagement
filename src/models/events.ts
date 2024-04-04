import mongoose, { Schema, Document } from 'mongoose';
import Joi from 'joi';

// Define an interface for the event document
interface IEvent extends Document {
  name: string;
  description: string;
  startDate: Date;
  endDate: Date;
  location: string;
  capacity: number;
  ticketsAvailable: number;
  organiserId: string; // Assuming organiserId is of type string
}

// Define the schema for the event
const EventSchema: Schema = new Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  startDate: { type: Date, required: true },
  endDate: { type: Date, required: true },
  location: { type: String, required: true },
  capacity: { type: Number, required: true },
  ticketsAvailable: { type: Number, required: true },
  organiserId: { type: Schema.Types.ObjectId, ref: 'User', required: true } // Reference to User model
}, { timestamps: true });

// Define Joi schema for event validation
const eventJoiSchema = Joi.object({
  name: Joi.string().required(),
  description: Joi.string().required(),
  startDate: Joi.date().iso().required(),
  endDate: Joi.date().iso().required(),
  location: Joi.string().required(),
  capacity: Joi.number().integer().min(1).required(),
  ticketsAvailable: Joi.number().integer().min(0).required(),
  organiserId: Joi.string().required() // Assuming organiserId is of type string
});

// Validate event data against Joi schema
function validateEvent(eventData: any) {
  return eventJoiSchema.validate(eventData, { abortEarly: false });
}

// Define and export the Event model
const Event = mongoose.model<IEvent>('Event', EventSchema);

export default Event;
export { validateEvent };
