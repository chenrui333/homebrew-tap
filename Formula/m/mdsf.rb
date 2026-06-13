# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "c79a131f6e15804c99cff4c9ea0fe917e6b935e3524341255cc323973d2be7fc"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2b943d3b8ca93e39150ba7e686f0520f6337a21dad869ad512de1c0666551d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3de88e12b1662f2faa3c7f86894cab9e0c3078194538a05338db3991373133d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c5146d9145cfda6a55cdd2cc82337b278b79cd99aca6e85a7d2fbd10bb455ae"
    sha256 cellar: :any,                 arm64_linux:   "ac09f997ce2db765fff7a18c33dcdc4e44ed1384894260739b8dee228cac5188"
    sha256 cellar: :any,                 x86_64_linux:  "62aca17a2f08c8a70d2c019620ed8bca7f8f613e83f254c5448c400ea5d44056"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "mdsf")

    [bash_completion/"mdsf", fish_completion/"mdsf.fish", zsh_completion/"_mdsf"].each do |completion_file|
      rm completion_file if completion_file.exist?
    end
    generate_completions_from_executable(bin/"mdsf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdsf --version")

    output = shell_output("#{bin}/mdsf --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
