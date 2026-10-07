class TrieveCli < Formula
  desc "CLI for interacting with the Trieve API"
  homepage "https://github.com/devflowinc/trieve"
  url "https://registry.npmjs.org/trieve-cli/-/trieve-cli-0.0.6.tgz"
  sha256 "32ea5734673d82a3f34d45539ef40b2cae7945232dfef9fdf227903171b97b43"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8b4c63c71019b8f8f60fcf7a763a4e853fa61c75ca03e64750d956cb9fa5cfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8b4c63c71019b8f8f60fcf7a763a4e853fa61c75ca03e64750d956cb9fa5cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "806c0769b82359325cb9e1473fb74194e6c00d9fc5674c6ae617e43983e7396c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "806c0769b82359325cb9e1473fb74194e6c00d9fc5674c6ae617e43983e7396c"
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
    assert_match version.to_s, shell_output("#{bin}/trieve --version")

    output = shell_output("#{bin}/trieve check-upload-status")
    assert_match "No files have been uploaded yet", output
  end
end
