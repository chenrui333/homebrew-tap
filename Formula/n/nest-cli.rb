class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-11.0.14.tgz"
  sha256 "87de34f4ec2b8e96a8e8e1d6c328366fadaf0612942991861c9d5d97f42fec64"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "22aaef30bdb2b4119562ea6626ca526c3503c78b54ecdc26f832466bcbc7e0f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/@nestjs/cli/nest-app/node_modules/{@napi-rs,@swc}/*")
           .each { |dir| rm_r(dir) unless dir.basename.to_s.include?("#{os}-#{arch}") }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nest --version")

    output = shell_output("#{bin}/nest info")
    assert_match "System Information", output
  end
end
