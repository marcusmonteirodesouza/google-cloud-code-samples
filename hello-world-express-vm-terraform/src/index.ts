import {app} from './app';
import {config} from './config';

app.listen(config.port, () => {
  console.log(`Hello, World! app listening on port ${config.port}...`);
});
