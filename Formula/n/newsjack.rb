class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.20.tgz"
  sha256 "6b73fba7fd461940e5cec031c5d924745bcf4d89409204e0ad1fc10435c8a3d9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa17941a5fdf50be204813d72550009d3b6344243fe79fa9049bb64113ce5eff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa17941a5fdf50be204813d72550009d3b6344243fe79fa9049bb64113ce5eff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4764930dba3e0d7b0342bcc5b1d92109cd98092d8d3d7e0c5052cd43cb74361a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704a9cabae989f99aeae779299f09f593d41db8c7020cba1e712e9f4e3f4c498"
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
