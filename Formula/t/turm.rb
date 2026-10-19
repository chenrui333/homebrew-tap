class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "a608a8f75e86ec6b2c87ac3f0212a0a094a9935133947ffe647108b70486d14b"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e865c1df0c3022ff8d0a4749ef1e48c53edd51a95a4ee7884d1893bdfa3176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48e42227e731a7777e0cf96f26b88eeebb84f6cae6b819589732e86e44ba504d"
    sha256 cellar: :any,                 arm64_linux:   "9845b90df178134b9970ab07fb746268ddebb4c330120c7b2c9d8d7a61e705c4"
    sha256 cellar: :any,                 x86_64_linux:  "affc6aa96a1f7f4c9141fd4fdf8bef6d8639871f1802014b6661b3ef259113e0"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
