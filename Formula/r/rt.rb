class Rt < Formula
  desc "Run tasks interactively across different task runners"
  homepage "https://github.com/unvalley/rt"
  url "https://github.com/unvalley/rt/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "16eec7218a0c4cc0bee7734a54e3629df85dac6011c9caf070caeaa3db61487c"
  license "MIT"
  head "https://github.com/unvalley/rt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e27b66c3fe38c7dc6ddffe159a6d9ac8de97359de10e72db985c1b2382b855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "471071edafb2764c8c40f0d7f9d16f3790a5a5e51566500f21c3a306ce38e61b"
    sha256 cellar: :any,                 arm64_linux:   "05ee7fe0516bf1ec16e2ddb8cae3989eddd1b77a4c7b7b1c3d6281859e01e836"
    sha256 cellar: :any,                 x86_64_linux:  "d53de4454a3c1d30ecda56c0440e25ee7f19c4af1684c94e1e77499a1ad8c723"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rt --version")

    (testpath/"Makefile").write <<~MAKEFILE
      hello:
      	@echo from-rt
    MAKEFILE

    assert_match "from-rt", shell_output("#{bin}/rt hello")
  end
end
