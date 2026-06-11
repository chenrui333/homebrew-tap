class Reqlog < Formula
  desc "Trace and filter requests across distributed systems"
  homepage "https://github.com/SagarMaheshwary/reqlog"
  url "https://github.com/SagarMaheshwary/reqlog/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "14472781e7a5049c01c08b4957279c5be6196d2ae9382c50cf66add794e6c094"
  license "MIT"
  head "https://github.com/SagarMaheshwary/reqlog.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/reqlog"
  end

  test do
    assert_match "reqlog version #{version}", shell_output("#{bin}/reqlog --version")
    assert_match "Search, trace, and stream logs", shell_output("#{bin}/reqlog --help 2>&1")
  end
end
