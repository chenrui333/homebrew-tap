class Backport < Formula
  desc "CLI tool that automates the process of backporting commits"
  homepage "https://github.com/sorenlouv/backport"
  url "https://registry.npmjs.org/backport/-/backport-11.0.0.tgz"
  sha256 "03f07d1df8e52aec8904b7a61e9d1ae5e4aaadbdb530d4e296b845001e2e2eb5"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ba35fb691d7d1a45599b03dce760cc9bd68e7f5375331fc34c0477ce6efb1fa3"
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
