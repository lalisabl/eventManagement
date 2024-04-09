import mongoose, { Schema, Document } from 'mongoose';

// ticket Interface
export interface ITicket extends Document {
  eventId: mongoose.Types.ObjectId;
  userId: mongoose.Types.ObjectId;
  type: string;
  price: number;
  status: string;
  ticketCode: number;
}

//ticket schema
const ticketSchema: Schema = new Schema({
  eventId: { type: mongoose.Types.ObjectId, ref: 'Event', required: true },
  userId: { type: mongoose.Types.ObjectId, ref: 'User', required: true },
  type: { type: String, required: true },
  price: { type: Number, required: true },
  status: {
    type: String,
    enum: ['pending', 'cancelled', 'paid'],
    default: 'pending',
  },
  ticketCode: { type: Number, required: true },
});

const Ticket = mongoose.model<ITicket>('Ticket', ticketSchema);

export default Ticket;
