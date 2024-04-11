import { Chapa } from 'chapa-nodejs';
import { Request, Response } from 'express';

const secretKey = 'CHASECK_TEST-7hqcIQqStVowOXHbAPCOSrhFHuZ7AaRW';
export const tryChapa = async (req: Request, res: Response) => {
  const chapa = new Chapa({
    secretKey: secretKey,
  });

  // const tx_ref = await chapa.generateTransactionReference({
  //   prefix: 'TX', // defaults to `TX`
  //   size: 20, // defaults to `15`
  // });
  try {
    const tx_ref = 'kekekedddddd2';
    const response = await chapa.mobileInitialize({
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@gmail.com',
      currency: 'ETB',
      amount: '200',
      tx_ref: tx_ref,
      callback_url: 'https://example.com/',
      return_url: 'https://example.com/',
      customization: {
        title: 'Test Title',
        description: 'Test Description',
      },
    });

    // const response = await chapa.verify({
    //   tx_ref: tx_ref,
    // });
    res.status(200).json(response);
  } catch (error) {
    console.error('Error creating ticket:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
