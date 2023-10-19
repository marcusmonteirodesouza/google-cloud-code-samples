import {createApp} from './app';
import {config} from './config';

createApp().then(({app, logger}) => {
  app.listen(config.port, () => {
    logger.info(`Hello, World! app listening on port ${config.port}...`);
  });
});
