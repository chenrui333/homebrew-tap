class Vibekit < Formula
  desc "Safety layer for your coding agent"
  homepage "https://www.vibekit.sh/"
  url "https://registry.npmjs.org/vibekit/-/vibekit-0.0.4.tgz"
  sha256 "0d636445799fc10b0b9c46ad84030f562cddc1f9f70d010fe59357c3f871c19a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20edcb9dcfe421aa7d635612326caea5b8e317c429213c1579f47dcbf5f5ce08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a2a93b699121cf044712c4d69a36d3d08951b728025a675e3301d956fac88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae6e9bd2c6c9799c31ce4b10d3a13eb1288396008b6046a6ec4c512859df5cc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
