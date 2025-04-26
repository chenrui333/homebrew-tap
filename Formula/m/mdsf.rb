# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "5bedad5f5bbcf91b4a5eb50c4a672b5bf0d035b5d1cfc151fff274e89da99bb8"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e163040ac2873b65ccce1eb93ca50e112509939f74733c22526a32e00896e1e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783fbc67b66a0eb61fe062529bb9bd37da9a5b1b8da16fc556efed72f4ec2182"
    sha256 cellar: :any_skip_relocation, ventura:       "1139e24dbc2ba618717187515560b20e1ace67ea14bc38b563799ec0e429a6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a2b1ac4cfcf603b04321e2bd7195c7133681a017e1b82be303a86330327ade"
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
