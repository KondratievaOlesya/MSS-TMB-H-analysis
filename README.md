# Analysis notebooks

## Environment setup

Analysis was on Linux x86-64. Python 3.10 and R 4.5 versions were used to run the notebooks.

```bash
CONDA_CHANNEL_PRIORITY=strict conda env create -f environments/r.yml
CONDA_CHANNEL_PRIORITY=strict conda env create -f environments/python.yml
conda activate mss-tmb-python
bash environments/install-python.sh
```

The Python installer uses pinned revisions of Broad Celligner and its mnnpy fork. The Python environment includes R and limma for Celligner. [Broad Celligner installation documentation](https://github.com/broadinstitute/celligner#install)


| Manuscript result | Notebook and inputs |
| --- | --- |
| Figure 1 and cohort counts | [Prepare CRC counts](scripts/prepare_crc_counts.Rmd), then [TCGA expression PCA](scripts/tcga_expression_pca.Rmd). Supply the COAD, READ, and UCEC count matrices and clinical annotations. |
| Figure 2 and shared differentially expressed genes | After preparing CRC counts, run [CRC](scripts/crc_gene_expression_stability.Rmd) and [UCEC](scripts/ucec_gene_expression_stability.Rmd) gene expression first. Use the results in [volcano plots](scripts/gene_expression_volcano_plots.Rmd), [gene overlaps](scripts/stable_gene_overlaps.Rmd), and [shared gene enrichment](scripts/shared_gene_enrichment.Rmd). |
| Figure 3 | Generate both cohorts’ Hallmark ssGSEA scores with the scoring notebooks below, then run [Hallmark pathway stability](scripts/hallmark_pathway_stability.Rmd) and [Hallmark pathway activity plots](scripts/hallmark_pathway_activity_plots.Rmd). The bootstrap uses stratified patient resampling and limma contrasts. |
| Figure 4 and Supplementary Figure 1 | Run [miRNA expression stability](scripts/mirna_expression_stability.Rmd), then [shared miRNA expression](scripts/shared_mirna_expression.Rmd) and [target enrichment](scripts/shared_mirna_target_enrichment.Rmd). Target enrichment also requires the Figure 2 gene stability tables and uses validated multiMiR interactions. |
| Figure 5 | [STRING and miRNA networks](scripts/string_mirna_networks.Rmd) generates and assembles six network panels. |
| POLE/POLD1 and pathway results | Prepare CRC counts and generate [CRC](scripts/crc_polymerase_pathway_scores.Rmd) and [UCEC](scripts/ucec_polymerase_pathway_scores.Rmd) ssGSEA scores. Run [polymerase mutation status](scripts/polymerase_mutation_status.Rmd) to classify patients from the TCGA MAF and ClinVar, then run [pathway comparisons](scripts/polymerase_pathway_analysis.Rmd) with those classifications. |
| CellHit drug rankings | Run [upload preparation](scripts/py/cellhit_prepare_uploads.ipynb) as needed. Place the downloaded prediction CSVs in `data/CellHit/results/` alongside the published prediction inputs in `data/CellHit/`. Run [GDSC cache preparation](scripts/py/cellhit_merge_gdsc.ipynb), then [CellHit drug rankings](scripts/py/cellhit_rank_drugs.ipynb). |
| Table 2 and cell-line drug associations | Prepare [TCGA log2 TPM](scripts/py/prepare_tcga_log2_tpm.ipynb) and run [Celligner alignment](scripts/py/celligner_align_expression.ipynb). Run [UCEC primary differential expression](scripts/ucec_primary_differential_expression.Rmd) to regenerate the contrasts used in the original drug-signature analysis. Run [signature drug response](scripts/py/signature_drug_response.ipynb) with the aligned expression, gene stability tables, and PRISM, GDSC, and CTRP data. |

## Input files

### TCGA clinical and expression data

| Path | Contents and source |
| --- | --- |
| `data/clinical_data.csv` | Clinical data for TCGA colon and rectal adenocarcinoma (COAD and READ), assembled from GDC records. |
| `data/ucec_clinical.csv` | Clinical data for TCGA uterine corpus endometrial carcinoma (UCEC), assembled from GDC records. |
| `data/coad/count.csv` and `data/read/count.csv` | Raw gene-level RNA-seq count matrices for TCGA-COAD and TCGA-READ, obtained through the GDC portal. |
| `data/UCEC/count_gene_name.csv` | Raw gene-level RNA-seq count matrix for TCGA-UCEC, obtained through GDC and indexed by gene name. |
| `data/miRNA/miRNA_counts_matrix.csv` | miRNA count matrix assembled from GDC data for TCGA-COAD, TCGA-READ, and TCGA-UCEC. The miRNA notebook uses this shared matrix for both analyses. |
| `data/coad/tpm.csv`, `data/read/tpm.csv`, `data/read/row_data.csv`, and `data/UCEC/tpm_gene_name.csv` | GDC-derived gene expression in transcripts per million (TPM) for TCGA-COAD, TCGA-READ, and TCGA-UCEC. The READ `row_data.csv` is the accompanying gene annotation table with Ensembl IDs and gene symbols. |

### CellHit

CellHit web-server exports generated from raw RNA-seq counts. GDSC predictions are log-transformed IC50 values and PRISM predictions are log-fold changes in cell viability.

- The precomputed GDSC and PRISM prediction tables are `data/CellHit/full_results_gdsc.csv` and `data/CellHit/full_results_prism.csv` obtained from [CellHit web](https://cellhit.bioinfolab.sns.it/help/).
- Supplemental predictions were exported separately and saved in `data/CellHit/results/`. Notebooks discover them by the patterns `cellhit_gdsc*.csv`, `cellhit_prism*.csv`, and `gdsc_prism*.csv` as applicable. Preserve the export headers and sample identifiers. The mixed export requires a `dataset` column.
- A new CellHit upload requires GDC raw counts for the samples being submitted.

### Celligner and experimental drug response

We used **DepMap Public 25Q3 (2025)**: **PRISM secondary screening**, **GDSC1**, **GDSC2**, and **CTRP v2** as the drug-response sources.

| Path | Contents and source |
| --- | --- |
| `data/OmicsExpressionTPMLogp1HumanProteinCodingGenes.csv` | DepMap Public 25Q3 log-transformed TPM for protein-coding genes across cancer cell lines. |
| `data/Model.csv` | DepMap Public 25Q3 model metadata, including cell-line identifiers and lineage annotations. |
| `data/secondary-screen-dose-response-curve-parameters.csv` | Broad PRISM secondary-screen dose-response fits, including cell-line and compound identifiers and area under the dose-response curve (AUC). |
| `data/secondary-screen-replicate-collapsed-treatment-info.csv` | Broad PRISM secondary-screen treatment metadata, including compound identifiers, names, and annotations. |
| `data/GDSC/GDSC1_fitted_dose_response_27Oct23.xlsx` and `data/GDSC/GDSC2_fitted_dose_response_27Oct23.xlsx` | Fitted dose-response data from the Genomics of Drug Sensitivity in Cancer GDSC1 and GDSC2 screens. |
| `data/GDSC/screened_compounds_rel_8.5.csv` | GDSC release 8.5 compound metadata, including drug names and targets where available. |
| `data/CTRP/v20.data.curves_post_qc.txt`, `data/CTRP/v20.meta.per_experiment.txt`, `data/CTRP/v20.meta.per_cell_line.txt`, and `data/CTRP/v20.meta.per_compound.txt` | CTRP v2 dose-response curves and experiment, cell-line, and compound metadata. |

### Mutation and annotation resources

- The mutation notebook downloads open-access masked somatic mutations for TCGA-COAD, TCGA-READ, and TCGA-UCEC from GDC using the Aliquot Ensemble Somatic Variant Merging and Masking workflow. It also retrieves the GRCh38 ClinVar VCF and tabix index from NCBI.
- The pathway and network notebooks use human Hallmark gene sets from MSigDB. The network notebook uses human STRING v11.5 interactions. The miRNA and enrichment notebooks query multiMiR and g:Profiler.

## Generated outputs for the paper

| Manuscript result | Generated output paths |
| --- | --- |
| Figure 1 and cohort counts | `bootstrap_validated_downstream_analysis/global_expression_HVG_PCA_tSNE_UMAP/plots/` and `bootstrap_validated_downstream_analysis/global_expression_HVG_PCA_tSNE_UMAP/tables/` |
| Figure 2 and shared differential expression | `bootstrap_validated_downstream_analysis/volcano_bootstrap_status/`, `bootstrap_validated_downstream_analysis/results/figures/DEG/`, and `bootstrap_validated_downstream_analysis/gSCS_shared_enrichment/` |
| Figure 3 and Hallmark pathway contrasts | `bootstrap_validated_downstream_analysis/Hallmark_GSVA_three_contrast_stability/` |
| Figure 4 and Supplementary Figure 1 | `bootstrap_validated_miRNA_analysis/results/figures/`, `bootstrap_validated_miRNA_analysis/bootstrap_validated_pre_mirna_results_crc_ucec.xlsx`, and `bootstrap_validated_downstream_analysis/shared_6_miRNA_pathway_analysis/` |
| Figure 5 network panels and data | `bootstrap_validated_downstream_analysis/STRING_shared_pre_miRNA_strong_multiMiR_styled/individual_panels/`, `bootstrap_validated_downstream_analysis/STRING_shared_pre_miRNA_strong_multiMiR_styled/combined_figure/`, and `bootstrap_validated_downstream_analysis/STRING_shared_pre_miRNA_strong_multiMiR_styled/tables/` |
| POLE/POLD1 variant and cohort summaries | `pole_pold1_results/TCGA_COAD_READ_UCEC_POLE_POLD1_variants.csv` and `pole_pold1_results/TCGA_COAD_READ_UCEC_polymerase_status_summary.csv` |
| POLE/POLD1 pathway comparisons | `data/pole_pold1_pathway_analysis/figures/`, `data/pole_pold1_pathway_analysis/tables/`, and `data/pole_pold1_pathway_analysis/polymerase_cross_group_analysis/` |
| CellHit rankings and supporting analyses | `data/CellHit/cellhit_gdsc_prism_rankings/all_six_rankings_cellhit.csv`, `data/CellHit/cellhit_gdsc_prism_rankings/top_drugs_patient_bootstrap.csv`, and `data/CellHit/cellhit_gdsc_prism_rankings/posthoc_known_drug_ranks.csv` |
| Table 2 and cell-line drug associations | `data/celligner_mss_tmbh_pan_cancer_screen/direct_transcriptomic_signature_bootstrap_stable/table_2_cross_cancer_sensitivity.csv` and the supporting association tables in the same directory |
