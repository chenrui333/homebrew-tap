class Decktape < Formula
  desc "PDF exporter for HTML presentations"
  homepage "https://github.com/astefanutti/decktape"
  url "https://registry.npmjs.org/decktape/-/decktape-3.16.1.tgz"
  sha256 "20e4fe92c367f668d87f7a6db41d8ae306e5dde4cdba4bee61453adb98de43fa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "251090233280af8501a49a8b17b5758e4c67082cb9b03425297ae341faeee265"
    sha256 cellar: :any,                 arm64_sequoia: "6dbf4835495375b293aa137d292becc974c2f9f808de7f5a78d5adf708430553"
    sha256 cellar: :any,                 arm64_sonoma:  "6dbf4835495375b293aa137d292becc974c2f9f808de7f5a78d5adf708430553"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ed7c9b45b2233759cac46c35979e33bd926867e563201c983efd4eb1846c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f1cf4d2f481dbb227390968bcfe62b1b7289d181f160992ef9e56e3636aedb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/decktape/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decktape version")
  end
end
