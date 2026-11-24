class PlannotatorTui < Formula
  desc "Annotate Markdown in the terminal and send feedback to coding agents"
  homepage "https://github.com/plannotator/plannotator-tui"
  url "https://github.com/plannotator/plannotator-tui/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "eb36f55ad8374abaeb518b760ce13b5499af7bf2656b30696fc1c3b710b011b1"
  license "MIT"
  head "https://github.com/plannotator/plannotator-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "302dbb44eb46936e8abbb97b916263eeb41dba27a25fa58e45eb99eae8ea886c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8320e28d7b0fe5a3c94f37d0b89441f93c07d9048d27f01dc92950899467ac0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa28577fcacd6fcd32bc8d8d3f5b80b65a9bacd7fe35efa6be18d285eab8f658"
    sha256 cellar: :any,                 arm64_linux:   "cff1b82b7dd82194f55cef694a5032b83405cce9a62adf4d08d45ed37701d344"
    sha256 cellar: :any,                 x86_64_linux:  "905c66dee51871d2742dd3638ba8aafac88ffd5f6161f5a2cd441f979bda1ca6"
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
