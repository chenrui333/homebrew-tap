class Reqlog < Formula
  desc "Trace and filter requests across distributed systems"
  homepage "https://github.com/SagarMaheshwary/reqlog"
  url "https://github.com/SagarMaheshwary/reqlog/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "14472781e7a5049c01c08b4957279c5be6196d2ae9382c50cf66add794e6c094"
  license "MIT"
  head "https://github.com/SagarMaheshwary/reqlog.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73de736d9f7a2495241e5be8224ed91b8108f4da1116ef4c27acb3beafecec1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73de736d9f7a2495241e5be8224ed91b8108f4da1116ef4c27acb3beafecec1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73de736d9f7a2495241e5be8224ed91b8108f4da1116ef4c27acb3beafecec1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc5340f1b496c46e31b0f0a7e8ed502a2710fdd17c67053cc62680cddb840d4"
    sha256 cellar: :any,                 x86_64_linux:  "a991c6c463e2824b0c94931061504fa4b2f045c4932be4ffe16c9356e54701ed"
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
