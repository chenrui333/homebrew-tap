class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.19.tgz"
  sha256 "e4e8dc36f2672b4abca9854f4e76de542192ca89edc506a2be6905289db41fd8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f1bff4714afbc81233fde4140356b805213679c51e2762510c431888d3eb117"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f1bff4714afbc81233fde4140356b805213679c51e2762510c431888d3eb117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c538d5c379cf2ac224fb30203e7da1375ddf95e3aae91d6af8bcbfbb039c6e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c2561ba6cbf93204d62fbf08d2d80537bb21ebec2d6a2470c64e2ed2c158b1c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsjack --version")

    output = shell_output("NEWSJACK_AUTO_UPDATE=0 #{bin}/newsjack doctor --json")
    assert_match '"root_ok": true', output
  end
end
