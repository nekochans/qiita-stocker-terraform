import { createAwsProvider } from "@nekonomokochan/terraform-config-creator";
import { awsProfileName } from "./terraformConfigUtil";

const createProvider = async (
  deployStage: string,
  outputPath: string
): Promise<void> => {
  const region =
    outputPath === "./providers/aws/environments/11-acm/"
      ? "us-east-1"
      : "ap-northeast-1";
  const params = {
    outputPath,
    awsProviderParams: [
      {
        version: "=1.49.0",
        region,
        profile: awsProfileName(deployStage)
      }
    ]
  };

  return await createAwsProvider(params);
};

export default createProvider;
