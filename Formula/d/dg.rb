class Dg < Formula
  desc "Self-testing CLI documentation tool that generates interactive demos"
  homepage "https://deepguide.ai/"
  url "https://registry.npmjs.org/@deepguide-ai/dg/-/dg-3.1.5.tgz"
  sha256 "1b5eb887fbbff8488d3f19f0b8a5954265a6ad20515d064eda5c18ee9701d66f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "b11d8fca9ed79ec30882e4f816e42525d4652f8741aef03e7e1b09bae0cf8a57"
    sha256                               arm64_sonoma:  "f295b06e219a2d41888a87f58f0d98e48e2f7de16eeaa3c878c431ea8a94d279"
    sha256                               ventura:       "86382fb5157f546d06a397607055cb744939930ffc686649f57cff608d6c3830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc13bcca752fc16f33005b095e011acc146df74f8a239dc9c3513176b86e1785"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "❌ No config found", shell_output("#{bin}/dg list")
  end
end
