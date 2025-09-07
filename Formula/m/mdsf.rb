# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "87ed459b94ee5ccd9ee28362035c6256b0ed43fb8333b0e47860f2828c170263"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dbbdf49724e7e3b69639fa1198b44a4adcbb97f6c6f3bcad67641ca5d5ff825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "348f4da83c175b7ef8fc2a95051018670614dca6021f528ba625cf88b891c1c7"
    sha256 cellar: :any_skip_relocation, ventura:       "071a112929b9cc5a0723ac2588671544989f30ddc124e813eaad346f45867871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8fa3d5ff79ebdadb5c57901ec487ce0517a1a1c4b7ae8f07144b8ee18c71472"
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
