class Granted < Formula
  desc "Easiest way to access your cloud"
  homepage "https://granted.dev/"
  url "https://github.com/fwdcloudsec/granted/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "b6e2bc8fda38f55ee4673cc0f3f762e076d2029df1d9a8552681a2aacce88721"
  license "MIT"
  head "https://github.com/fwdcloudsec/granted.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/common-fate/granted/internal/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/granted"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/granted --version")

    output = shell_output("#{bin}/granted auth configure 2>&1", 1)
    assert_match "[✘] please provide a url argument", output
  end
end
