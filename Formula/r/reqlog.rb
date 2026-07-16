class Reqlog < Formula
  desc "Trace and filter requests across distributed systems"
  homepage "https://github.com/SagarMaheshwary/reqlog"
  url "https://github.com/SagarMaheshwary/reqlog/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c979b44c9b12d8b164ff981146f5cfc158ca380c9c9b7c865290f1db2e7f7a34"
  license "MIT"
  head "https://github.com/SagarMaheshwary/reqlog.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46cd8d90f70e35118c5b9ef0a602668fc034342c301aa946351940b76f5b643e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46cd8d90f70e35118c5b9ef0a602668fc034342c301aa946351940b76f5b643e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46cd8d90f70e35118c5b9ef0a602668fc034342c301aa946351940b76f5b643e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dd3be72b6bc9af0acd1c99f3c7e2596f7605fb5fddd986ca5558bd10c617325"
    sha256 cellar: :any,                 x86_64_linux:  "ab313e1300b1d96a62ff30cd57355ee2677b3d53d95943fc3a02e263576ba048"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/reqlog"
  end

  test do
    assert_match "reqlog version #{version}", shell_output("#{bin}/reqlog --version")
    (testpath/"logs").mkpath
    output = shell_output("#{bin}/reqlog not-a-real-command 2>&1", 1)
    assert_match "no matching sources found", output
  end
end
