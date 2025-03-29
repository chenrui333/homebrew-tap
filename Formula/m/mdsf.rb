# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "571c649d919b0289f45de18afc5fc9ff4d0c0b70adc234c52b755a2bcdfc6104"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710413eca5eefdc74e8fb33284a34c05710721ad33e90396e9b433e2c6ef2c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9996fa291699bd3807ddd8dd57515fa9f7af5b8beedae5254298a590cf2631aa"
    sha256 cellar: :any_skip_relocation, ventura:       "44297ce742d13947ccc45d6a37cf84fb3d65372d51147aa609386ecc3ecf7f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a45f0114f57af9653e7696a87877d9eefb794bca6de40ea868b2a41db08713"
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
