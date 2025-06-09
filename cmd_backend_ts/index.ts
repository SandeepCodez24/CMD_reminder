import express from "express";
import cors from "cors";
import mongoose from "mongoose";
import packageRouters from "./routers/packageRouters";

const app = express();
const port = 3000;


app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

mongoose.connect('mongodb://localhost:27017/CMD_commands')
.then(() => {
    console.log('Connected to MongoDB successfully');
})
.catch((error) => {
    console.error('MongoDB connection error:', error);
});

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'OK', message: 'Server is healthy' });
});

app.use(packageRouters);

app.get('/', (req, res) => {
    res.send('Server is running Updated second time');
});

app.listen(port, '0.0.0.0', () => {
    console.log(`Server is running successfully on port ${port}`);
});