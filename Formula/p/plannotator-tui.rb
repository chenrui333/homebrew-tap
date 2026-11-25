class PlannotatorTui < Formula
  desc "Annotate Markdown in the terminal and send feedback to coding agents"
  homepage "https://github.com/plannotator/plannotator-tui"
  url "https://github.com/plannotator/plannotator-tui/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "0a76ef125fada375f3fbec6e6d88e45c0014c4672bbb3e113e2653efb80a0c32"
  license "MIT"
  head "https://github.com/plannotator/plannotator-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "9ed8e89d297e72ca9b6db2244fdddf60bb25be959a7be01106422d96bf05f4da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33e00bfa046fb29eb14165536df9e66cdeebbdc7d1869d1bab33c706502a20c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "070be48db5d65bcec3b28378e0d1aac91a7b478349e1f82c695efad28403fc51"
    sha256 cellar: :any,                 arm64_linux:   "4ee3578c565a2c10850e1981e6114516225b934e2977ec72c1d6d2de79af9689"
    sha256 cellar: :any,                 x86_64_linux:  "90e0aa6d806ad4b27e6f4b34e443767e621cd6987449be610e30cc6a27e68004"
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
