import { Request, Response } from 'express';
import Package, { validatePackage } from '../models/packageModel';

// Controller functions for Package CRUD operations
export const createPackage = async (req: Request, res: Response) => {
  const { error } = validatePackage(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const packagep = new Package({
    vendorId: req.body.vendorId,
    name: req.body.name,
    description: req.body.description,
    price: req.body.price,
    includedServices: req.body.includedServices,
  });

  try {
    const savedPackage = await packagep.save();
    res.status(201).json(savedPackage);
  } catch (err) {
    res.status(500).send(err);
  }
};

export const getAllPackages = async (req: Request, res: Response) => {
  try {
    const packages = await Package.find();
    res.json(packages);
  } catch (err) {
    res.status(500).send(err);
  }
};

export const getPackageById = async (req: Request, res: Response) => {
  try {
    const packagep = await Package.findById(req.params.id);
    if (!packagep) return res.status(404).send('Package not found');
    res.json(packagep);
  } catch (err) {
    res.status(500).send(err);
  }
};

export const updatePackageById = async (req: Request, res: Response) => {
  const { error } = validatePackage(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  try {
    const updatedPackage = await Package.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedPackage) return res.status(404).send('Package not found');
    res.json(updatedPackage);
  } catch (err) {
    res.status(500).send(err);
  }
};

export const deletePackageById = async (req: Request, res: Response) => {
  try {
    const deletedPackage = await Package.findByIdAndDelete(req.params.id);
    if (!deletedPackage) return res.status(404).send('Package not found');
    res.json(deletedPackage);
  } catch (err) {
    res.status(500).send(err);
  }
};
