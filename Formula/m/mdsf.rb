# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "f1aa9d0ff59ac24dc915bb041cfa453ac93f2d48ccd7c45cc0a8dcfdeb52f7fa"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04f96af5fdae4cc2bdb81101acb84aa0f61659c23068fc6609b66b69b6278eee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "372ca5c5e00f78ccf305c0b45c70f3b2987409cf7a06d7dfc74b433f88f3915d"
    sha256 cellar: :any_skip_relocation, ventura:       "04b08c40faccf489364798fc8f5d36d9effc2453e5f77e9cebcd265ae8d1bb5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "365bae76c64efaa4abfa1f1398e9ca18e1241cc3466edd69674de5752a7e477b"
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
