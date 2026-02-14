class AmpCli < Formula
  desc "Coding agent for your terminal and editor, built by Sourcegraph"
  homepage "https://ampcode.com/"
  url "https://registry.npmjs.org/@sourcegraph/amp/-/amp-0.0.1761667293-g539b00.tgz"
  sha256 "63edce81abfbaf6baef54ee2237512069dee150127e81a7b921d5aa16fe3f953"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9fc24de4e66edd54f133730c6cdb62b84a8752e8f8ecbb0d14193ac43874ddd1"
    sha256 cellar: :any,                 arm64_sequoia: "3e9d59703ad7e4cd05d4938da96625191959491a1fc7f29377544a0ce2448f33"
    sha256 cellar: :any,                 arm64_sonoma:  "3e9d59703ad7e4cd05d4938da96625191959491a1fc7f29377544a0ce2448f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56962b403e5b87b452947eee4a03866b4bae14017ad4051f970f27ed0b964959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9abab0ec7fa225d3448744b49f41bdae247a114cd9fafff0ec6519fac2262630"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/amp --version")
    output = shell_output("#{bin}/amp update 2>&1")
    assert_match "Amp CLI is already up to date.", output
  end
end
