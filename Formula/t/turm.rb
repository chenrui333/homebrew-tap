class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6f1404336ba91be8b16a17f35cc3d24bce29538c1120005787d6abdb41d01536"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4aab6d72ebf4b4354c09dadc90c647260876b26b03ed8b9f84fce6fb8d1ce4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8355fc10a6ef805dfa88538bba61bcd68013653588b1fd848511d7442055fd24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdba44cb9bf528f3ff405548638f6296459c4b3c37ed7b8498e3377852c94f7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "466d7ff93d17d2c74d4c194b606512699080cab09c4641484b299c48b6f2591d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e6e9940863bf280cd341865f3b805f22beb390b8c808b8c52b3d43503ae8b17"
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
