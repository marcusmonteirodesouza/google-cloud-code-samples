import * as Joi from 'joi';

const envVarsSchema = Joi.object()
  .keys({
    PORT: Joi.number().integer().min(1024).max(49151).required(),
  })
  .unknown();

const {value: envVars, error} = envVarsSchema.validate(process.env);

if (error) {
  throw error;
}

const config = {
  port: envVars.PORT,
};

export {config};
