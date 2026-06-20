class Ktx < Formula
  desc "Executable context layer for data and analytics agents"
  homepage "https://github.com/Kaelio/ktx"
  url "https://registry.npmjs.org/@kaelio/ktx/-/ktx-0.13.0.tgz"
  sha256 "5f3bce91f20c3b8c9b13a9a8a4e10102162b61609e8e7b24ed0b88af1fde1816"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "eb26549ec1251f5ff8bdac880ae82b791d9c5f2866d5c1a6f2e99b499fba1ab5"
    sha256                               arm64_sequoia: "809b1240e3dccf815d666dca58dda8821a5085f92f33f6a0c43ec5c83be018f9"
    sha256                               arm64_sonoma:  "809b1240e3dccf815d666dca58dda8821a5085f92f33f6a0c43ec5c83be018f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b298a034cc4d7b35ec8dc47f07d901ca23797ec4e0b413b110f137e45715136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0c97399baed045106935d1904706108bdf95366158bc1da5e158dc14fae0a53"
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
