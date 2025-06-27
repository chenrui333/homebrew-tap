# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "b559f81f1a394be06f676e140a01cfb7ee22e57a5e307cd79a37dd256e5490c9"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "157be8a61b04ac00ed827233dd1faff21e2a5c8567588491e9d04fad4e0b45b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7b1f73e2cc3a47883b68c4fc58ead86e2a9b3d86266626f517230e30d4b2c35"
    sha256 cellar: :any_skip_relocation, ventura:       "853f655cd677f4ce6ad73e45ad8437259ecf10d1bcec1be104e34d54a6e0497e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "800bfdf9e950cd2a3ff23f49d10ea070263ce6a59d0d03566ff9e75c31f17482"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "mdsf")

    generate_completions_from_executable(bin/"mdsf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdsf --version")

    (testpath/"test.md").write <<~MARKDOWN
      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    system bin/"mdsf", "format", "test.md"

    expected_content = <<~MARKDOWN
      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    assert_equal expected_content, (testpath/"test.md").read
  end
end
