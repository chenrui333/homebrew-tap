class PlannotatorTui < Formula
  desc "Annotate Markdown in the terminal and send feedback to coding agents"
  homepage "https://github.com/plannotator/plannotator-tui"
  url "https://github.com/plannotator/plannotator-tui/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "060597771cca59798907eb7f30a3d29263ca1b076e9a8378a30daf35d8353e39"
  license "MIT"
  head "https://github.com/plannotator/plannotator-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "5f74432474bb2c6579b833d2ee9e5f84f8e7ac6c4ed3eb418af5bca8aa8d97ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83e607ca8617acbe73d6fc05f2e0bd8c477a1a4f511066bff4fe81878cd41cd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc8231ec82054ce3b36e3ab187821ea7b6a19b921b7ee03fe5bf498e6f9ca9b8"
    sha256 cellar: :any,                 arm64_linux:   "92a8e24da17d60e01374e6e7a4f0804b40e4c618a4aa930cd0827c772f6dfeb2"
    sha256 cellar: :any,                 x86_64_linux:  "1b0a3e1807d02ae404b11fcb073bbb293da44bb87d5cd773d176354e3e80c280"
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
