class Vibekit < Formula
  desc "Safety layer for your coding agent"
  homepage "https://www.vibekit.sh/"
  url "https://registry.npmjs.org/vibekit/-/vibekit-0.0.2.tgz"
  sha256 "80f31bf3f782c7293675ce9f1def338a815322e2648a0c52d2d21caed6344811"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "050cec841120fbe57ff7a995048012e30f4df3d8d59c533dd73c8cda40100185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e9b84ee665857d6f6bca148193c79ad764409e6ee240691fdc0e1a3744b0b32"
    sha256 cellar: :any_skip_relocation, ventura:       "f4f49bbed14db8f89bb97f87436cf50695c289f8e52aaa5045722dc5732fd983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd06251415b16ec235a09b0994ca952a1d530352e71ca425956ebeea847fe7fa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibekit --version")

    expected = if OS.mac?
      "Status: DISABLED"
    else
      "Status: ENABLED"
    end
    assert_match expected, shell_output("#{bin}/vibekit sandbox status")
    assert_match "No analytics data found", shell_output("#{bin}/vibekit analytics --summary")
  end
end
