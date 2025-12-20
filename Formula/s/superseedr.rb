class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.28.tar.gz"
  sha256 "496d081ca1bcd7df05dfc4b2532a0fd8fb0b0e92a67f28f1a3277892fe6334fb"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03f32a9e0280b4629b3f15427c53fafb789a9828c8e55709b2a7856250dffd03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d5a1716ef921099a61f7a0da5d19fcee71148984aac41e416c5995b4355078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b473675122e75fe2a29942e6063947822b940d1d9608750e8cbf7da6d666e8d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5d06752902c0dbf29cb4c38b58a0bc2ab69d4c9a32091b29f271cbc1e057fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25cbb1c62d3b349eba467279c6963bd89b7a6ace2b6b0cc0a82d8782b182b8ef"
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
