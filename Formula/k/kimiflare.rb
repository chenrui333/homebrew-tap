class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.90.0.tgz"
  sha256 "e31c337fbd235e7baf00a2adc6073d45bde8cecc87f41ee923ce7d925e5ee3d0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "12cf30814ee0ab34f967d264b8098e847376128b4fffa3a0d885d6fc140f6a23"
    sha256 cellar: :any,                 arm64_sequoia: "48f9ae94226bfe5a5c5e82c8fdea07208ff35a0a64dfa3edffc3f39cb80adb9a"
    sha256 cellar: :any,                 arm64_sonoma:  "48f9ae94226bfe5a5c5e82c8fdea07208ff35a0a64dfa3edffc3f39cb80adb9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e741ba1b30a8a685f21733ba5c22a4451f1d3d870cc35a955e2285c7a215233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a0d750857ec2646f3f28607ba193e0a792161ecc0cfd3a07561227223f482c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    prebuilds = libexec/"lib/node_modules/kimiflare/node_modules/isolated-vm/prebuilds"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    keep = "#{platform}-#{arch}"
    if prebuilds.directory?
      prebuilds.children.each { |dir| rm_r(dir) if dir.basename.to_s != keep }
      (prebuilds/keep).glob("*.musl.node").each(&:unlink) if OS.linux?
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimiflare --version")
    output = shell_output("#{bin}/kimiflare --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
