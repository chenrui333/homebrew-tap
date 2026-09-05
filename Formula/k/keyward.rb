class Keyward < Formula
  desc "Manage SSH keys and audit SSH configuration"
  homepage "https://github.com/gateway-of-last-resort/keyward"
  url "https://github.com/gateway-of-last-resort/keyward/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "0b726b18bfe8dc3b8c0d06ce2f833a35c7f35279b2440e70bced5acc7004c8c8"
  license "MIT"
  head "https://github.com/gateway-of-last-resort/keyward.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/keyward"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keyward --version")
    (testpath/".ssh").mkpath
    assert_empty JSON.parse(shell_output("#{bin}/keyward list --json"))
  end
end
