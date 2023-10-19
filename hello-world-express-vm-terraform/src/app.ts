import * as express from 'express';
import * as lb from '@google-cloud/logging-bunyan';
import {config} from './config';

async function createApp() {
  const {logger, mw} = await lb.express.middleware({
    logName: config.gcloud.serviceId,
    level: config.logLevel,
    projectId: config.gcloud.projectId,
    redirectToStdout: config.nodeEnv !== 'production',
  });

  const app = express();

  app.use(mw);

  app.get('/', (req, res) => {
    req.log.info(req, 'Request received');
    return res.json({message: 'Hello, World!'});
  });

  return {app, logger};
}

export {createApp};
