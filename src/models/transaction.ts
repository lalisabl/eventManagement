import mongoose, { Schema, Document } from 'mongoose';

interface IPaymentTransaction extends Document {
  userId: string;
  amount: number;
  paymentMethod: string;
  status: string;
  tickets: string[];
  //
}

const PaymentTransactionSchema = new Schema(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    amount: { type: Number, required: true },
    paymentMethod: { type: String, required: true },
    status: {
      type: String,
      enum: ['pending', 'completed', 'failed'],
      default: 'pending',
    },
    tickets: [{ type: Schema.Types.ObjectId, ref: 'Ticket' }],
    //
  },
  { timestamps: true }
);

const PaymentTransaction = mongoose.model<IPaymentTransaction>(
  'PaymentTransaction',
  PaymentTransactionSchema
);

export default PaymentTransaction;
