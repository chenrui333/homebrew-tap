# ls-hpack Formula Plan

## Goal
Create/refine `Formula/ls-hpack.rb` in this tap so it is clean, maintainable, and validated.

## Scope
- Work only on `Formula/ls-hpack.rb` and this plan doc.
- Do not touch unrelated formulae.

## Step Plan

### Step 1: Baseline Inspection
- Verify current formula contents and metadata.
- Verify upstream release/tag source and checksum strategy.
- Identify missing pieces (test block, install paths, style issues).

### Step 2: Formula Refinement
- Update formula fields as needed (`desc`, `homepage`, `url`, `sha256`, `license`).
- Ensure a standard build/install flow (`./configure`, `make`, `make install` or equivalent).
- Add/strengthen `test do` to validate real functionality.

### Step 3: Validation
Run and record:
1. `brew style Formula/ls-hpack.rb`
2. `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source ./Formula/ls-hpack.rb`
3. `brew test ls-hpack`
4. `brew audit --strict --formula ./Formula/ls-hpack.rb`

### Step 4: Iterate Until Green
- If any command fails, fix formula and rerun relevant checks.

### Step 5: Wrap-up
- Summarize what changed and why.
- Keep this doc updated with outcomes.

## Progress Log
- [x] Plan created.
- [ ] Baseline inspection completed.
- [ ] Formula refinement completed.
- [ ] Validation fully green.
- [ ] Final summary written.

## Execution Results

### Baseline Inspection Findings
- No existing `Formula/ls-hpack.rb` in the tap.
- Upstream tag used: `v2.3.4`.
- Upstream CMake requires compatibility flag on modern CMake:
  `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`.
- Upstream xxhash symbols were unresolved unless bundled source is enabled.

### Formula Implemented
- Created: `Formula/l/ls-hpack.rb`
- Build system: CMake + manual install (no upstream install rules).
- Key build flags:
  - `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`
  - `-DLSHPACK_XXH=1` (bundled xxhash source in library build)
- Installed artifacts:
  - `lib/libls-hpack.a`
  - `include/lshpack.h`
  - `include/lsxpack_header.h`

### Validation Results
1. `brew style Formula/l/ls-hpack.rb` ✅
2. `HOMEBREW_NO_INSTALL_FROM_API=1 brew install/reinstall --build-from-source --formula ./Formula/l/ls-hpack.rb` ✅
3. `brew test ls-hpack` ✅
4. `brew audit --strict ls-hpack` ✅

### Notes
- Initial test failed with `_XXH32` unresolved symbol; fixed by enabling `LSHPACK_XXH=1`.
- Audit command must use formula name, not path, in current Homebrew.

## Progress Log (Updated)
- [x] Plan created.
- [x] Baseline inspection completed.
- [x] Formula refinement completed.
- [x] Validation fully green.
- [x] Final summary written.
