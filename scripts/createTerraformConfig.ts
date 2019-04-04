import {
  createNetworkBackend,
  createAcmBackend,
  createBastionBackend,
  createApiBackend,
  createFrontendBackend,
  createRdsBackend,
  createEcrBackend,
  createEcsBackend,
  createFargateBackend
} from "./createBackend";
import createProvider from "./createProvider";
import {
  createAcmTfvars,
  createBastionTfvars,
  createApiTfvars,
  createFrontendTfvars,
  createRdsTfvars,
  createEcsTfvars,
  createFargateTfvars,
  createNetworkTfvars
} from "./createTfvars";
import { isAllowedDeployStage, outputPathList } from "./terraformConfigUtil";

(async () => {
  const deployStage: string = <any>process.env.DEPLOY_STAGE;
  if (!isAllowedDeployStage(deployStage)) {
    return Promise.reject(
      new Error("有効なステージではありません。dev, prod が利用出来ます。")
    );
  }

  await Promise.all([
    createNetworkBackend(deployStage),
    createAcmBackend(deployStage),
    createBastionBackend(deployStage),
    createApiBackend(deployStage),
    createFrontendBackend(deployStage),
    createRdsBackend(deployStage),
    createEcrBackend(deployStage),
    createEcsBackend(deployStage),
    createFargateBackend(deployStage),
    createNetworkTfvars(deployStage),
    createAcmTfvars(deployStage),
    createBastionTfvars(deployStage),
    createApiTfvars(deployStage),
    createFrontendTfvars(deployStage),
    createRdsTfvars(deployStage),
    createEcsTfvars(deployStage),
    createFargateTfvars(deployStage)
  ]);

  const promises = outputPathList().map((dir: string) => {
    return createProvider(deployStage, dir);
  });
  await Promise.all(promises);

  return Promise.resolve();
})().catch((error: Error) => {
  console.error(error);
});
