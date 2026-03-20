import pandas as pd
from pathlib import Path
import re

# ==============================================================
# SETTINGS
# ==============================================================

input_file = "/Users/chelseanguyen/Desktop/Riboseq/counts/Both_cds.xlsx"

regions = {
    "cds":  "/Users/chelseanguyen/Desktop/Riboseq/deltaTE/cds/Comparisons"
}

comparisons = [
    "Xrp1_vs_RpS12",
    "Xrp1_vs_RpS3",
    "Xrp1_vs_RpS12_RpS3",
    "Xrp1_vs_RpS3_Xrp1"
]

# ==============================================================
# HELPER FUNCTIONS
# ==============================================================

def clean_ids(series):
    return series.astype(str).str.strip().str.upper().str.replace(r"\.\d+$", "", regex=True)

def filter_columns(df, sample1, sample2, mode):
    """
    Keep only Geneid + columns that begin with sample1_ or sample2_.
    Ensures we don't pick up overlapping genotypes like RpS3_Xrp1.
    """
    pattern1 = fr"^{sample1}_[A-Z]_({mode})$"
    pattern2 = fr"^{sample2}_[A-Z]_({mode})$"
    cols = [
        c for c in df.columns
        if c == "Geneid" or
        re.match(fr"^{sample1}_[A-Z]_({mode})$", c) or
        re.match(fr"^{sample2}_[A-Z]_({mode})$", c)
    ]
    df_filtered = df[cols].copy()
    df_filtered = df_filtered.rename(columns={df_filtered.columns[0]: "Geneid"})
    return df_filtered

def make_sample_info(columns):
    rows = []
    for col in columns:
        seqtype = "RIBO" if col.endswith("_Ribo") else "RNA"
        condition = re.sub(r"_[A-Z]_Ribo$|_[A-Z]_RNA$", "", col)
        rows.append({"Sample ID": col, "Condition": condition, "SeqType": seqtype})
    df = pd.DataFrame(rows)
    df["Condition_sort"] = df["Condition"].apply(lambda x: 0 if "Xrp1" in x else 1)
    df = df.sort_values(["SeqType", "Condition_sort", "Condition", "Sample ID"]).drop(columns="Condition_sort")
    return df.reset_index(drop=True)

# ==============================================================
# LOAD SHEETS
# ==============================================================

sheets = pd.read_excel(input_file, sheet_name=None)
sheets = {k.strip().lower(): v for k, v in sheets.items()}

# ==============================================================
# MAIN LOOP
# ==============================================================

for region, outdir in regions.items():
    ribo_key = f"riboseq_{region}"
    rna_key = f"rnaseq_{region}"

    if ribo_key not in sheets or rna_key not in sheets:
        print(f"⚠️ Missing sheets for {region}, skipping.")
        continue

    ribo_df = sheets[ribo_key].copy()
    rna_df = sheets[rna_key].copy()
    ribo_df.columns = ribo_df.columns.str.strip()
    rna_df.columns = rna_df.columns.str.strip()

    output_base = Path(outdir)
    output_base.mkdir(parents=True, exist_ok=True)

    for comp in comparisons:
        sample1, sample2 = comp.split("_vs_")

        comp_path = output_base / comp
        comp_path.mkdir(parents=True, exist_ok=True)

        ribo_filtered = filter_columns(ribo_df, sample1, sample2, mode="Ribo")
        rna_filtered = filter_columns(rna_df, sample1, sample2, mode="RNA")

        ribo_filtered["Geneid"] = clean_ids(ribo_filtered["Geneid"])
        rna_filtered["Geneid"] = clean_ids(rna_filtered["Geneid"])

        common_genes = sorted(set(ribo_filtered["Geneid"]) & set(rna_filtered["Geneid"]))
        if not common_genes:
            print(f"⚠️ No overlapping Geneids for {comp} in {region}")
            continue

        ribo_filtered = ribo_filtered[ribo_filtered["Geneid"].isin(common_genes)]
        rna_filtered = rna_filtered[rna_filtered["Geneid"].isin(common_genes)]
        rna_filtered = rna_filtered.set_index("Geneid").loc[ribo_filtered["Geneid"]].reset_index()

        # Save outputs
        ribo_out = comp_path / "RiboSeq.txt"
        rna_out = comp_path / "RNASeq.txt"
        ribo_filtered.to_csv(ribo_out, sep="\t", index=False)
        rna_filtered.to_csv(rna_out, sep="\t", index=False)

        all_samples = [c for c in ribo_filtered.columns if c != "Geneid"] + \
                      [c for c in rna_filtered.columns if c != "Geneid"]
        sample_info = make_sample_info(all_samples)
        sample_info_out = comp_path / "sample_info.txt"
        sample_info.to_csv(sample_info_out, sep="\t", index=False)

        print(f"✅ {region} | {comp}: {len(common_genes)} genes saved")
        print(f"   → {ribo_out}")
        print(f"   → {rna_out}")
        print(f"   → {sample_info_out}")
