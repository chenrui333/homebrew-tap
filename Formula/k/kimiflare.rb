class Kimiflare < Formula
  desc "Terminal coding agent powered by Kimi-K2.6 on Cloudflare Workers AI"
  homepage "https://github.com/sinameraji/kimiflare"
  url "https://registry.npmjs.org/kimiflare/-/kimiflare-0.98.0.tgz"
  sha256 "aa1bed77048ec1bff66e0ed66961cff74bf7f55e014b54173c05202dbb1543c8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0b4dd7d17726c5eca7ab0ec19dbc36ca3438072994f8ffcf7b37b8e26ecf9a18"
    sha256 cellar: :any,                 arm64_sequoia: "0b4dd7d17726c5eca7ab0ec19dbc36ca3438072994f8ffcf7b37b8e26ecf9a18"
    sha256 cellar: :any,                 arm64_sonoma:  "0b4dd7d17726c5eca7ab0ec19dbc36ca3438072994f8ffcf7b37b8e26ecf9a18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "778d7894a075d3d7ffcd4626f22897cf074a54866106c6f398a7c8af7617288c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b59838a16f827f6aa3bd466b1a28a20e16e5235dfb32ad745b1d53687aadb81"
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
