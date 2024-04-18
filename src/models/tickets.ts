import Joi from 'joi';
import mongoose, { Schema, Document } from 'mongoose';

// ticket Interface
export interface ITicket extends Document {
  eventId: mongoose.Types.ObjectId;
  userId: mongoose.Types.ObjectId;
  type: string;
  price: number;
  status: string;
  ticketCode: string;
  firstName: string;
  lastName: string;
  email: string;
}

//ticket schema
const ticketSchema: Schema = new Schema(
  {
    eventId: { type: mongoose.Types.ObjectId, ref: 'Event', required: true },
    userId: { type: mongoose.Types.ObjectId, ref: 'User', required: true },
    email: { type: String, required: true },
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    type: { type: String, required: true },
    price: { type: Number, required: true },
    status: {
      type: String,
      enum: ['pending', 'cancelled', 'paid'],
      default: 'pending',
    },
    ticketCode: { type: String, required: true, unique: true },
  },
  { timestamps: true }
);

const ticketJoiSchema = Joi.object({
  type: Joi.string().required(),
  fullName: Joi.string().required(),
  username: Joi.string().required(),
  email: Joi.string().email().required(),
  eventId: Joi.string().required(),
  userId: Joi.string().required(),
});

function validateTicket(ticketData: any) {
  return ticketJoiSchema.validate(ticketData, { abortEarly: false });
}

const Ticket = mongoose.model<ITicket>('Ticket', ticketSchema);

export default Ticket;
export { validateTicket };
