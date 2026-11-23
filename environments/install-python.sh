#!/usr/bin/env bash
set -euo pipefail

if [[ "${CONDA_DEFAULT_ENV:-}" != mss-tmb-python ]]; then
  printf '%s\n' 'Activate mss-tmb-python before running this script.' >&2
  exit 1
fi

setup_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
python -m pip install -r "$setup_dir/python-requirements.txt"

# Use the exact Broad Celligner revision and the mnnpy fork it references.
python -m pip install --no-deps --no-build-isolation \
  'mnnpy @ git+https://github.com/DeKegel/mnnpy.git@bf1dd736f5b8a6b4b571e1ed572e73451162316a' \
  'celligner @ git+https://github.com/broadinstitute/celligner.git@d9c9246f8a1b6885d07f2f28bbdca24253e57cf1'
python -m pip check
python - <<'PYTHON'
import mnnpy
from celligner import Celligner
from rpy2.robjects.packages import importr

importr("limma")
Celligner()
PYTHON
python -m ipykernel install --sys-prefix --name mss-tmb-python --display-name 'Python (MSS/TMB analysis)'
