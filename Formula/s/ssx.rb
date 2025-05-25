# framework: cobra
class Ssx < Formula
  desc "Retentive ssh client"
  homepage "https://ssx.vimiix.com/"
  url "https://github.com/vimiix/ssx/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "fae6de5047f4f9adc959078ffc3b1f03cd1c1d7294f2ec6a797a4ff5dbbfbd7a"
  license "MIT"
  head "https://github.com/vimiix/ssx.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vimiix/ssx/ssx/version.Version=#{version}
      -X github.com/vimiix/ssx/ssx/version.Revision=#{tap.user}
      -X github.com/vimiix/ssx/ssx/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ssx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssx --version")

    expected_output = if OS.mac?
      "operation not permitted"
    else
      "lookup 100: no such host"
    end
    assert_match expected_output, shell_output("#{bin}/ssx 100 2>&1", 1)
  end
end
