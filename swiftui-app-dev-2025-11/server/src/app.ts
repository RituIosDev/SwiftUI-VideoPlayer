import express, { Response, Request } from 'express';
import cors from 'cors';
import { videos } from './routes/videos';
import { AppError } from './typings/AppError';
import { config } from './config';

// CORS header configuration
const corsOptions = {
  methods: 'GET',
  allowedHeaders: 'Content-Type,Authorization',
};

export const app = express();

app.get('/', cors(corsOptions), (_: Request, res: Response) => {
  res.header('Content-Type', 'text/html');
  res.header('Cache-Control', 'no-store');

  const videoRoute = `http://localhost:${config.server.port}/videos`;

  res.status(200);
  res.send(`You want <a href="${videoRoute}">${videoRoute}</a>`);
});

// Routes
app.use('/videos', cors(corsOptions), videos);

// error handling middleware should be loaded after the loading the routes
app.use('/', (err: AppError, _: Request, res: Response) => {
  const status = err.status ?? 500;

  const formattedError: { status: number; message: string } = {
    status,
    message: err.message,
  };

  res.status(status);
  res.send(JSON.stringify(formattedError));
});
