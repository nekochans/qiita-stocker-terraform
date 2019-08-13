import {
  createNetworkBackend,
  createAcmBackend,
  createIamBackend,
  createBastionBackend,
  createApiBackend,
  createFrontendBackend,
  createRdsBackend,
  createEcrBackend
} from "./createBackend";
import createProvider from "./createProvider";
import {
  createAcmTfvars,
  createBastionTfvars,
  createApiTfvars,
  createFrontendTfvars,
  createRdsTfvars,
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
    createIamBackend(deployStage),
    createBastionBackend(deployStage),
    createApiBackend(deployStage),
    createFrontendBackend(deployStage),
    createRdsBackend(deployStage),
    createEcrBackend(deployStage),
    createNetworkTfvars(deployStage),
    createAcmTfvars(deployStage),
    createBastionTfvars(deployStage),
    createApiTfvars(deployStage),
    createFrontendTfvars(deployStage),
    createRdsTfvars(deployStage)
  ]);

  const promises = outputPathList().map((dir: string) => {
    return createProvider(deployStage, dir);
  });
  await Promise.all(promises);

  return Promise.resolve();
})().catch((error: Error) => {
  console.error(error);
});
