class Statoscope < Formula
  desc "Toolkit to analyze and validate webpack bundle"
  homepage "https://github.com/statoscope/statoscope"
  url "https://registry.npmjs.org/@statoscope/cli/-/cli-5.29.0.tgz"
  sha256 "6d6752a54d855018ad22b367efd4dccf9654c9a43bcc4afa7451cd42fa3277ce"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "403004da59144ecb57c1d5fb3ab86ac971d1dfe0f37e56fc87cba32e2cd99254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85ab71aeb11ff6ea895b95a97a04d75711ec0f9da043779330512458c45c518d"
    sha256 cellar: :any_skip_relocation, ventura:       "a190f9b0847046c8753bc297118bbe7ab52d517510ab968b01f33a162e1a1392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2db2d09981fe09d7174d38e49ba98d7064f2fa0596d9214786d1a92e228f9dd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
