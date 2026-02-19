class Fence < Formula
  desc "Lightweight sandbox with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.27.tar.gz"
  sha256 "78a98ff08b1ec2589b261798750db4d48862beb845ba9f3fcdebc4275a8a21d3"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildTime=#{time.iso8601} -X main.gitCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    output = shell_output("#{bin}/fence --debug -c 'echo hello && ls' 2>&1", 71)
    assert_match "[fence] Sandbox manager cleaned up", output
  end
end
