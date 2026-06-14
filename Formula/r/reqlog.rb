class Reqlog < Formula
  desc "Trace and filter requests across distributed systems"
  homepage "https://github.com/SagarMaheshwary/reqlog"
  url "https://github.com/SagarMaheshwary/reqlog/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "14472781e7a5049c01c08b4957279c5be6196d2ae9382c50cf66add794e6c094"
  license "MIT"
  head "https://github.com/SagarMaheshwary/reqlog.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe22888c81094af02d8e408d847f7e4e4d4db13157af17cbce96d6cbeb251af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe22888c81094af02d8e408d847f7e4e4d4db13157af17cbce96d6cbeb251af7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe22888c81094af02d8e408d847f7e4e4d4db13157af17cbce96d6cbeb251af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9da343045ec32154365c42d2464577bf9c534d215cd2590c0118cc06b3d3f9e4"
    sha256 cellar: :any,                 x86_64_linux:  "10f9ad9b23223735a85ab40ecc8b0c7a0b8796148d8c2a8cd4b4b25934dfdc96"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/reqlog"
  end

  test do
    assert_match "reqlog version #{version}", shell_output("#{bin}/reqlog --version")
    output = shell_output("#{bin}/reqlog not-a-real-command 2>&1", 1)
    assert_match "no matching sources found", output
  end
end
