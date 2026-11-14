class PlannotatorTui < Formula
  desc "Annotate Markdown in the terminal and send feedback to coding agents"
  homepage "https://github.com/plannotator/plannotator-tui"
  url "https://github.com/plannotator/plannotator-tui/archive/refs/tags/v0.9.11.tar.gz"
  sha256 "e339f6b918b69d4d0806cf9538b1548953d688bb3fcd4ec7cbafa638bdcd9487"
  license "MIT"
  head "https://github.com/plannotator/plannotator-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "480151181f7997e506d8d8574bcfacd4f2129172ab34b6b5d8e2ca64481eb495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4da0f41407ffd4a56637a28962d37beceddf844109be11be1d6f38e2342b2d03"
    sha256 cellar: :any,                 arm64_linux:   "2c060a3b24adf15232ae3bc1fc869a3ee5a6c5cd9553d0d5bf14ac78a0ec8f2e"
    sha256 cellar: :any,                 x86_64_linux:  "c8172263fbe9d436f66bc463899a5c393394eda1a1134bd458711503b4210d0f"
  end

  depends_on "rust" => :build

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
