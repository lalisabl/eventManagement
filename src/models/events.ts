import mongoose, { Schema, Document } from 'mongoose';
import Joi from 'joi';
//  interface for the event document
interface IEvent extends Document {
  title: string;
  description: string;
  startDate: Date;
  endDate: Date;
  location: string;
  capacity: number;
  ticketsAvailable: number;
  organiserId: string;
}

// schema for the event
const EventSchema: Schema = new Schema(
  {
    title: { type: String, required: true },
    description: { type: String, required: true },
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
    location: { type: String, required: true },
    capacity: { type: Number, required: true },
    ticketsAvailable: { type: Number, required: true },
    organiserId: { type: Schema.Types.ObjectId, ref: 'User', required: true }, // Reference to User model
  },
  { timestamps: true }
);

// event validation
const eventJoiSchema = Joi.object({
  title: Joi.string().required(),
  description: Joi.string().required(),
  startDate: Joi.date().iso().required(),
  endDate: Joi.date().iso().required(),
  location: Joi.string().required(),
  capacity: Joi.number().integer().min(1).required(),
  ticketsAvailable: Joi.number().integer().min(0).required(),
  organiserId: Joi.string().required(),
});

// Validate event data against Joi schema
function validateEvent(eventData: any) {
  return eventJoiSchema.validate(eventData, { abortEarly: false });
}

// Define and export the Event model
const Event = mongoose.model<IEvent>('Event', EventSchema);

export default Event;
export { validateEvent };
