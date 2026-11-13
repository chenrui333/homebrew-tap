class Npkill < Formula
  desc "Easily find and remove old and heavy node_modules folders"
  homepage "https://npkill.js.org"
  url "https://registry.npmjs.org/npkill/-/npkill-1.0.0.tgz"
  sha256 "8083e5bb475931a2558c11498ffd7e1bc306ee6073a19897eb32bf1d4433ad17"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b74601f2576035b77f0548cd9f30f4f6f74cdd3e7610c02d28ceafe75b333bce"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/npkill"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npkill --version")

    (testpath/"node_modules").mkpath
    output = shell_output("#{bin}/npkill -y --directory #{testpath} --json 2>&1", 1)
    assert_match "Oh no! Npkill does not support this terminal (TTY is required)", output
  end
end
