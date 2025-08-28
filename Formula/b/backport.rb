class Backport < Formula
  desc "CLI tool that automates the process of backporting commits"
  homepage "https://github.com/sorenlouv/backport"
  url "https://registry.npmjs.org/backport/-/backport-10.0.2.tgz"
  sha256 "8500e7091a67e001bb7d0af71ff91e0d7cd442b88982b5d965e8a42f10b3a273"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8365d2f37a6cbf5a7eeae563f5985716f57788b5df41fe401d41f2dae42ad34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbeba895990a4c4ed1fb4ae2e95f662cbb163f1454240472b858d8d3bfaa90c2"
    sha256 cellar: :any_skip_relocation, ventura:       "987e72d48d669c1b521f3196205a12cda38d57624879e9f23c0a418e3ffd5710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c604bfe87504cacfbb39b1d1509e573b44e9d25a2017fbef201cc2d9a0875a2a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/backport"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backport --version")

    (testpath/".backport/config.json").write <<~JSON
      {
        "upstream": "elastic/kibana",
        "branches": ["7.x", "7.10"]
      }
    JSON

    output = shell_output("#{bin}/backport --dry-run 2>&1", 1)
    assert_match "It must contain a valid \"accessToken\"", output
  end
end
