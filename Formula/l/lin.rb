class Lin < Formula
  desc "Lazy I18N"
  homepage "https://lin.rettend.me/"
  url "https://registry.npmjs.org/@yuo-app/lin/-/lin-2.1.0.tgz"
  sha256 "d3172928f3a279b1d4207bd7bc1167aab2e972d623fd100763e250381fa915bb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45dbfd73bdc843c6b29592014ab9a9fbf5f244c7cc0a91818758cbbc8e62e3ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45dbfd73bdc843c6b29592014ab9a9fbf5f244c7cc0a91818758cbbc8e62e3ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aeee7d9e7c6daffd4d8a699040486bcc9c6ab993db4866c46614631d174d83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c24af017a7ed27705559bd1549c027f7a3ebee37e1b22982b808b6bb07801b9"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lin --version")

    output = shell_output("#{bin}/lin models")
    assert_match "Available Models", output

    output = shell_output("#{bin}/lin check")
    assert_match "All keys are in sync", output
  end
end
