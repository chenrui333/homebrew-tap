# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "b7bcf686cd8ce5f7e1b3f532df4bdfc0db35964756b0639870172f09b87d2801"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "090e393ff675cbd9208629583e9adb473139bb10630cebbc269a085264ba21da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "135c04dacc96886d8eb7c0c77d8c97059cbd8c737c3c75ac35b8ccc1b5213753"
    sha256 cellar: :any_skip_relocation, ventura:       "2cb20e5c3898177873578cdb4f3b100be39153c3df597091f50cf647b4d6c016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d834ecda31c70fbdc1c72a3b427d97f8276c617877eb74a578c506c48fd290"
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
