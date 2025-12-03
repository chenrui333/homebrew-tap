class Ibtop < Formula
  desc "Real-time terminal monitor for InfiniBand networks"
  homepage "https://github.com/JannikSt/ibtop"
  url "https://github.com/JannikSt/ibtop/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "2a71b8cbb1f9b4172624c6191b535ddc5c3b1a0fec98750741f9d88949ccab0f"
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
