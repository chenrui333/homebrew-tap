class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6f1404336ba91be8b16a17f35cc3d24bce29538c1120005787d6abdb41d01536"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fca49e8ed9a378843243ae36846e255f54c285d0765344bdd9a5573459e45036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa8c1617d14b422ca6fef77f2df2f804b9a85f1db75460afcdc1d500472e4a4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cd5b509240d0cc4a7e080da74d1cd9dfc18fb2d064251a93bea9b07ab700c1b"
    sha256 cellar: :any,                 arm64_linux:   "73b09df6790ae5ea47dfc43b163ddfd104309c8d0f26b5a6c1544dd3072e03c8"
    sha256 cellar: :any,                 x86_64_linux:  "1d9f03a4337fb720ed987f1afb70ed950e7971d086f7ab451048a2ac5e2cfd3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"turm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/turm --version")

    output = shell_output("#{bin}/turm --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
