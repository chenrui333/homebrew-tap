class Npkill < Formula
  desc "Easily find and remove old and heavy node_modules folders"
  homepage "https://npkill.js.org"
  url "https://registry.npmjs.org/npkill/-/npkill-1.0.0.tgz"
  sha256 "8083e5bb475931a2558c11498ffd7e1bc306ee6073a19897eb32bf1d4433ad17"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "d235ddf7e5640c7f661d4f4fd0bdcb68ffd35f112162ac6b51cc05f48cc9cb71"
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
    output = JSON.parse(shell_output("#{bin}/npkill --directory #{testpath} --json"))
    assert_equal 1, output.fetch("meta").fetch("resultsCount")
    assert_equal (testpath/"node_modules").realpath.to_s, output.fetch("results").first.fetch("path")
  end
end
