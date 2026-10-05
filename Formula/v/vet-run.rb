class VetRun < Formula
  desc "Safer way to run remote scripts"
  homepage "https://getvet.sh/"
  url "https://github.com/vet-run/vet/releases/download/v1.0.2/vet"
  sha256 "1b85c98f4f29be13b908ec225f53a70f90c0da5025759810a55961f7c6274878"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "af5bdf6f5be8e1addc61256c783623a41774d2292d281c074aef5df36bcce839"
  end

  depends_on "curl"

  on_macos do
    depends_on "bash"
  end

  deny_network_access!

  def install
    # macOS bash 3.2 rejects the empty "${SCRIPT_ARGS[@]}" expansion under `set -u`
    # ("SCRIPT_ARGS[@]: unbound variable") whenever no script arguments are passed.
    inreplace "vet", "#!/usr/bin/env bash", "#!#{formula_opt_bin("bash")}/bash" if OS.mac?
    bin.install "vet"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    # vet downloads the URL with curl, so a local file:// URL exercises the full download, review and run flow.
    (testpath/"hello.sh").write <<~SH
      #!/bin/sh
      echo "hello from vet"
    SH
    output = shell_output("#{bin}/vet --force file://#{testpath}/hello.sh 2>&1")
    assert_match "hello from vet", output
    assert_match "Script finished with exit code 0", output

    assert_match "Unknown option: --not-a-real-option", shell_output("#{bin}/vet --not-a-real-option 2>&1", 1)
  end
end
