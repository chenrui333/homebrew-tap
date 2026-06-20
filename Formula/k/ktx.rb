class Ktx < Formula
  desc "Executable context layer for data and analytics agents"
  homepage "https://github.com/Kaelio/ktx"
  url "https://registry.npmjs.org/@kaelio/ktx/-/ktx-0.13.0.tgz"
  sha256 "5f3bce91f20c3b8c9b13a9a8a4e10102162b61609e8e7b24ed0b88af1fde1816"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "b72bfa68a5adcc1684e6fa7a129b98cfe0c2cc6d46431d4f21f19f7958e29dc0"
    sha256               arm64_sequoia: "27c073ea3e4f30577dc96ef5baaa8ef0d5bcb1c96aebdecb4e3f0fb1c8fa6834"
    sha256               arm64_sonoma:  "27c073ea3e4f30577dc96ef5baaa8ef0d5bcb1c96aebdecb4e3f0fb1c8fa6834"
    sha256 cellar: :any, arm64_linux:   "5714ccf141bf5489154f40fb852c55eb6f5510b6aede78ffbfa768c21c90bf6e"
    sha256 cellar: :any, x86_64_linux:  "e23f394478decc026a0c9d248a0f057e654e8067472e30334698823969d2529e"
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
