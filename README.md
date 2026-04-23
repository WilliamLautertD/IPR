# IPR

IPR is a collection of Bash workflows for microbial genomics analyses, including:

- read quality control and trimming,
- hybrid/long-read assembly and Trycycler-based polishing,
- genome annotation,
- comparative genomics,
- phylogenetic marker extraction and tree construction,
- read mapping and mapping QC.

The repository is script-first and intended for Linux command-line execution in environments where external bioinformatics tools are already installed.

## Repository structure

Most files in this repository are executable workflow scripts (`*.sh`). They can be used independently or chained together as a pipeline.

### Core script groups

- **Quality control / preprocessing**
  - `quality_control.sh`
  - `trimming_QC.sh`
  - `trimming_2_QC.sh`
  - `trimming_QC_Nanopore_Illumina.sh`
- **Assembly / polishing (Trycycler + related steps)**
  - `A_pre_trycycler_assembly.sh`
  - `trycycler_assembly.sh` variants
  - `trycycler_assembly_clustering.sh` variants
  - `trycycler_partition_consensus.sh`
  - `trycycler_reconcile.sh`
  - `trycycler_medaka_polyshing.sh`
  - `trycycler_polishing_polypolish_pypolca.sh`
  - `scaffold.sh`, `montagem.sh`
- **Annotation / secondary metabolism**
  - `annotation_PROKKA.sh`
  - `pgap.sh`
  - `antismash_annotation.sh`
- **Comparative genomics / ANI**
  - `fastANI.sh`
  - `download_ref.sh`
  - `cp_ref_genomes.sh`
- **Phylogeny**
  - `extract_phylo_markers_refs.sh`
  - `aligning_phylogeny.sh`
  - `names_phylogeny.sh`
  - `Raxml_tree.sh`
- **Mapping / mapping QC**
  - `mapping.sh`
  - `Mapping_bowtie_QC.sh`
  - `script_mapping.sh`
  - `script_mapping_parallel.sh`
  - `script_mapping_parallel_BIOSURF_DB.sh`

## Quick start

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd IPR
   ```
2. **Inspect a script before running**
   ```bash
   sed -n '1,200p' quality_control.sh
   ```
3. **Run a workflow script**
   ```bash
   bash quality_control.sh
   ```

> Tip: Several scripts may require editing internal paths, sample names, or tool options before execution.

## Requirements

This repository does not currently include automated dependency management. Ensure your environment provides the tools required by each script (for example, assemblers, mappers, annotation software, and phylogeny tools used in that script).

## Configuration files

- `generic.yaml`
- `metadata.yaml`
- `pathnames.sh`

These files can be used as starting points for pipeline configuration and path management.

## Suggested improvements

If you plan to maintain this repository long-term, consider:

- adding per-script usage blocks (`--help` style comments),
- standardizing input/output directory conventions,
- adding a dependency manifest (Conda environment or container),
- adding a top-level orchestrator script with documented stages.
