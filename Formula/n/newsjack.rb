class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.19.tgz"
  sha256 "e4e8dc36f2672b4abca9854f4e76de542192ca89edc506a2be6905289db41fd8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd998bd53edaef130d99e09164e7c9cd09a3c37555c5c1e10f9cd1440a5beeae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd998bd53edaef130d99e09164e7c9cd09a3c37555c5c1e10f9cd1440a5beeae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e508eaadf7a788d8780efa05e0c1c0c58e59df0fa2f408d6c4dcc9243a431a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c78438dfecf731aa1abab1bfe0ea450eb9fa8032c28c93cb2045f1e2cd9d51"
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
