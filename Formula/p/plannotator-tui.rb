class PlannotatorTui < Formula
  desc "Annotate Markdown in the terminal and send feedback to coding agents"
  homepage "https://github.com/plannotator/plannotator-tui"
  url "https://github.com/plannotator/plannotator-tui/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "5bff9d8c052e0613278949d643b61118667c67997005177bc2a2f5bae2d0abed"
  license "MIT"
  head "https://github.com/plannotator/plannotator-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "65ff880f716975c7623fc3c74cbea16efbf51917245b34e7dfae8f70bd0768a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dce2b6a83819c1147501368b0f593189449d189283ec4b6917ecbb93f458b0dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508a7f1d3e80beab9ee407b1c2ee8b61e4253d071ea137ed36078c52d83d669f"
    sha256 cellar: :any,                 arm64_linux:   "27986ec3cb439e8d1d413a1cfef1e65e3fb54e5aa8cf46996031da5895056d83"
    sha256 cellar: :any,                 x86_64_linux:  "e06b6622a3978a373bb43a6a48757cf2fb70e7c7997420bd93271d66eb06a23c"
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
