import app from './app';
import { env } from './config/env';

const PORT = env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 StudySync API server running on port ${PORT}`);
  console.log(`📱 Frontend URL: ${env.FRONTEND_URL}`);
  console.log(`🌍 Environment: ${env.NODE_ENV}`);
});
