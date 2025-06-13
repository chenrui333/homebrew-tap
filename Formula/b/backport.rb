class Backport < Formula
  desc "CLI tool that automates the process of backporting commits"
  homepage "https://github.com/sorenlouv/backport"
  url "https://registry.npmjs.org/backport/-/backport-10.0.1.tgz"
  sha256 "11f8ae05677817558291773133b17759afac50c742193c7013dd366675a61553"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d08c56e22bf46c9887cde7a9683a35b03df1627f02e3ffc2494bf283e6d6ce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5cab4bacf7fd218476c68ec8a6ce2639c4418ed8a71633bf207002969891781"
    sha256 cellar: :any_skip_relocation, ventura:       "99528a2a5e52e43a04a7f880931a5464a0fd5a68f11db25c75795a6c6d4febdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41a90d36dbf14b2684db5f8f906199720b4688d06b0c2dabaa2f015d2fb0b669"
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
