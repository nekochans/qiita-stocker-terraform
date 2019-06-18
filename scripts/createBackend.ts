import { createS3Backend } from "@nekonomokochan/terraform-config-creator";
import {
  acmOutputPath,
  apiOutputPath,
  awsProfileName,
  bastionOutputPath,
  frontendOutputPath,
  networkOutputPath,
  rdsOutputPath,
  ecrOutputPath,
  terraformVersion,
  tfstateBucketName,
  tfstateBucketRegion
} from "./terraformConfigUtil";

export const createNetworkBackend = async (
  deployStage: string
): Promise<void> => {
  const params = {
    outputPath: networkOutputPath(),
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

export const createAcmBackend = async (deployStage: string): Promise<void> => {
  const params = {
    outputPath: acmOutputPath(),
    backendParams: {
      requiredVersion: terraformVersion(),
      backend: {
        bucket: tfstateBucketName(deployStage),
        key: "acm/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    }
  };

  await createS3Backend(params);
};

export const createBastionBackend = async (
  deployStage: string
): Promise<void> => {
  const params = {
    outputPath: bastionOutputPath(),
    backendParams: {
      requiredVersion: terraformVersion(),
      backend: {
        bucket: tfstateBucketName(deployStage),
        key: "bastion/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    },
    remoteStateList: [networkRemoteState(deployStage)]
  };

  await createS3Backend(params);
};

export const createApiBackend = async (deployStage: string): Promise<void> => {
  const params = {
    outputPath: apiOutputPath(),
    backendParams: {
      requiredVersion: terraformVersion(),
      backend: {
        bucket: tfstateBucketName(deployStage),
        key: "api/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    },
    remoteStateList: [
      networkRemoteState(deployStage),
      {
        name: "bastion",
        bucket: tfstateBucketName(deployStage),
        key: "env:/${terraform.workspace}/bastion/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      },
      {
        name: "ecr",
        bucket: tfstateBucketName(deployStage),
        key: "env:/${terraform.workspace}/ecr/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    ]
  };

  await createS3Backend(params);
};

export const createFrontendBackend = async (
  deployStage: string
): Promise<void> => {
  const params = {
    outputPath: frontendOutputPath(),
    backendParams: {
      requiredVersion: terraformVersion(),
      backend: {
        bucket: tfstateBucketName(deployStage),
        key: "frontend/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    },
    remoteStateList: [
      {
        name: "acm",
        bucket: tfstateBucketName(deployStage),
        key: "env:/${terraform.workspace}/acm/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    ]
  };

  await createS3Backend(params);
};

export const createRdsBackend = async (deployStage: string): Promise<void> => {
  const params = {
    outputPath: rdsOutputPath(),
    backendParams: {
      requiredVersion: terraformVersion(),
      backend: {
        bucket: tfstateBucketName(deployStage),
        key: "rds/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    },
    remoteStateList: [
      networkRemoteState(deployStage),
      {
        name: "api",
        bucket: tfstateBucketName(deployStage),
        key: "env:/${terraform.workspace}/api/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    ]
  };

  await createS3Backend(params);
};

export const createEcrBackend = async (deployStage: string): Promise<void> => {
  const params = {
    outputPath: ecrOutputPath(),
    backendParams: {
      requiredVersion: terraformVersion(),
      backend: {
        bucket: tfstateBucketName(deployStage),
        key: "ecr/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    }
  };

  await createS3Backend(params);
};

const networkRemoteState = (deployStage: string) => {
  return {
    name: "network",
    bucket: tfstateBucketName(deployStage),
    key: "env:/${terraform.workspace}/network/terraform.tfstate",
    region: tfstateBucketRegion(),
    profile: awsProfileName(deployStage)
  };
};
