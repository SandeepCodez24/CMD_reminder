import { Router } from "express";
import * as packageCRUD from "../controllers/packageControllers";
const router = Router();

const PacakgeCRUD = require('../controllers/packageControllers');

router.get('/test', (req, res) => {
     res.json({ message: "Test route working" });
});

router.get('/packages', PacakgeCRUD.getPackage);
router.get('/packages/:id', PacakgeCRUD.getPackageById);
router.post('/packages', PacakgeCRUD.createPackage);
router.put('/packages/:id', PacakgeCRUD.updatePackage);
router.delete('/packages/:id', PacakgeCRUD.deletePackage);


export default router;