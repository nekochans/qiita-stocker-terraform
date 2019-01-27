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

(async () => {
  const deployStage: string = <any>process.env.DEPLOY_STAGE;

  await createNetworkBackend(deployStage);
  await createAcmBackend(deployStage);
  await createBastionBackend(deployStage);
  await createApiBackend(deployStage);
  await createFrontendBackend(deployStage);
  await createRdsBackend(deployStage);

  const targetDirs = [
    "./providers/aws/environments/10-network/",
    "./providers/aws/environments/11-acm/",
    "./providers/aws/environments/20-bastion/",
    "./providers/aws/environments/21-api/",
    "./providers/aws/environments/22-frontend/",
    "./providers/aws/environments/23-rds/"
  ];
  targetDirs.forEach(async (dir: string) => {
    await createProvider(deployStage, dir);
  });

  await createAcmTfvars(deployStage);
  await createBastionTfvars(deployStage);
  await createApiTfvars(deployStage);
  await createFrontendTfvars(deployStage);
  await createRdsTfvars(deployStage);
})();
