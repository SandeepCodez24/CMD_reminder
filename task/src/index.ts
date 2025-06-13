import * as dotenv from 'dotenv';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import connectToDatabase from '../src/Helpers/dBconnector';
import packageRouter from './Routers/PackageRouter';

dotenv.config();

if (!process.env.PORT || !process.env.MONGO_URI) {
    console.error("PORT or MONGO_URI not set in environment variables.");
    process.exit(1);
}

const PORT = process.env.PORT || 7000;
const MONGO_URI = process.env.MONGO_URI;

const app = express();
app.use(cors());
app.use(helmet());
app.use(express.json());

// Connect to MongoDB
connectToDatabase(MONGO_URI);

// Routers
app.use('/api/packages', packageRouter);

app.get('/', (req, res) => {
    res.send('Server is Running!');
});

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok' });
});

app.get('/api', (req, res) => {
    res.status(200).json({ message: 'API is working!' });
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});