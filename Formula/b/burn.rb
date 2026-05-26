class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "cc4aa76e1c667b9a1f50af73b8638c8a7e9d09d1ac3fa5cb7bed57bd9d78457f"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=HEAD
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/burn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/burn version")
    output = shell_output("#{bin}/burn analyze 2>&1", 1)
    assert_match(/kube|config|cluster|connect/i, output)
  end
end
