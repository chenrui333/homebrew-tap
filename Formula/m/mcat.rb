class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "925982c9798acfd51f94202c8ca3e770cbd1ccd9179844bf4d30a2b2b8733b15"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "048047fc1c3c47757fa0d4b871a7f67d5134805f16f2def6e1d9e13bf7b2f0b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b3f4fa8a91093ad4927d87883512808cde586ec509368e9b3e143853374ab84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f25cc3720b10bc3a1ed83c741dec3e030fe5e3a13ea89f466f1912e4f9e7202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d10d3c31c0a89cc64d7a7303248f363b038060b8b089f8d96204a5f4d3eba2a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3dc599f0b94cae465eeacebc87dc67c051170b430be28bfcc27b3e918ba0548"
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
