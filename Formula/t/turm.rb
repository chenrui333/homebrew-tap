class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e5bd02b58cdf4e19f391349ab43d44915c049e02176e9b5b406e29e5b5504082"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4fa7ec6e3e0a1788cec41ee7f57cb177929c398dfcb486b2e2832312154899b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84f9210dcba058139cefa1362da5fed4bb77c4dc88e98e4761367f000990a890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd8f1167d0417c0cae0cbabae4749af8e5816855580b9812fb2626b5b086bf8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a42b72048d1c6ef158f97a0f726a9d652de590a8bd869d06518c2e1897652d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eac9da41e82a33babaa94176164b609bc08693d4e59d167a8b8d3f186ec8a4c1"
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
