# Week 09 — DishPeek with Firebase

DishPeek, my final project, now lives in its own repo:
**https://github.com/Kiaaa-Bai/DishPeek**

For Week 09 Option 1, I used Firebase in DishPeek itself instead of a tutorial app:

- Cloud Functions (`backend/functions/src`) keep the Gemini and Google Places keys off the phone
- When someone shows their order to the server, `recordOrder` adds 1 to each dish in
  Firestore under `places/{restaurant}/dishes/{dish}`
- The next person who scans a menu at the same restaurant sees those counts
- Firestore rules block the app from reading or writing directly; only the functions can

The code was written around 2026-10-26 (it was in `Week08/DishPeek` before, never committed).
