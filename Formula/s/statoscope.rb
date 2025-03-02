class Statoscope < Formula
  desc "Toolkit to analyze and validate webpack bundle"
  homepage "https://github.com/statoscope/statoscope"
  url "https://registry.npmjs.org/@statoscope/cli/-/cli-5.28.3.tgz"
  sha256 "a20f4c7eab2bb0acb89f4fdcc1642951592fed7b630ae4fb49cadfe514630348"
  license "MIT"

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
