class Reqlog < Formula
  desc "Trace and filter requests across distributed systems"
  homepage "https://github.com/SagarMaheshwary/reqlog"
  url "https://github.com/SagarMaheshwary/reqlog/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "578b075aec1253241085424f8a9f733a5e44217ba6ec4eb375dd93ec7bbd2363"
  license "MIT"
  head "https://github.com/SagarMaheshwary/reqlog.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbd38db3973ece1f4cb7a79a9b64d5f3552f2d019660804f10c44128553889fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbd38db3973ece1f4cb7a79a9b64d5f3552f2d019660804f10c44128553889fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbd38db3973ece1f4cb7a79a9b64d5f3552f2d019660804f10c44128553889fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2850793f6170ab409eb625715a9f7cfefd794d4d0048fef9601252c8ecf7879a"
    sha256 cellar: :any,                 x86_64_linux:  "8c5dff67397af6ce1d845329d1e9452365be72652570fdbd4416340057ed4baf"
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
