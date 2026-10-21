class NestCli < Formula
  desc "CLI tool for Nest applications"
  homepage "https://nestjs.com/"
  url "https://registry.npmjs.org/@nestjs/cli/-/cli-12.0.10.tgz"
  sha256 "bab87c9918256af73b3d458c5f4bb016cb6f9a9a3f9a0560315c18667597cd0b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6a1b7755b0116a789275202b0fd62d16566b75fec3c16584934c5f00d529d5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6a1b7755b0116a789275202b0fd62d16566b75fec3c16584934c5f00d529d5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc598deb5c1954048e6e2bb68b87d40f70471adca7d16a327cb6f98eb44126e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc598deb5c1954048e6e2bb68b87d40f70471adca7d16a327cb6f98eb44126e7"
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
