class Statoscope < Formula
  desc "Toolkit to analyze and validate webpack bundle"
  homepage "https://github.com/statoscope/statoscope"
  url "https://registry.npmjs.org/@statoscope/cli/-/cli-5.28.3.tgz"
  sha256 "a20f4c7eab2bb0acb89f4fdcc1642951592fed7b630ae4fb49cadfe514630348"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "741a9ac2d23fcfc2c2974c18786bf8d8b8dc4f8858199fd7419b41c97fce6d12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "782e374131d9ab9fd4b47d57d130d339f1e1ca32c0bd9e6e765293598ea55876"
    sha256 cellar: :any_skip_relocation, ventura:       "148a58ba1f0a8f18c208eee21ac852e332e92e5a109e044536e5de535e839899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21bab26f6394c5fb2dcc8922d8b02078c3163102bf00dd5169c22e2b13960412"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
