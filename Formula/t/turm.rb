class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "c96df492358e5666ef31cff762168b6391b0bffa6cbf071b7f49dfec51a2b301"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e5cc62947a7e1cad059f7f7361cd3fc4da5fb3ca8869f65adefc962bbc882f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5462fc0f7a8f4d942f26d5395eb5217381ec7177281eb347355218d4f6c84dbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "797396c05a7ac14a3e55c581d64b3855cc3255b9e5df36598a9c86bf96cea5ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baf07f55251e62eef75538a4cc33b811d533d17186b62b851e19549890e74efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "829bfed988d1cf26534df20964a113dfa38aa79b9e95eb12f78e55cba2a930d1"
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
