class PlannotatorTui < Formula
  desc "Annotate Markdown in the terminal and send feedback to coding agents"
  homepage "https://github.com/plannotator/plannotator-tui"
  url "https://github.com/plannotator/plannotator-tui/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "060597771cca59798907eb7f30a3d29263ca1b076e9a8378a30daf35d8353e39"
  license "MIT"
  head "https://github.com/plannotator/plannotator-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "90c81d3113acfda5d832b0ba6ade77f61689563e9118210dbcf1a809eb0a2d8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d3a0aba2756728fd3875f26cf4d70880771ae060a34120ae0f93fd21bfd3d1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c5cbff189dda34316abfa9831653ae36dd1f5b3da9e83b37c152ea7a9cf9a2"
    sha256 cellar: :any,                 arm64_linux:   "311c54596cf248446f03d3bafb0ae33d329b2cd4608c65766127efdfd6843cee"
    sha256 cellar: :any,                 x86_64_linux:  "e241c7081c70c198142ace5828b085627383210e8e084d4902fa881c71ff3209"
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
