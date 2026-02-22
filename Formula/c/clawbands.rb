class Clawbands < Formula
  desc "Security middleware for OpenClaw agents"
  homepage "https://github.com/SeyZ/clawbands"
  url "https://github.com/SeyZ/clawbands/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e9df3d7c86533340b398588e889ec0122d9e4d6ec19a5af6ae96ce46485162a3"
  license "MIT"
  head "https://github.com/SeyZ/clawbands.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "23a0ec28ea5a666b041531a51fc007ef55161b04b02aa8d83820c5f79745157d"
  end

  depends_on "node"

  def install
    system "npm", "install", "--include=dev",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["OPENCLAW_HOME"] = testpath/".openclaw"

    assert_match version.to_s, shell_output("#{bin}/clawbands --version")

    output = shell_output("#{bin}/clawbands stats")
    assert_match "No activity recorded yet.", output
    assert_path_exists testpath/".openclaw/clawbands/stats.json"
  end
end
