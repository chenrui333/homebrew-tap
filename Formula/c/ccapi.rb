class Ccapi < Formula
  desc "Claude Code Commands Manager"
  homepage "https://github.com/4xian/claude-auto-api"
  url "https://registry.npmjs.org/@4xian/ccapi/-/ccapi-1.0.6.tgz"
  sha256 "7c9e54023dd10c8d612e5eb492ecf2ca0a721dbd2b03d76f167f96b69bc7a9b6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "c9cbaa68274a23e5e6b14241fb3804025f8b06c19b8bd4406ca122e39d332e68"
    sha256 cellar: :any,                 arm64_sonoma:  "69f6173b67b6dd1c2ad9928df9e6c8ddd1e1bb060ebbe3309e47e42b049dffae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0834573e8a6651b68127946bf05c47cd97eced58b316f64c12426e056ac1853a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/@4xian/ccapi/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-code/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccapi --version")

    output = shell_output("#{bin}/ccapi list 2>&1", 1)
    assert_match "列举配置失败: settings.json file path not set", output
  end
end
