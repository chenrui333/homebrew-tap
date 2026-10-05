class Ibtop < Formula
  desc "Real-time terminal monitor for InfiniBand networks"
  homepage "https://github.com/JannikSt/ibtop"
  url "https://github.com/JannikSt/ibtop/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "207892a84711b37891a1a3a70e325d673d0cbf12164b23539f2fd13c10af7f7a"
  license "Apache-2.0"
  head "https://github.com/JannikSt/ibtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "af499bcfdcadb107e16bc58ba071533b883a8e78d7e78324ffef5dcda76c19ec"
    sha256 cellar: :any, x86_64_linux: "c20a1fc610fa8f5f828ff3f3355ee60187ae3646f8e84be80e462b9040605d12"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/ibtop --version")
  end
end
