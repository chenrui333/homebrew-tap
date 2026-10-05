class Ktx < Formula
  desc "Executable context layer for data and analytics agents"
  homepage "https://github.com/Kaelio/ktx"
  url "https://registry.npmjs.org/@kaelio/ktx/-/ktx-0.16.0.tgz"
  sha256 "18bdbb165b90ee8c9e9d4d843e26d22451168db10353481b079fd8c01886dea3"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256               arm64_tahoe:   "3a650c626e234ca20d3181379ce4d6f748c7f2cbdd385f3d8b165ddba64188a7"
    sha256               arm64_sequoia: "3a650c626e234ca20d3181379ce4d6f748c7f2cbdd385f3d8b165ddba64188a7"
    sha256 cellar: :any, arm64_linux:   "0f2e7feabba225fef198b5801a82ae251a9c9fb64fa4f69ee874943efc2e36d7"
    sha256 cellar: :any, x86_64_linux:  "4a0294aedfd2dadfe5140e98e16ffa7594f3986844224d25216ce55151f9bdce"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = OS.linux? ? "#{os}-#{arch}-gnu" : "#{os}-#{arch}"
    minicore_dir = libexec/"lib/node_modules/@kaelio/ktx/node_modules/snowflake-sdk/dist/lib/minicore/binaries"
    minicore_dir.each_child { |binary| rm binary unless binary.basename.to_s.include?(native) }

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ktx --version")

    output = shell_output("#{bin}/ktx not-a-real-command 2>&1", 1)
    assert_match "unknown command 'not-a-real-command'", output
  end
end
