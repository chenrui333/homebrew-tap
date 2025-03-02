# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "4f46907eec29a3fd7f3a421ae4f9c2c172b4be5f099af9141387cba34d89e920"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469ce6d6e062f4dc1a0f2f9e1470f247fbd4b9caab25ca6f534501907a9644f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "777d1353f72f279fd6c843126167cf1f03315b2079360560d624af4a29bbedaa"
    sha256 cellar: :any_skip_relocation, ventura:       "b72bba721682b189c3bbabaf7b9ed7e94712388c022269f80bd94564d503c96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa171384146985a753cc3a71801026446f96f8ad95dc2bd420913e6d7a297788"
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
