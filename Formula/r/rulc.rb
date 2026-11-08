class Rulc < Formula
  desc "REPL and terminal calculator with plotting support"
  homepage "https://github.com/imizgun/rulc"
  url "https://github.com/imizgun/rulc/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "929c93d987baf96177503b5148b588c993179f5eb2eebdec3d136ae3e5ddcc79"
  license "GPL-3.0-or-later"
  head "https://github.com/imizgun/rulc.git", branch: "master"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, pipe_output(bin/"rulc", "", 0)
    assert_match ">> 14", shell_output("#{bin}/rulc --exec '2 + 3 * 4'")
    assert_match ">> 256", shell_output("#{bin}/rulc --exec '2 ^ 8'")
  end
end
