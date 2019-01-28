import {
  createNetworkBackend,
  createAcmBackend,
  createBastionBackend,
  createApiBackend,
  createFrontendBackend,
  createRdsBackend
} from "./createBackend";
import createProvider from "./createProvider";
import {
  createAcmTfvars,
  createBastionTfvars,
  createApiTfvars,
  createFrontendTfvars,
  createRdsTfvars
} from "./createTfvars";
import { outputPathList } from "./terraformConfigUtil";

(async () => {
  const deployStage: string = <any>process.env.DEPLOY_STAGE;

  await createNetworkBackend(deployStage);
  await createAcmBackend(deployStage);
  await createBastionBackend(deployStage);
  await createApiBackend(deployStage);
  await createFrontendBackend(deployStage);
  await createRdsBackend(deployStage);

  const targetDirs = outputPathList();
  targetDirs.forEach(async (dir: string) => {
    await createProvider(deployStage, dir);
  });

  await createAcmTfvars(deployStage);
  await createBastionTfvars(deployStage);
  await createApiTfvars(deployStage);
  await createFrontendTfvars(deployStage);
  await createRdsTfvars(deployStage);
})();
