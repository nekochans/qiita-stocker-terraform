export const terraformVersion = (): string => {
  return "=0.11.10";
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
