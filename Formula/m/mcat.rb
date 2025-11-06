class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "925982c9798acfd51f94202c8ca3e770cbd1ccd9179844bf4d30a2b2b8733b15"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "effc6a0ac604da68eddd27ea2271b9d9d6dd0febbae9225d6ec3507206e827ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ad9dee750fbec6c8936dfd0b17e6eff44bf4d95bc779a5bafb4141093b8180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a86636cba461774e67bc92b814d88ea603880ba6111af132f33d0f11d1c76a60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d359f0ab21ec1ca0b9c142d00c9d5bcb4a83bb74a1ed88f81d0602c9fd13dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6b94ea86f67a71a199cf895c28df95649fd69a33ef2adcecabc2a88f83ea504"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end
