import {
  createNetworkBackend,
  createAcmBackend,
  createBastionBackend,
  createApiBackend
} from "./createBackend";

(async () => {
  const deployStage: string = <any>process.env.DEPLOY_STAGE;

  await createNetworkBackend(deployStage);
  await createAcmBackend(deployStage);
  await createBastionBackend(deployStage);
  await createApiBackend(deployStage);
})();
