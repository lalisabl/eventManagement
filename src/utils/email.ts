// const nodemailer=require ("nodemailer");
import nodemailer from "nodemailer";
export const sendEmail = async (options:any) => {
  // 1) Create a transporter
  const transporter = nodemailer.createTransport({
    service: process.env.email_Host,
    port: Number(process.env.email_Port),
    auth: {
      user: process.env.email_Username,
      pass: process.env.email_Password,
    },
  });
  // 2) Define the email options
  const mailOptions = {
    from: "Lalisa-Bula<lalisa011@.com>",
    to: options.email,
    subject: options.subject,
    text: options.message,
    // html:
  };
  // 3) Actually send the email
  transporter.sendMail(mailOptions, (err, info) => {
        if (err) {
            console.log(err);
        }
        console.log(info);
    });
    
};

