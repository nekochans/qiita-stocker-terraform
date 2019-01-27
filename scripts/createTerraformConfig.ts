import {
  createNetworkBackend,
  createAcmBackend,
  createBastionBackend
} from "./createBackend";

(async () => {
  const deployStage: string = <any>process.env.DEPLOY_STAGE;

  await createNetworkBackend(deployStage);
  await createAcmBackend(deployStage);
  await createBastionBackend(deployStage);
})();
