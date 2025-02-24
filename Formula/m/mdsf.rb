# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "2976bb38999b69e5c588b4bb63b57bf0e220a95c1f1f83f71e5f6f9dd166ee57"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89f65f3155c4d99370d8f1aff0dfeef466af3870f0d1ad06f03babc9285d367e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb77703fd744ecb19c27cf2269804ca1258aa94b380407e62566786c2481a913"
    sha256 cellar: :any_skip_relocation, ventura:       "935d44f311b8aee4f9b854953abd2cb1c90b0c7c8b03d704e3b2730e27d5c147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a562d1bae8dd8f635b573610db2639e465bf42599bcd1537e4ce0c73ccb4f93f"
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
