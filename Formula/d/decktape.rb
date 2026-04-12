class Decktape < Formula
  desc "PDF exporter for HTML presentations"
  homepage "https://github.com/astefanutti/decktape"
  url "https://registry.npmjs.org/decktape/-/decktape-3.16.0.tgz"
  sha256 "69555736650d0c92a95c1c38fcc4a51028c96e263acb1c2bb0b47925ef9804af"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a80489e3c918ea521eda682489ba7a2cc263c3e9942b1c17b920c939c70f27d2"
    sha256 cellar: :any,                 arm64_sequoia: "3ec8c4e41980244707b23bd4a3a572263a220c0c505641192e75878594da812d"
    sha256 cellar: :any,                 arm64_sonoma:  "3ec8c4e41980244707b23bd4a3a572263a220c0c505641192e75878594da812d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69eccfddcba9085beef922533e88161aef795963a13f6f918ad79c352475d38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ee0f72f0076b5967779d5bceb0abdb99c5d084e99ddcc3323197dbc2d5ea26"
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
