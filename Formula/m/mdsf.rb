# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "de5f38af46e2cd09d75b5bb827c948522fb171d5eeb129e11778d45c80147b59"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe7d807242c897e3eb6a02e812f48c5d2674af09753c579e6f92b77973e3cf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77fe923be02625024299f43f406b8d136415f4792340b0bfa8eaa02dffdbbfd9"
    sha256 cellar: :any_skip_relocation, ventura:       "db883bb47097ddb436e85efaf46306d047c36c866a537deb76bf545ddddb51ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6287a4f07bf70944730ac8b20c9b430c4dc20e4723500b13023d43fe2a55a05d"
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
