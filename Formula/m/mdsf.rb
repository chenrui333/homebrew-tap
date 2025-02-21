# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "44b250343a096758d351d4c072d4c3cd62948efccc95874d40b65036b04326e4"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06fb55311bb9b59937c2a701dda2ca891b299e8dd86e66cb431c6df7a8147e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "402a890c06c6902b3d9df0f1d5222787a4c11461131160d7796408c510218f2b"
    sha256 cellar: :any_skip_relocation, ventura:       "012f10b52386625f13f786b13aa640fea0e4db5980ca38681e582696f7631d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73a3f02c6bb1f3da78b5e645530e66c83e6c0c439c04883dc5a8634cc3e2d07"
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
