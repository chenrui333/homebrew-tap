# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "05836a8e57b714fc28c355e856909acd664120cef8b3438b4c8fd0d1bfc8c341"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e96f85dbedf4e6bbc7ea24c999bae081b705c6c80ec663fceec8a27a03fb67cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14b2afe252174bec99a5e37f03d1f2270521bf2824d35310845aebc12f4d2659"
    sha256 cellar: :any_skip_relocation, ventura:       "cfe86fd304bd14a4f14d076b776e94d738ec0e970e6e8e9ec41acedde9a6fcb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a4a1c4fd28a32df3eeee94cac240c7b3aab64d4cfdd8cc59bf57a68a063658"
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
