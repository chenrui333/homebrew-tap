class Pam < Formula
  desc "Minimal CLI tool for managing and executing SQL queries with a TUI"
  homepage "https://github.com/eduardofuncao/squix"
  url "https://github.com/eduardofuncao/squix/archive/refs/tags/v0.5.2-beta.tar.gz"
  sha256 "68350736b0b0e8339406973310374d41a744f387e26af29e84512e5db3d3fc66"
  license "MIT"
  head "https://github.com/eduardofuncao/squix.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-beta)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1edaf8a25efd8ec4e6a3c8dd16828d993054ea518dfd82194871d255327b240c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73faedc831c35bcfc09fcf545063ec7d97977a306a4102c3a99ebf66c25d53f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ed37a641e0091d99382a740f8d9fa2084c72acff9d4cd7a319e43f54826a66e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "365683317cef074846d98a0c82cd9889ef843befa69e2f09f68ffdfc242e96d8"
    sha256 cellar: :any,                 x86_64_linux:  "edc68cbbd01f0a7d6f747e4c254054c3ed4845778ea2ad44264e17b6f1a2dba9"
  end

  depends_on "go" => :build

  def install
    # Upstream renamed the project from pam to squix; keep a pam shim for this tap formula name.
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"squix", ldflags:), "./cmd/squix"
    bin.install_symlink "squix" => "pam"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/squix --version")

    output = shell_output("#{bin}/pam list connections")
    assert_match "No connections configured", output
    assert_equal shell_output("#{bin}/squix --version").strip, shell_output("#{bin}/pam --version").strip
  end
end
