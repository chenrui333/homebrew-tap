class Decktape < Formula
  desc "PDF exporter for HTML presentations"
  homepage "https://github.com/astefanutti/decktape"
  url "https://registry.npmjs.org/decktape/-/decktape-3.17.0.tgz"
  sha256 "e3ca52be23715030dd8abd7e2744e3ef01c35f52a307ab85563d9614bc7d3234"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef9e55d0af8ed4cf9768d08c2ca28c19f6f3aea7d9ac4311ccd6872ce1cf62ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9e55d0af8ed4cf9768d08c2ca28c19f6f3aea7d9ac4311ccd6872ce1cf62ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "656a656e89341b27f7de8d391f9a048c409e2ca59ed08fc2b6f842bceebc6cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "656a656e89341b27f7de8d391f9a048c409e2ca59ed08fc2b6f842bceebc6cf7"
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

    node_modules = libexec/"lib/node_modules/decktape/node_modules"

    # Remove incompatible pre-built Bare module binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decktape version")

    output = shell_output("#{bin}/decktape --size bad file:///nonexistent #{testpath}/slides.pdf 2>&1", 1)
    assert_match "<size> must follow the <width>x<height> notation", output
  end
end
