# framework: cobra
class Dbin < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/xplshn/dbin"
  url "https://github.com/xplshn/dbin/archive/refs/tags/0.9.tar.gz"
  sha256 "d363fb2ea4182386f2c95c1db5838f64c6ed6457b51706250c08017f295f3c69"
  license any_of: ["ISC", "RABRMS"]
  head "https://github.com/xplshn/dbin.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbin --version 2>&1", 1)

    output = shell_output("#{bin}/dbin del bed 2>&1")
    assert_match "Failed to retrieve full name for 'bed#'", output
  end
end
