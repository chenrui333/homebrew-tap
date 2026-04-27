# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "dde37767de63cca26b3ac8f7a8aafe06545cf4248d4a011fa1f26b68d4db34fb"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8236926c33a4a9a795f9a80e24435c375daa62dc545815197d2eca050d20583d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29c178e53759c9d541789af7abbc365d44c4b979f251c94815006e1322ccc7a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38208eb87d8478850549bfe11eb248ea5557496ab896b2325919cb166c2f0236"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04f2c2d6e4f438b41fd9163e1dd9b89b907aaee3d51173b72db8e3ee6aa46f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1d897fefd909a5969352134c3f7a51a5778b14f7b0c76aadb130d6ad7b295a5"
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

    output = shell_output("#{bin}/mdsf completions bash")
    assert_match "_mdsf()", output
    assert_match "mdsf__format)", output
  end
end
