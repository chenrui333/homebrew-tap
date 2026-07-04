class Ktx < Formula
  desc "Executable context layer for data and analytics agents"
  homepage "https://github.com/Kaelio/ktx"
  url "https://registry.npmjs.org/@kaelio/ktx/-/ktx-0.16.0.tgz"
  sha256 "18bdbb165b90ee8c9e9d4d843e26d22451168db10353481b079fd8c01886dea3"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "4ae4c199c050c71e588b9affe26df5f1164898393c7e15c8d50ad9c8594c3225"
    sha256               arm64_sequoia: "07d79db26bdfc9591ab5c475f6ce9f60e42a3272158c254d7919a7ccf636147e"
    sha256               arm64_sonoma:  "07d79db26bdfc9591ab5c475f6ce9f60e42a3272158c254d7919a7ccf636147e"
    sha256 cellar: :any, arm64_linux:   "a665cc84bac7a4581f9ff35472fab120be26b9326065e3537d7fc5f5dac148b8"
    sha256 cellar: :any, x86_64_linux:  "422b01400bff3a6ca23034274a6bb6b09fe4aa855407cd78fb532d47c7a50788"
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
