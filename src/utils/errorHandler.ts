
export class CustomError extends Error {
    statusCode: number;
    status: string;
    isOperational: boolean;
    kind?: string;
    code?:Number;
    _message?:string;
    constructor(message: string, statusCode: number) {
      super(message);
      this.statusCode = statusCode;
      this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
      this.isOperational = true;
  
      Error.captureStackTrace(this, this.constructor);
    }
  }