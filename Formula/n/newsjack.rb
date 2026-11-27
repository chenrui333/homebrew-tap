class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.26.tgz"
  sha256 "ffe11ba84ced382a05c877f31c24f00e2f195fbfd2512f2636e22cfd66db296f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "8e13effc33e3c339aceb2558ced6697a6f8ec26fad0f5aa33b746711d8ff0c46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13f932aefd035e79a9d10cd125f3db9db933499c65dcff707c306db4225bdf8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13f932aefd035e79a9d10cd125f3db9db933499c65dcff707c306db4225bdf8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677569e2976cde3d1b0a22e9daa66e457745a808aec356db1166944d8aa6675e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60c4b033dc47b888e0735d698be68bb6b2742d7db13b45bc942fedee9653a61"
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
