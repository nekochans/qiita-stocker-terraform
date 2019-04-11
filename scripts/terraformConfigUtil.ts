export const terraformVersion = (): string => {
  return "=0.11.13";
};

export const tfstateBucketName = (deployStage: string): string => {
  return `${deployStage}-qiita-stocker-tfstate`;
};

export const tfstateBucketRegion = (): string => {
  return "ap-northeast-1";
};

export const awsProfileName = (deployStage: string) => {
  return `qiita-stocker-${deployStage}`;
};

export const networkOutputPath = (): string => {
  return "./providers/aws/environments/10-network/";
};

export const acmOutputPath = (): string => {
  return "./providers/aws/environments/11-acm/";
};

export const bastionOutputPath = (): string => {
  return "./providers/aws/environments/20-bastion/";
};

export const apiOutputPath = (): string => {
  return "./providers/aws/environments/21-api/";
};

export const frontendOutputPath = (): string => {
  return "./providers/aws/environments/22-frontend/";
};

export const rdsOutputPath = (): string => {
  return "./providers/aws/environments/23-rds/";
};

export const ecrOutputPath = (): string => {
  return "./providers/aws/environments/12-ecr/";
};

export const fargateOutputPath = (): string => {
  return "./providers/aws/environments/26-fargate/";
};

export const outputPathList = (): string[] => {
  return [
    networkOutputPath(),
    acmOutputPath(),
    bastionOutputPath(),
    apiOutputPath(),
    frontendOutputPath(),
    rdsOutputPath(),
    ecrOutputPath(),
    fargateOutputPath()
  ];
};

export const isAllowedDeployStage = (deployStage: string) => {
  return deployStage === "dev" || deployStage === "prod";
};
