class Tapflow < Formula
  desc "Self-hosted iOS and Android simulator streaming for the whole team"
  homepage "https://github.com/jo-duchan/tapflow"
  url "https://registry.npmjs.org/tapflow/-/tapflow-0.10.0.tgz"
  sha256 "9209b24b6b65b95e34fa5e8e585d745f3b2aaf6f66e04849869824597735f68c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "0e13a4fe6b2cd89d94016383d6a435ed7afed5ce30889ea101c93b992d2c416e"
  end

  depends_on :macos
  depends_on "node"

  on_macos do
    depends_on macos: :tahoe
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tapflow --version")

    output = shell_output("#{bin}/tapflow admin not-a-real-subcommand 2>&1", 1)
    assert_match "Unknown subcommand: admin not-a-real-subcommand", output
  end
end
