import { Request, Response } from 'express';
import Product, { validateProduct } from '../models/products';

// Controller functions for Product CRUD operations
export const createProduct = async (req: Request, res: Response) => {
  const { error } = validateProduct(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const product = new Product({
    vendorId: req.body.vendorId,
    name: req.body.name,
    description: req.body.description,
    price: req.body.price,
    contactInformation: req.body.contactInformation,
  });

  try {
    const savedProduct = await product.save();
    res.status(201).json(savedProduct);
  } catch (err) {
    res.status(500).send('unable to create a product');
  }
};

export const getAllProducts = async (req: Request, res: Response) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (err) {
    res.status(500).send(err);
  }
};

export const getProductById = async (req: Request, res: Response) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).send('Product not found');
    res.json(product);
  } catch (err) {
    res.status(500).send(err);
  }
};

export const updateProductById = async (req: Request, res: Response) => {
  const { error } = validateProduct(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  try {
    const updatedProduct = await Product.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedProduct) return res.status(404).send('Product not found');
    res.json(updatedProduct);
  } catch (err) {
    res.status(500).send(err);
  }
};

export const deleteProductById = async (req: Request, res: Response) => {
  try {
    const deletedProduct = await Product.findByIdAndDelete(req.params.id);
    if (!deletedProduct) return res.status(404).send('Product not found');
    res.json(deletedProduct);
  } catch (err) {
    res.status(500).send(err);
  }
};
