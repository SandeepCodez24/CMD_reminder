import express, { Request, Response } from "express";
import PackageDetails from "../models/Package";

export class PackageCurd {
    static async  getPackage(req: Request, res: Response)  {
        try {
            const packages = await PackageDetails.find();
            res.json(packages);
        } catch (error: any) {
            res.status(500).json({ error: 'Internal Server Error', message: error.message });
        }
    }

    static async getPackageById(req: Request, res: Response) {
        try {
            const packageId = req.params.id;
            const packageItem = await PackageDetails.findById(packageId);
            if (packageItem) {
                res.json(packageItem);
            } else {
                res.status(404).json({ error: 'Package not found' });
            }
        } catch (error: any) {
            res.status(500).json({ error: 'Internal Server Error', message: error.message });
        }
    }

    static async createPackage(req: Request, res: Response) {
        try {
            const { packageName, packageVersion, packageDescription, packageDate, packageCode, commandType } = req.body;
            if (!packageName || !packageVersion || !packageDescription || !packageDate || !packageCode || !commandType) {
                return res.status(400).json({ 
                    error: 'Missing required fields', 
                    required: ['packageName', 'packageVersion', 'packageDescription', 'packageDate', 'packageCode', 'commandType']
                });
            }
            const newPackage = await PackageDetails.create(req.body);
            res.status(201).json(newPackage);
        } catch (error: any) {
            res.status(500).json({ error: 'Error creating package', message: error.message });
        }
    }

    static async updatePackage(req: Request, res: Response) {
        try {
            const result = await PackageDetails.updateOne(
                { _id: req.params.id },
                req.body,
                { runValidators: true }
            );
            if (result.matchedCount === 0) {
                return res.status(404).json({ error: 'Package not found' });
            }
            const updatedPackage = await PackageDetails.findById(req.params.id);
            res.status(200).json(updatedPackage);
        } catch (error: any) {
            res.status(500).json({ error: 'Error updating package', message: error.message });
        }
    }

    static async deletePackage(req: Request, res: Response) {
        try {
            const result = await PackageDetails.deleteOne({ _id: req.params.id });
            if (result.deletedCount === 0) {
                return res.status(404).json({ error: 'Package not found' });
            }
            res.status(200).json({ message: 'Package deleted successfully', packageId: req.params.id });
        } catch (error: any) {
            if (error.name === 'CastError') {
                return res.status(400).json({ error: 'Invalid package ID format' });
            }
            res.status(500).json({ error: 'Error deleting package', message: error.message });
        }
    }
};

export const getPackage = PackageCurd.getPackage;
export const getPackageById = PackageCurd.getPackageById;
export const createPackage = PackageCurd.createPackage;
export const updatePackage = PackageCurd.updatePackage;
export const deletePackage = PackageCurd.deletePackage;