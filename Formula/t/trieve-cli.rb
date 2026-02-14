class TrieveCli < Formula
  desc "CLI for interacting with the Trieve API"
  homepage "https://docs.trieve.ai/getting-started/introduction"
  url "https://registry.npmjs.org/trieve-cli/-/trieve-cli-0.0.6.tgz"
  sha256 "32ea5734673d82a3f34d45539ef40b2cae7945232dfef9fdf227903171b97b43"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2b84e0e0211050a59e9075aec0b0665a569d3cc628055c0f128fdecc8c619bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61557c71042b4f5e695236f9f09de225a01cbca89c9b7394cc3e74802f6aa06c"
    sha256 cellar: :any_skip_relocation, ventura:       "61dd577f49c26aa7a7b59eb84eda623c8e4a6270cea7ef943165a9c495e656ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac13b363917f8b9398a654369ce6a9ae7e3caa7581064204cc3490b5e713e855"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trieve --version")

    output = shell_output("#{bin}/trieve check-upload-status")
    assert_match "No files have been uploaded yet", output
  end
end
