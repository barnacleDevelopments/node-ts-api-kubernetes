import express, { Request, Response } from "express";
const app = express();

// Middleware
app.use(express.json());

app.get("/", (req: Request, res: Response) => {
  res.send("Welcome to the Node.js TypeScript API!");
});

app.get("/flux-2", (req: Request, res: Response) => {
  res.send("Welcome to the Node.js Flux API!");
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

export default app;
