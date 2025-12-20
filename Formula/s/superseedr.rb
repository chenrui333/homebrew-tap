class Superseedr < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.28.tar.gz"
  sha256 "496d081ca1bcd7df05dfc4b2532a0fd8fb0b0e92a67f28f1a3277892fe6334fb"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
