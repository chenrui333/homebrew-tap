class Secco < Formula
  desc "Local package testing made easy"
  homepage "https://secco.lekoarts.de/"
  url "https://registry.npmjs.org/secco/-/secco-4.0.1.tgz"
  sha256 "ee35ef438aedd47207203f64e3ee89997c4b78b2a8a0e0f4ace09649c0238ce3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "5ed69717fca1f27975ae95a2e423d4cf42d8016abaa4ae59f0a8fe736e572ba1"
    sha256 cellar: :any, arm64_tahoe:   "cad25932654374f87603ed592e58c3d274f7792e0fae72896062c7034114f086"
    sha256 cellar: :any, arm64_sequoia: "cad25932654374f87603ed592e58c3d274f7792e0fae72896062c7034114f086"
    sha256 cellar: :any, arm64_linux:   "4c61977bfa25c1ced5c87b5e75fb79cbc119452e8449700843f3ef109c2306ec"
    sha256 cellar: :any, x86_64_linux:  "1cd724cbaf82306f77c8d58a6bf11b495d64df28399a99f44cf26c55baf51d0a"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/secco"

    node_modules = libexec/"lib/node_modules/secco/node_modules"

    # Remove incompatible pre-built Bare module binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-buffer,bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secco --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0",
        "packageManager": "npm@10.0.0"
      }
    JSON

    system bin/"secco", "init", "--source", testpath, "--yes"
    assert_path_exists testpath/".seccorc"

    output = shell_output("#{bin}/secco --scan-once 2>&1", 1)
    assert_match "You haven't got any source dependencies in your current `package.json`", output
  end
end
