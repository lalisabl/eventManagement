import mongoose, { Schema, Document } from "mongoose";
import Joi from "joi";

export interface IEvent extends Document {
  title: string;
  description: string;
  date: Date;
  location: string;
  organizer: string;
}

const EventSchema: Schema = new Schema(
  {
    title: { type: String, required: true },
    description: { type: String, required: true },
    date: { type: Date, required: true },
    location: { type: String, required: true },
    organizer: { type: String, required: true },
  },
  {timestamps:true}
);

const Event = mongoose.model<IEvent>("Event", EventSchema);

// validation schema
const eventValidationSchema = Joi.object({
  title: Joi.string().required(),
  description: Joi.string().required(),
  date: Joi.date().required(),
  location: Joi.string().required(),
  organizer: Joi.string().required(),
});

export { Event, eventValidationSchema };
