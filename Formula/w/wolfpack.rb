class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.26.tgz"
  sha256 "e003f66b1145a2f8e356e72fa35c3c8ad203e4d31ee4cbb2c597028139871e09"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "07fe95f34d795bd3a679372ae3e3903e5037c344673aa264546d2bf0c3367c77"
    sha256                               arm64_sequoia: "07fe95f34d795bd3a679372ae3e3903e5037c344673aa264546d2bf0c3367c77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "204d91936f05197dc7c5c2a62e5a88735ccb4b914ca7078ae9bbe22596c7efad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cda8b445a72892c1dd27ecbaadacfe00e6dd956c2662b0316b709152d0bf65b"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wolfpack --version")

    output = shell_output("#{bin}/wolfpack not-a-real-command 2>&1", 1)
    assert_match "Unknown command: not-a-real-command", output
  end
end
