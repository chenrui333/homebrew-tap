class Backport < Formula
  desc "CLI tool that automates the process of backporting commits"
  homepage "https://github.com/sorenlouv/backport"
  url "https://registry.npmjs.org/backport/-/backport-10.0.3.tgz"
  sha256 "063d9e65b2fd79aaf8e569f5cfc5bd67518237dc5849124f49034759ce3ef44a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3188ac13c47136121d1d0b252e86b79a9f9a2d7347ef07bab6ed102e255a3d7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b344bc2f316a57154a1f23e56cc7b36423f5c026fff55d0e51adf6e9e5abea41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efa3541f776f848b43e0bc51eb3b07106955245afb3d1b069a21b25acb99ca98"
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
