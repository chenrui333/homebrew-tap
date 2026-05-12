class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "676086bca476c2d4748149390f2fea9a9f9728e885259bbe46c90d12637494b7"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
