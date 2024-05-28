import { Chapa } from 'chapa-nodejs';
import { Request, Response } from 'express';
import PaymentTransaction from '../models/transaction';
import Ticket from '../models/tickets';
const secretKey = 'CHASECK_TEST-7hqcIQqStVowOXHbAPCOSrhFHuZ7AaRW';

export const tryChapa = async (req: Request, res: Response) => {
  const transaction = {
    firstName: 'tol',
    lastName: 'bb',
    email: 'akshdl@gafs.com',
    amount: 300,
    userId: '664c71c508677fd5c52b6023',
  };
  const resp = await generateTransactionGateway(transaction);
  console.log(resp);
  res.json(resp);
};

export const generateTransactionGateway = async (
  transaction: any
): Promise<any> => {
  try {
    const chapa = new Chapa({
      secretKey: secretKey,
    });
    const tx_ref = await chapa.generateTransactionReference({
      prefix: 'TX',
      size: 20,
    });
    const tranxData = {
      first_name: transaction.firstName,
      last_name: transaction.lastName,
      email: transaction.email,
      currency: 'ETB',
      amount: transaction.amount,
      tx_ref: tx_ref,
      callback_url: 'https://example.com/',
      return_url: 'https://example.com/',
      customization: {
        title: 'Test Title',
        description: 'Test Description',
      },
    };
    const chapa_response = await chapa.mobileInitialize(tranxData);
    if (chapa_response.status === 'success') {
      const paymentTransaction = new PaymentTransaction({
        userId: transaction.userId,
        checkout_url: chapa_response.data.checkout_url,
        tranxRef: tx_ref,
        paymentMethod: 'Chapa mobile',
        status: 'pending',
        amount: transaction.amount,
      });

      await paymentTransaction.save();
      return paymentTransaction;
    } else {
      return 'error';
    }
  } catch (error: any) {
    return error.message || 'An error occurred';
  }
};

export const verifyTransaction = async (transactionId: any): Promise<any> => {
  const transaction = await PaymentTransaction.findById(transactionId);
  if (!transaction) {
    return { error: true, message: 'Ticket not found' };
  }
  const chapa = new Chapa({
    secretKey: secretKey,
  });
  const verifyResponse = await chapa.verify({
    tx_ref: transaction.tranxRef,
  });
  if (
    (verifyResponse.data.status !== 'pending' &&
      verifyResponse.data.status == 'success' &&
      transaction.status === 'pending') ||
    transaction.status === 'failed'
  ) {
    const updateTranx = await PaymentTransaction.findByIdAndUpdate(
      transactionId,
      { status: 'completed' },
      { new: true }
    );

    if (updateTranx?.status === 'completed') {
      const result = await Ticket.updateMany(
        { transactionId: transactionId },
        { status: 'paid' }
      );
      // console.log(result);
      // return result;
    }
    // console.log(updateTranx);
  }

  // console.log(verifyResponse);
  return verifyResponse;
};
