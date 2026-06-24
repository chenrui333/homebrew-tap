class Ktx < Formula
  desc "Executable context layer for data and analytics agents"
  homepage "https://github.com/Kaelio/ktx"
  url "https://registry.npmjs.org/@kaelio/ktx/-/ktx-0.13.1.tgz"
  sha256 "55d16c740dfc0be4b54c3e005ea68a004d7ec1e895191fea095328e384025515"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "68b2b98acd38aa7a1073ab8155aa476eb4fa5af0e29473ab4c2561521511ac49"
    sha256               arm64_sequoia: "116b42d8721dcfe958c7f6861dfc54a6b5bb1eb5b8657117acad04e55a41aa46"
    sha256               arm64_sonoma:  "425a1167f68da18db52ad983c80c2ec2f219348a4e026312f5c64e3814051138"
    sha256 cellar: :any, arm64_linux:   "7f9ef01ada9c3cd16407cb5cdc49ab908a1c0457265b117c5970425bf7bd37f4"
    sha256 cellar: :any, x86_64_linux:  "3093cfdce7b3240ff9faaf2cb267a8637bd56821a84fbf89a3a4dd4391856b25"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

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
