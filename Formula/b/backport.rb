class Backport < Formula
  desc "CLI tool that automates the process of backporting commits"
  homepage "https://github.com/sorenlouv/backport"
  url "https://registry.npmjs.org/backport/-/backport-10.0.0.tgz"
  sha256 "e1d800d2aa975920389323a41c8c08174f1b94c60c9d69854f7f6d4cffd19150"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02a53b3d81e5fe146962e9e92a12f1bebe7a6de449ae8650adf035f894db459e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be3fd018689c2d994863d57050539e930aada5f6d1b40d83f551eb5be821003"
    sha256 cellar: :any_skip_relocation, ventura:       "94520ceec6fa693c0ddfea063d7d4a171c01bdfefdafc93f4dc6560985d6066e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad3a39ec2d53ead28d30a2a8f18ec68bf2b29b513c49cf93a64f1e698f1ca5e4"
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
