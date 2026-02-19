class Ibtop < Formula
  desc "Real-time terminal monitor for InfiniBand networks"
  homepage "https://github.com/JannikSt/ibtop"
  url "https://github.com/JannikSt/ibtop/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "207892a84711b37891a1a3a70e325d673d0cbf12164b23539f2fd13c10af7f7a"
  license "Apache-2.0"
  head "https://github.com/JannikSt/ibtop.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/ibtop --version")
  end
end
