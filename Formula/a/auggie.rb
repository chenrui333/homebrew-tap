class Auggie < Formula
  desc "All the power of Augment Code in your terminal"
  homepage "https://www.augmentcode.com/product/CLI"
  url "https://registry.npmjs.org/@augmentcode/auggie/-/auggie-0.34.0.tgz"
  sha256 "c14231c3e6af127d220d700040d904e99c11e34eda1532075592071c470e4fdb"
  license :cannot_represent

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b78ad4caf3788dadbae2210a86942a2f627a1fd1d8d66f1dcc00a1bacd2ed13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b78ad4caf3788dadbae2210a86942a2f627a1fd1d8d66f1dcc00a1bacd2ed13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b78ad4caf3788dadbae2210a86942a2f627a1fd1d8d66f1dcc00a1bacd2ed13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89eadce26a20cdff357b4ce5ff005d239cae518757e0c7d69a6dbf3dc7e105d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9e1c1452e0dbadf29a67fe501724c38c2286be84b47ddb1c92a41be0f00b25"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}"
    prebuild_dir = libexec/"lib/node_modules/@augmentcode/auggie/node_modules/node-pty/prebuilds"
    prebuild_dir.each_child { |dir| rm_r(dir) if dir.basename.to_s != native }

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auggie --version")

    tools_output = shell_output("#{bin}/auggie tools list")
    assert_match "Total:", tools_output

    model_output = shell_output("#{bin}/auggie model list 2>&1", 1)
    assert_match "not currently logged in", model_output
  end
end
