import express, { Request, Response } from "express";

const app = express();

// Middleware
app.use(express.json());

// Example routes
app.get("/", (req: Request, res: Response) => {
  res.send("Welcome to the Node.js TypeScript API!");
});

app.get("/flux", (req: Request, res: Response) => {
  res.send(
    "Welcome to the Node.js TypeScript API deployed using Flux!!!!!!!!!!!!!",
  );
});

app.get("/bonus", (req: Request, res: Response) => {
  res.send("Bonus~~~");
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

export default app;
