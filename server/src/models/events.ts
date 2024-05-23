import mongoose, { Schema, Document } from 'mongoose';
import Joi from 'joi';
//  interface for the event document
interface IEvent extends Document {
  title: string;
  description: string;
  startDate: Date;
  endDate: Date;
  location: string;
  organiserId: string;
  vipTicketsIncluded: boolean;
  normalTickets: number;
  normalPrice: number;
  vipTickets: number;
  vipPrice: number;
  normalTicketsAvailable: number;
  vipTicketsAvailable: number;
}

// schema for the event
const EventSchema: Schema = new Schema(
  {
    title: { type: String, required: true },
    description: { type: String, required: true },
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
    location: { type: String, required: true },
    thumbnail: { type: String, default: '' },
    vipTicketsIncluded: { type: Boolean, default: false, required: true },
    normalTickets: { type: Number, required: true },
    normalPrice: { type: Number, required: true },
    vipTickets: { type: Number },
    vipPrice: { type: Number },
    normalTicketsAvailable: { type: Number, required: true },
    vipTicketsAvailable: { type: Number },
    organiserId: { type: Schema.Types.ObjectId, ref: 'User', required: true }, // Reference to User model
    attendant: [
      {
        username: String,
        accessCode: String ,
      },
    ],
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
  thumbnail: Joi.string(),
  vipTicketsIncluded: Joi.boolean().required(),
  normalTickets: Joi.number().integer().min(0).required(),
  normalPrice: Joi.number().min(0).required(),
  vipTickets: Joi.number().integer().min(0).optional(),
  vipPrice: Joi.number().min(0).optional(),
  normalTicketsAvailable: Joi.number().integer().min(0).required(),
  vipTicketsAvailable: Joi.number().integer().min(0).optional(),
  organiserId: Joi.string().required(),
});

function validateEvent(eventData: any) {
  return eventJoiSchema.validate(eventData, { abortEarly: false });
}

const Event = mongoose.model<IEvent>('Event', EventSchema);

export default Event;
export { validateEvent };
