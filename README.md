# LMM_omics_explainability
Xue M Y, Sun H Z, Wu X H, et al. Multi-omics reveals that the rumen microbiome and its metabolome together with the host metabolome contribute to individualized dairy cow performance[J]. Microbiome, 2020, 8: 1-19.这篇文章的Calculation of omics-explainability部分使用的计算贡献度的方法成了香饽饽，遗憾的是，作者并没有提供运行脚本。我在这为大家提供这个脚本，可以直接使用这个方法，但是前提是固定效应（处理）和随机效应（组学）务必互相独立，否则学术原神警告.
1. Random_Effects_Contribution 表
表格内容
grp	var1	var2	vcov	sdcor	Contribution (%)
Feature	(Intercept)		3905.115269	62.49092149	75.83346216
Residual			1244.478536	35.27716734	24.16653784
字段解释
1.	grp：
o	Feature：表示模型中的随机效应，即组学特征（Feature）对表型变异的贡献。
o	Residual：模型未解释的方差，通常称为残差。
2.	vcov（方差）：
o	各随机效应和残差的方差值，表示其对表型变异的绝对贡献。
3.	sdcor（标准差）：
o	方差的平方根，用于描述效应分布的离散程度。
4.	Contribution (%)：
o	每个随机效应和残差的相对贡献，计算公式为： 贡献度=vcov总方差×100\text{贡献度} = \frac{\text{vcov}}{\text{总方差}} \times 100贡献度=总方差vcov×100
解读
•	Feature 的贡献度为 75.83%：
o	表明组学特征对表型变异的主要来源，随机效应捕捉了组学数据中特征对表型的显著影响。
o	生物学意义：组学特征对目标表型（如奶产量）有较大的解释能力。
•	Residual 的贡献度为 24.17%：
o	表明模型未能解释的数据变异。
o	建议：如果残差较高，可能需要引入更多固定效应或调整实验设计来提升模型拟合度。
________________________________________
2. PERMANOVA_Result 表
表格内容
Df	SumOfSqs	R2	F	Pr(>F)
1	0.563738465	0.873773224	69.22249387	0.002
10	0.081438624	0.126226776		
11	0.64517709	1		
字段解释
1.	Df（自由度）：
o	1：表示处理因素（Treatment）的自由度。
o	10：表示残差的自由度。
o	11：总自由度（Df_Treatment + Df_Residual）。
2.	SumOfSqs（平方和）：
o	表示每个因素对距离矩阵变异的平方和。
o	0.5637（处理）：由实验处理解释的距离变异。
o	0.0814（残差）：由其他未解释的因素产生的变异。
3.	R2（解释度）：
o	各因素对总变异的相对贡献，计算公式： R2=SumOfSqsTotal SumOfSqsR^2 = \frac{\text{SumOfSqs}}{\text{Total SumOfSqs}}R2=Total SumOfSqsSumOfSqs
o	0.8738（处理）：实验处理解释了 87.38% 的变异。
o	0.1262（残差）：未解释的变异占 12.62%。
4.	F（F 值）：
o	表示组间方差和组内方差的比值。
o	69.22：处理因素的变异显著大于残差变异。
5.	Pr(>F)（p 值）：
o	用于判断实验处理对组间差异的显著性。
o	0.002：处理因素对变异的贡献具有显著性（p < 0.05）。
解读
•	R2：实验处理解释了 87.38% 的组学距离变异，未解释的残差占 12.62%。
•	F 和 Pr(>F)：F 值较大且 p 值显著（p = 0.002），说明实验处理对组学数据的影响显著。
生物学意义
•	高解释力（R2 = 0.8738）：
o	表明实验处理对组学特征的整体差异具有重要影响。
o	可能原因：实验处理对微生物群或代谢物丰度有直接作用，导致显著组间差异。
•	显著性（Pr(>F) = 0.002）：
o	表明实验处理的影响并非随机效应，具有统计学意义。
________________________________________
整体解读与关联分析
•	模型分析（Random_Effects_Contribution）：
o	线性混合模型结果显示，随机效应（Feature）是表型变异的主要来源。
o	残差较低（24.17%），表明模型已很好拟合数据。
•	显著性分析（PERMANOVA_Result）：
o	PERMANOVA 的结果表明实验处理对组学特征的整体差异有显著贡献（p = 0.002）。
o	R2 和贡献度结果一致，进一步验证了实验处理对目标表型的影响。
