class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.26.tgz"
  sha256 "ffe11ba84ced382a05c877f31c24f00e2f195fbfd2512f2636e22cfd66db296f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41f998805e5d06dccf911961457fc38e70c3c35c8f85e4adc50c49db7999871f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f998805e5d06dccf911961457fc38e70c3c35c8f85e4adc50c49db7999871f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7130feb08ab7b586c85a95986840fc5c0619cc3aee875313337fb5b379b39077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f482c24800748171e680ab578eac7a45e215b17d77d574ea0186ba9039a50d8b"
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
