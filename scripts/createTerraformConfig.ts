import { createNetworkBackend } from "./createBackend";

(async () => {
  const deployStage: string = <any>process.env.DEPLOY_STAGE;

  await createNetworkBackend(deployStage);
})();
