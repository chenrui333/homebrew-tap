class Vibekit < Formula
  desc "Safety layer for your coding agent"
  homepage "https://www.vibekit.sh/"
  url "https://registry.npmjs.org/vibekit/-/vibekit-0.0.2.tgz"
  sha256 "80f31bf3f782c7293675ce9f1def338a815322e2648a0c52d2d21caed6344811"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f989834476012321bb667fcac5aeba25ccb9a7ea7eedcfaae6b421f1c4461eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c97659ee3b81833269df8c6c2a53d5fc9e19c9948d82506c70c94e231b1bedb7"
    sha256 cellar: :any_skip_relocation, ventura:       "2cde808e929b26ecb60b21ba3da54ff85725c7560322e6b1771918832d001810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3445c498760a484ae1309da165476495cb35cfb4068f67060111bec0dabe0a2"
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
