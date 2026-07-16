class Reqlog < Formula
  desc "Trace and filter requests across distributed systems"
  homepage "https://github.com/SagarMaheshwary/reqlog"
  url "https://github.com/SagarMaheshwary/reqlog/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c979b44c9b12d8b164ff981146f5cfc158ca380c9c9b7c865290f1db2e7f7a34"
  license "MIT"
  head "https://github.com/SagarMaheshwary/reqlog.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9242c03e63d761a0b70e0227346b7019dd3386b573c417ffc3bfb5553e91c0a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9242c03e63d761a0b70e0227346b7019dd3386b573c417ffc3bfb5553e91c0a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9242c03e63d761a0b70e0227346b7019dd3386b573c417ffc3bfb5553e91c0a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "463988caa78bd474b9c36cc3a64fcc6ee64adbc6ef484bde403ed6e5a956c277"
    sha256 cellar: :any,                 x86_64_linux:  "36da8719f641f637f18f1febfd30231d6efc14192873aeeab539c08132f71c33"
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
