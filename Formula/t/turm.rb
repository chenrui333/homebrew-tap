class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e5bd02b58cdf4e19f391349ab43d44915c049e02176e9b5b406e29e5b5504082"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92a0ab7b203c52e2a38a25887adb6d36961a85d282a164309254423ffca28858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d22f4f36451401c99b63531933e708cf1d3aa69885bbc354573e279b66e5cb56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ac3f2be9a294a98940d3a42e58343a2b23ad1a1d48c2a00f24c4ffa471c0f2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a259b0adc2dbf1ffac281d26c76aa39e389b37b386b5221ed3dc72f5083121b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e322f92a24d8706df8c7ccb5e1dbe1507b025ab12e20b9339516ca247d176ea7"
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
