class Reqlog < Formula
  desc "Trace and filter requests across distributed systems"
  homepage "https://github.com/SagarMaheshwary/reqlog"
  url "https://github.com/SagarMaheshwary/reqlog/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c979b44c9b12d8b164ff981146f5cfc158ca380c9c9b7c865290f1db2e7f7a34"
  license "MIT"
  head "https://github.com/SagarMaheshwary/reqlog.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4364e98c560977c26d2fce3288355d22da7094dae76298aaee54688b32a96136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4364e98c560977c26d2fce3288355d22da7094dae76298aaee54688b32a96136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e8df62791bec9428ee510a09d26560f9ef1f4b3793d0aa9dc9c6de4fad390ba"
    sha256 cellar: :any,                 x86_64_linux:  "2e2bb24f4fba7c576267d68080ff725fa2fac92e4f3c7a45554c1486156bdc1a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
