class Watchtower < Formula
  desc "Terminal-based global intelligence dashboard"
  homepage "https://github.com/lajosdeme/watchtower"
  url "https://github.com/lajosdeme/watchtower/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "adfda1e600986674818b20e89e24ac389f9f4c48273dc28f4f01f9214a08655e"
  license "MIT"
  head "https://github.com/lajosdeme/watchtower.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "699fb0a502f2ad71b3fa033e50d223e5c90d531745760906d6a5603810571432"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "699fb0a502f2ad71b3fa033e50d223e5c90d531745760906d6a5603810571432"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "267c5e4ab983852b6facd5307d983756d9ac9f586130bed70e3cb1a258718885"
    sha256 cellar: :any,                 x86_64_linux:  "885b2957039c89b8786434ca51c8230f7f969b6da5938aefba5c0bf01f2c2bd3"
  end

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
