class Watchtower < Formula
  desc "Terminal-based global intelligence dashboard"
  homepage "https://github.com/lajosdeme/watchtower"
  url "https://github.com/lajosdeme/watchtower/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "adfda1e600986674818b20e89e24ac389f9f4c48273dc28f4f01f9214a08655e"
  license "MIT"
  head "https://github.com/lajosdeme/watchtower.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/watchtower --version")
    assert_match "watchtower #{version}", output
    assert_match "commit:", output
  end
end
