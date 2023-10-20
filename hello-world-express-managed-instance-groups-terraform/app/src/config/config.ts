import * as Joi from 'joi';

const envVarsSchema = Joi.object()
  .keys({
    GCLOUD_PROJECT_ID: Joi.string().required(),
    GCLOUD_SERVICE_ID: Joi.string().required(),
    LOG_LEVEL: Joi.string().valid('debug', 'info').required(),
    NODE_ENV: Joi.string()
      .valid('development', 'test', 'production')
      .required(),
    PORT: Joi.number().integer().min(1024).max(49151).required(),
  })
  .unknown();

const {value: envVars, error} = envVarsSchema.validate(process.env);

if (error) {
  throw error;
}

const config = {
  gcloud: {
    projectId: envVars.GCLOUD_PROJECT_ID,
    serviceId: envVars.GCLOUD_SERVICE_ID,
  },
  nodeEnv: envVars.NODE_ENV,
  logLevel: envVars.LOG_LEVEL,
  port: envVars.PORT,
};

export {config};
