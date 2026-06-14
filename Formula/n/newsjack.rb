class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.10.tgz"
  sha256 "4d429c92e7d28b99835a738aeb365375ec3ded28b520166fff1f309c0a0ffe0f"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsjack --version")
    assert_match "newsjack", shell_output("#{bin}/newsjack --help")
  end
end
