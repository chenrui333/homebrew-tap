class PlannotatorTui < Formula
  desc "Annotate Markdown in the terminal and send feedback to coding agents"
  homepage "https://github.com/plannotator/plannotator-tui"
  url "https://github.com/plannotator/plannotator-tui/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "eb36f55ad8374abaeb518b760ce13b5499af7bf2656b30696fc1c3b710b011b1"
  license "MIT"
  head "https://github.com/plannotator/plannotator-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "6eb6e0bfd5fea7ef2c6501138c9652e5fc635e902edb971e867a796d9137a537"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce76f2fef3b4f874c7daf38e6bd7069b7f3081eb580992411681333f72339c2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8828ddfe1b80aa76bb5bb0852d5338a892a630be52e011c5e742f988f1ed9006"
    sha256 cellar: :any,                 arm64_linux:   "81c230dd29e4d3283daaa05b7253d95e9c7faebf1a7920650d331a553c6fcf89"
    sha256 cellar: :any,                 x86_64_linux:  "b7cbb7ed856e16d7f6c0a30b35f5edd7fc7c9106e4402eb3a43484a19825d639"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/plannotator-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plannotator-tui --version")

    (testpath/"plan.md").write <<~MARKDOWN
      # Release plan

      Ship the source package.
    MARKDOWN
    system bin/"plannotator-tui", "--annotate", "plan.md", "source package", "Check the license"
    output = shell_output("#{bin}/plannotator-tui --export plan.md")
    assert_match "Check the license", output
    assert_match "source package", output
  end
end
