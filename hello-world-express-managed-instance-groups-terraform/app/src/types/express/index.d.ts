import * as bunyan from 'bunyan';

export {};

declare global {
  namespace Express {
    export interface Request {
      log: bunyan;
    }
  }
}
