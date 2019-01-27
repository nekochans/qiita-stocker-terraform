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

export const createAcmBackend = async (deployStage: string): Promise<void> => {
  const params = {
    outputPath: "./providers/aws/environments/11-acm/",
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
    outputPath: "./providers/aws/environments/20-bastion/",
    backendParams: {
      requiredVersion: terraformVersion(),
      backend: {
        bucket: tfstateBucketName(deployStage),
        key: "bastion/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    },
    remoteStateList: [
      {
        name: "network",
        bucket: tfstateBucketName(deployStage),
        key: "env:/${terraform.env}/network/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    ]
  };

  await createS3Backend(params);
};

export const createApiBackend = async (deployStage: string): Promise<void> => {
  const params = {
    outputPath: "./providers/aws/environments/21-api/",
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
      {
        name: "network",
        bucket: tfstateBucketName(deployStage),
        key: "env:/${terraform.env}/network/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      },
      {
        name: "bastion",
        bucket: tfstateBucketName(deployStage),
        key: "env:/${terraform.env}/bastion/terraform.tfstate",
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
    outputPath: "./providers/aws/environments/22-frontend/",
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
        key: "env:/${terraform.env}/acm/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    ]
  };

  await createS3Backend(params);
};

export const createRdsBackend = async (deployStage: string): Promise<void> => {
  const params = {
    outputPath: "./providers/aws/environments/23-rds/",
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
      {
        name: "network",
        bucket: tfstateBucketName(deployStage),
        key: "env:/${terraform.env}/network/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      },
      {
        name: "api",
        bucket: tfstateBucketName(deployStage),
        key: "env:/${terraform.env}/api/terraform.tfstate",
        region: tfstateBucketRegion(),
        profile: awsProfileName(deployStage)
      }
    ]
  };

  await createS3Backend(params);
};
