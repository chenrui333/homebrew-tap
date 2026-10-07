class Statoscope < Formula
  desc "Toolkit to analyze and validate webpack bundle"
  homepage "https://github.com/statoscope/statoscope"
  url "https://registry.npmjs.org/@statoscope/cli/-/cli-5.29.0.tgz"
  sha256 "6d6752a54d855018ad22b367efd4dccf9654c9a43bcc4afa7451cd42fa3277ce"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "365b443aa765440ca6817ad821f231a0019af231e6d1792640fab3a52bd72110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "365b443aa765440ca6817ad821f231a0019af231e6d1792640fab3a52bd72110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc04f10b37ce7b20b0633896053540b2f97502a6280593ed13eebdbf966cd6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc04f10b37ce7b20b0633896053540b2f97502a6280593ed13eebdbf966cd6e"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/statoscope --version")

    (testpath/"stats.json").write <<~JSON
      {
        "assets": [],
        "chunks": [],
        "modules": [],
        "entrypoints": {}
      }
    JSON

    output = shell_output("#{bin}/statoscope generate stats.json --output report.html")
    assert_match "Statoscope report saved to report.html", output
    assert_match "No Data", (testpath/"report.html").read
  end
end
