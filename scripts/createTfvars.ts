import {
  AwsRegion,
  createEnvFile,
  EnvFileType
} from "@nekonomokochan/aws-env-creator";
import { awsProfileName } from "./terraformConfigUtil";

const secretIds = (deployStage: string) => {
  return [`${deployStage}/qiita-stocker-terraform`];
};

export const createNetworkTfvars = async (
  deployStage: string
): Promise<void> => {
  const params = {
    region: AwsRegion.ap_northeast_1,
    profile: awsProfileName(deployStage),
    type: EnvFileType.terraform,
    outputDir: "./providers/aws/environments/10-network/",
    secretIds: secretIds(deployStage),
    outputWhitelist: ["SSH_PUBLIC_KEY_PATH"],
    keyMapping: {
      SSH_PUBLIC_KEY_PATH: "ssh_public_key_path"
    }
  };

  await createEnvFile(params);
};

export const createAcmTfvars = async (deployStage: string): Promise<void> => {
  const params = {
    region: AwsRegion.ap_northeast_1,
    profile: awsProfileName(deployStage),
    type: EnvFileType.terraform,
    outputDir: "./providers/aws/environments/11-acm/",
    secretIds: secretIds(deployStage),
    outputWhitelist: ["MAIN_DOMAIN_NAME"],
    keyMapping: {
      MAIN_DOMAIN_NAME: "main_domain_name"
    }
  };

  await createEnvFile(params);
};

export const createBastionTfvars = async (
  deployStage: string
): Promise<void> => {
  const params = {
    region: AwsRegion.ap_northeast_1,
    profile: awsProfileName(deployStage),
    type: EnvFileType.terraform,
    outputDir: "./providers/aws/environments/20-bastion/",
    secretIds: secretIds(deployStage),
    outputWhitelist: ["SSH_PUBLIC_KEY_PATH"],
    keyMapping: {
      SSH_PUBLIC_KEY_PATH: "ssh_public_key_path"
    }
  };

  await createEnvFile(params);
};

export const createApiTfvars = async (deployStage: string): Promise<void> => {
  const params = {
    region: AwsRegion.ap_northeast_1,
    profile: awsProfileName(deployStage),
    type: EnvFileType.terraform,
    outputDir: "./providers/aws/environments/21-api/",
    secretIds: secretIds(deployStage),
    outputWhitelist: ["MAIN_DOMAIN_NAME"],
    keyMapping: {
      MAIN_DOMAIN_NAME: "main_domain_name"
    }
  };

  await createEnvFile(params);
};

export const createFrontendTfvars = async (
  deployStage: string
): Promise<void> => {
  const params = {
    region: AwsRegion.ap_northeast_1,
    profile: awsProfileName(deployStage),
    type: EnvFileType.terraform,
    outputDir: "./providers/aws/environments/22-frontend/",
    secretIds: secretIds(deployStage),
    outputWhitelist: ["MAIN_DOMAIN_NAME"],
    keyMapping: {
      MAIN_DOMAIN_NAME: "main_domain_name"
    }
  };

  await createEnvFile(params);
};

export const createRdsTfvars = async (deployStage: string): Promise<void> => {
  const params = {
    region: AwsRegion.ap_northeast_1,
    profile: awsProfileName(deployStage),
    type: EnvFileType.terraform,
    outputDir: "./providers/aws/environments/23-rds/",
    secretIds: secretIds(deployStage),
    outputWhitelist: ["RDS_MASTER_USERNAME", "RDS_MASTER_PASSWORD"],
    addParams: {
      rds_local_master_domain_name: "qiita-stocker-db"
    },
    keyMapping: {
      RDS_MASTER_USERNAME: "rds_master_username",
      RDS_MASTER_PASSWORD: "rds_master_password"
    }
  };

  await createEnvFile(params);
};
