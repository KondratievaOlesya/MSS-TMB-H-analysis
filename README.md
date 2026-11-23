# Analysis notebooks

Run the notebooks with the study data arranged under the project root. Python notebooks detect the root from the working directory. R Markdown notebooks use the parent of `scripts/` when rendered. Set `MSS_TMB_PROJECT_ROOT` to use another project root.

R reports use R Markdown and the packages listed in their setup chunks. Python notebooks use a Python 3 Jupyter kernel with the packages imported in their setup cells. The expression alignment additionally requires Broad Institute Celligner and its mnnpy dependency.

| Manuscript result | Notebook and inputs |
| --- | --- |
| Figure 1 and cohort counts | [Prepare CRC counts](prepare_crc_counts.Rmd), then [TCGA expression PCA](tcga_expression_pca.Rmd). Supply the COAD, READ, and UCEC count matrices and clinical annotations. |
| Figure 2 and shared differentially expressed genes | Run [CRC](crc_gene_expression_stability.Rmd) and [UCEC](ucec_gene_expression_stability.Rmd) gene expression first. Use the results in [volcano plots](gene_expression_volcano_plots.Rmd), [gene overlaps](stable_gene_overlaps.Rmd), and [shared gene enrichment](shared_gene_enrichment.Rmd). |
| Figure 3 | [Hallmark pathway activity plots](hallmark_pathway_activity_plots.Rmd) reads the saved CRC and UCEC GSVA bootstrap summary CSVs under `bootstrap_validated_downstream_analysis/results/GSEA_bootstrap/`. |
| Figure 4 and Supplementary Figure 1 | Run [miRNA expression stability](mirna_expression_stability.Rmd), then [shared miRNA expression](shared_mirna_expression.Rmd) and [target enrichment](shared_mirna_target_enrichment.Rmd). Target annotation uses validated multiMiR interactions. |
| Figure 5 | [STRING and miRNA networks](string_mirna_networks.Rmd) generates network tables and panel plots using the gene and miRNA stability results. The final concentric layout is available as an existing figure asset. |
| POLE/POLD1 and pathway results | Generate [CRC](crc_polymerase_pathway_scores.Rmd) and [UCEC](ucec_polymerase_pathway_scores.Rmd) ssGSEA scores, then run [polymerase mutation status](polymerase_mutation_status.Rmd) and [pathway comparisons](polymerase_pathway_analysis.Rmd). Supply the TCGA mutation data and ClinVar annotations. |
| CellHit drug rankings | Run [upload preparation](py/cellhit_prepare_uploads.ipynb) as needed. Place the downloaded prediction CSVs in `data/CellHit/results/` alongside the published prediction inputs in `data/CellHit/`. Run [GDSC cache preparation](py/cellhit_merge_gdsc.ipynb), then [CellHit drug rankings](py/cellhit_rank_drugs.ipynb). |
| Table 2 and cell-line drug associations | Prepare [TCGA log2 TPM](py/prepare_tcga_log2_tpm.ipynb) and run [Celligner alignment](py/celligner_align_expression.ipynb) if an aligned matrix is unavailable. Run [signature drug response](py/signature_drug_response.ipynb) with the aligned expression, gene stability tables, and PRISM, GDSC, and CTRP data. The notebook exports `table_2_cross_cancer_sensitivity.csv` with the numerical results. |

The notebooks start from the supplied TCGA clinical MSI/TMB annotations. The original TMB classification code, the generator for the saved GSVA bootstrap summaries, and the final Figure 5 concentric layout code were unavailable in the source scripts.

For the current manuscript revision, the saved Figure 3 plotting parameters use a 90% tested rate and 80% sign consistency. The Methods specify 95%, 90%, and a bootstrap interval excluding zero. The drug-signature notebook uses the 100 highest-ranked eligible genes per direction, a limit not specified in the Methods.

New CellHit outputs use lowercase filenames. The ranking notebook can also read the legacy GDSC cache. The current GDSC exports lack READ part 01 and UCEC part 03. Rebuild the GDSC cache before regenerating the combined rankings if those exports become available.
