import mongoose, { Schema, Document } from 'mongoose';

interface IPaymentTransaction extends Document {
  userId: string;
  amount: number;
  paymentMethod: string;
  status: string;
  checkout_url:string;
  tranxRef:string;
  //
}

const PaymentTransactionSchema = new Schema(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    amount: { type: Number, required: true },
    paymentMethod: { type: String, required: true },
    checkout_url: { type: String, required: true },
    status: {
      type: String,
      enum: ['pending', 'completed', 'failed'],
      default: 'pending',
    },
    tranxRef: { type: String, required: true },
    //
  },
  { timestamps: true }
);

const PaymentTransaction = mongoose.model<IPaymentTransaction>(
  'PaymentTransaction',
  PaymentTransactionSchema
);

export default PaymentTransaction;
