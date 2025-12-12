class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "91a8600bb292ecdf6b52d076ce5cf20d58692d99615c21b0a4ecd207db99a990"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83c959a27bbe4b0ddb33986395b3cfce23fcbcd610a6d07a21009c9d7e24f9ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb51165dd79435e6159d1f5a20767e6ff4b1540c032dd7e256bd98d32a0d5b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c96d69901b818e71b5beb7849b798d21faa4fa4703038883f0a4b07ea1e07f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af368150978d63865235e667aba0f9643bbd66c0b5ea12489704c9c7dae5d25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b4cc85b55db76dcfc313d4cf8de8bb2af75f1ae354d98d71cf689268335031"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"turm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/turm --version")
  end
end
