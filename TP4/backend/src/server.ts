import { app } from './app.js';
import { env } from './config/env.js';

app.listen(env.PORT, () => {
  console.log(`Porto Certo API running on port ${env.PORT}`);
});
