class Ktx < Formula
  desc "Executable context layer for data and analytics agents"
  homepage "https://github.com/Kaelio/ktx"
  url "https://registry.npmjs.org/@kaelio/ktx/-/ktx-0.15.0.tgz"
  sha256 "ef85a7cb65c2b74e9df2671c95bb71adf06fca6e59cd441ab1c49de114fbd7d8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "31e86890e0c270a487cd24b5ff01eae275ede43d6aadf53248eb7e56372929f5"
    sha256               arm64_sequoia: "2e06ca65b539794a4f246b36a63b24b7fd98f7db545b7494b36fd65cbfece559"
    sha256               arm64_sonoma:  "2e06ca65b539794a4f246b36a63b24b7fd98f7db545b7494b36fd65cbfece559"
    sha256 cellar: :any, arm64_linux:   "b23d8c29458018240ee9cc62a635b2f58a0f081c1ad65b92d8bec82f4fbb8973"
    sha256 cellar: :any, x86_64_linux:  "803377c63b97c86bc9a0628ceabc39f5f9e93b02d8b8d106f9232856c882a036"
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
