class Ccql < Formula
  desc "Claude Code Query Language"
  homepage "https://github.com/douglance/ccql"
  url "https://github.com/douglance/ccql/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7232525ed2a208d4f35533a57254bac05b8191e17cb9c567f772de66fd634774"
  license "MIT"
  head "https://github.com/douglance/ccql.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccql --version")
    (testpath/".claude").mkpath
    assert_match "Total: 0 todos", shell_output("#{bin}/ccql todos")
  end
end
