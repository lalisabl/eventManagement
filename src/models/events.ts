import mongoose, { Schema, Document } from "mongoose";
import Joi from "joi";

// event document interface
interface IEvent extends Document {
  name: string;
  description: string;
  startDate: Date;
  endDate: Date;
  location: string;
  capacity: number;
  ticketsAvailable: number;
}

// event schema
const EventSchema: Schema = new Schema(
  {
    name: { type: String, required: true },
    description: { type: String, required: true },
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
    location: { type: String, required: true },
    capacity: { type: Number, required: true },
    ticketsAvailable: { type: Number, required: true },
  },
  {
    timestamps: true, //this Automatically add createdAt and updatedAt 
  }
);

//  Joi  validation
const eventJoiSchema = Joi.object({
  name: Joi.string().required(),
  description: Joi.string().required(),
  startDate: Joi.date().iso().required(),
  endDate: Joi.date().iso().required(),
  location: Joi.string().required(),
  capacity: Joi.number().integer().min(1).required(),
  ticketsAvailable: Joi.number().integer().min(0).required(),
});

// validate
function validateEvent(eventData: any) {
  return eventJoiSchema.validate(eventData, { abortEarly: false });
}

const Event = mongoose.model<IEvent>("Event", EventSchema);

exports.Event = Event;
exports.validateEvent = validateEvent;
