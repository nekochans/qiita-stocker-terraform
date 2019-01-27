import { createS3Backend } from "@nekonomokochan/terraform-config-creator";
import {
  awsProfileName,
  terraformVersion,
  tfstateBucketName,
  tfstateBucketRegion
} from "./terraformConfigUtil";

export const createNetworkBackend = async (
  deployStage: string
): Promise<void> => {
  const params = {
    outputPath: "./providers/aws/environments/10-network/",
    backendParams: {
      requiredVersion: terraformVersion(),
      backend: {
        bucket: tfstateBucketName(deployStage),
        key: "network/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    }
  };

  await createS3Backend(params);
};
