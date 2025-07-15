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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa444817826276a280bf6ffe7c7ac6121cc951486d0e87d68c719089b8169b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27c617541399fb35b11ede28f7179c07698ba1003924211e0681b75b2e383d9b"
    sha256 cellar: :any_skip_relocation, ventura:       "365ec2e9d0c6059174ae491371dc108ae2337f36ebdb5edac0ed838b839fb8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92eac13e54a28ec96c9652647cb4f397122e3650beb8cb92150ee022b5f5eebf"
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
