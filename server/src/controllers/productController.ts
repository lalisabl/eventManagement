import { Request, Response } from 'express';
import Product, { validateProduct } from '../models/products';
import { User, UserDocument } from '../models/user';
// Controller functions for Product CRUD operations

// Create a new product
export const createProduct = async (req: Request, res: Response) => {
  const { name, description, price } = req.body;

  // Ensure user is authenticated
  if (!req.user || !(req.user as UserDocument)._id) {
    return res.status(401).json({ message: 'User not authenticated' });
  }

  // Convert vendorId to string
  const vendorId = (req.user as UserDocument)._id.toString();

  console.log('VendorId:', vendorId); // Debug log

  // Validate the extracted fields
  const { error } = validateProduct({
    vendorId,
    name,
    description,
    price,
    productImage: req.file?.path,
  });

  if (error) {
    return res
      .status(400)
      .send(error.details.map((detail) => detail.message).join(', '));
  }

  const productData = {
    vendorId: vendorId,
    name,
    description,
    price,
    productImage: req.file ? req.file.path : '',
  };

  try {
    const product = new Product(productData);
    const savedProduct = await product.save();
    res.status(201).json({
      status: 'success',
      product: savedProduct,
      message: 'Product created successfully',
    });
  } catch (err) {
    res.status(500).send('Unable to create a product');
  }
};

// Get all products
export const getAllProducts = async (req: Request, res: Response) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (err) {
    res.status(500).send(err);
  }
};

// Get a product by ID
export const getProductById = async (req: Request, res: Response) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).send('Product not found');
    res.json(product);
  } catch (err) {
    res.status(500).send(err);
  }
};

// Update a product by ID
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

// Delete a product by ID
export const deleteProductById = async (req: Request, res: Response) => {
  try {
    const deletedProduct = await Product.findByIdAndDelete(req.params.id);
    if (!deletedProduct) return res.status(404).send('Product not found');
    res.json(deletedProduct);
  } catch (err) {
    res.status(500).send(err);
  }
};
