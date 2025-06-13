import express from 'express';
import {
    createCmdPackage,
    getAllCmdPackages,
    getCmdPackage,
    updateCmdPackage,
    deleteCmdPackage,
} from '../Controllers/PakageControllers';

const router = express.Router();

// Create a new package



router.post('/', createCmdPackage);// Get all packages
router.get('/', getAllCmdPackages);

// Get a single package by ID
router.get('/:packageId', getCmdPackage);

// Update a package by ID
router.put('/:packageId', updateCmdPackage);

// Delete a package by ID
router.delete('/:packageId', deleteCmdPackage);

export default router;