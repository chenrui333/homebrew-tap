class Backport < Formula
  desc "CLI tool that automates the process of backporting commits"
  homepage "https://github.com/sorenlouv/backport"
  url "https://registry.npmjs.org/backport/-/backport-10.1.0.tgz"
  sha256 "c33b504d1bfa17149581081bab51058804cfa6a42b82595d01fa017362699443"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "993da507569a5ae1558e929c29003bf286e3f012bde67282975e82998d7e8795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c8617654d5fe4d00331f5e464257d86bae70fc1ca4f38e3d30061e6803b9011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b6618409dd4bc69317e0bac4e7a2b3600dbf3afdd4dc259e1d6185b9bdb8bb"
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
