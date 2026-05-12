class Purple < Formula
  desc "Terminal SSH config manager and cockpit for your servers"
  homepage "https://github.com/erickochen/purple"
  url "https://github.com/erickochen/purple/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "4a292fe2b456842be9ecf4d633bf81812cdef1f67bb8c16c355605dc76464b93"
  license "MIT"
  head "https://github.com/erickochen/purple.git", branch: "master"

  depends_on "openssl@3"
  depends_on "rust" => :build

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/purple --version 2>&1")
  end
end
