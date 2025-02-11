# framework: clap
class Lazyjj < Formula
  desc "TUI for Jujutsu/jj"
  homepage "https://github.com/Cretezy/lazyjj"
  url "https://github.com/Cretezy/lazyjj/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "f92f084b9483e760a17807e49ad5547999074f14e62acd6ca413388a6d669f3c"
  license "Apache-2.0"
  head "https://github.com/Cretezy/lazyjj.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "241a612eae41ac43e14a43f42717425dabb47f8809229d6b89fb0f20a853fa7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7353750e4ab9b2301814ff0ea8f520b1f3647ce6813fa23021565a6deccbb57f"
    sha256 cellar: :any_skip_relocation, ventura:       "38ab3f37e152d6e9fcbc7c03c7c1d71fd28fbb0048694a7df4dfde05618cbd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d471e22a80e25fda766bce58cfd4559596b60c41bbc574bb133da58256c1eadc"
  end

  depends_on "rust" => :build
  depends_on "jj"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LAZYJJ_LOG"] = "1"

    assert_match version.to_s, shell_output("#{bin}/lazyjj --version")

    output = shell_output("#{bin}/lazyjj 2>&1", 1)
    assert_match "Error: No jj repository found", output
    assert_path_exists testpath/"lazyjj.log"
  end
end
