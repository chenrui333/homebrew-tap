class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.29.tar.gz"
  sha256 "b895f5354f277bca46ffa03af712ae545611f742250bc4753bbc8f42a9dca21e"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09a39f3c8953951c6b7286f88b0ed412406b3128714dce79611b0ffb0af806f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9ba8334fd7f4fb4526c43a92a2531e79079d4148edf2a9ccf8eeda4e74be967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5737ac5a70ae75ba732fbd5d3d3f7b0f4df517412431f88d9fb1c9ff1b5ae314"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61d5126b56c96ce970cb39856625b6bf1b26767a87aa00c39eae46b02933c202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b96ff3083b6236a2e1de4e482b8d21732c543b5af1ee5e48135bb1d29469de9c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
