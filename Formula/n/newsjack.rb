class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.21.tgz"
  sha256 "a8556a6ea03f2e3ccd35a2c3c9a9bddc777c16e731b2951112be33fd0de99955"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d65be294f58d41fb8976ca3d248a52fbf8236b453f5a9fcc3698dfbf21287014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65be294f58d41fb8976ca3d248a52fbf8236b453f5a9fcc3698dfbf21287014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2851e5f1eed1ba97939ac12bff62f2af3a67a5c00cac3f9e06436925374b76ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc53bfaa1e1b8f04c5786937cea68673c454a65568748b8a34588023e57f8e2"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsjack --version")

    output = shell_output("NEWSJACK_AUTO_UPDATE=0 #{bin}/newsjack doctor --json")
    assert_match '"root_ok": true', output
  end
end
