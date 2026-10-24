class Reqlog < Formula
  desc "Trace and filter requests across distributed systems"
  homepage "https://github.com/SagarMaheshwary/reqlog"
  url "https://github.com/SagarMaheshwary/reqlog/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "bb6db20acad0f6d249001e50606b157a1bee6097af343057971477ffe7590a59"
  license "MIT"
  head "https://github.com/SagarMaheshwary/reqlog.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79687c5ba5a369bf1d872ee0998a7b4285a00f586273783fa4d689eba31f4e8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79687c5ba5a369bf1d872ee0998a7b4285a00f586273783fa4d689eba31f4e8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba93786decbc33c803711c0ac964fbf34c4163a38bd9c26b69a86564c574735"
    sha256 cellar: :any,                 x86_64_linux:  "c9994a14fe3e2a60254b97557d192bc0cf7e1725e56611505c9ddbc7ea21807d"
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
