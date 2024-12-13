# 加载必要的包
library(readxl)    # 读取Excel文件
library(tidyr)     # 数据转换
library(dplyr)     # 数据操作
library(lme4)      # 构建混合模型
library(vegan)     # PERMANOVA分析
library(writexl)   # 导出Excel文件

# Step 1: 加载数据 ----
# 加载表型数据
phenotype_data <- read_excel("PHENOTYPE.xlsx")

# 加载组学数据（单个组学）
omics_file <- "LIVER_GENE.xlsx"  # 修改为当前组学文件
omics_data <- read_excel(omics_file)

# Step 2: 数据预处理 ----
# 替换分号为小数点并转换为数值
omics_data <- omics_data %>%
  mutate(across(-c(Sample_ID, group), ~ as.numeric(gsub(";", ".", .))))

# 确保 `group` 列存在，并重命名为 `Treatment`
omics_data <- omics_data %>%
  rename(Treatment = group)

# 转换为长表格格式
omics_long <- omics_data %>%
  pivot_longer(-c(Sample_ID, Treatment), names_to = "Feature", values_to = "Value") %>%
  left_join(phenotype_data, by = "Sample_ID")

# Step 3: 线性混合模型（LMM） ----
# 构建LMM模型
model_lmm <- lmer(Value ~ Treatment + (1|Feature), data = omics_long)

# 提取随机效应方差
random_effects_variance <- as.data.frame(VarCorr(model_lmm))

# 计算总方差
total_variance <- sum(random_effects_variance$vcov)

# 计算每个随机效应的贡献度
random_effects_variance <- random_effects_variance %>%
  mutate(Contribution = vcov / total_variance * 100)

# Step 4: 显著性检验（PERMANOVA） ----
# 确保选取的是数值列，排除 Sample_ID 和 Treatment 列
distance_matrix <- vegdist(omics_data %>% select(-Sample_ID, -Treatment), method = "bray")

# 使用 PERMANOVA 分析
permanova_result <- adonis2(distance_matrix ~ Treatment, data = omics_data, permutations = 999)

# Step 5: 导出结果 ----
# 导出随机效应贡献和显著性检验结果
write_xlsx(list(
  Random_Effects_Contribution = random_effects_variance,
  PERMANOVA_Result = as.data.frame(permanova_result)
), "Omics_Analysis_Result.xlsx")

# 提示用户
cat("分析结果已保存到 'Omics_Analysis_Result.xlsx'。\n")
