class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.30.tar.gz"
  sha256 "641dccd58b7851ae0a903cc16f3557ff55f03f35716dd6078d0895d9ad145834"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44e6d9794734339f0f642f82b0a2d0e880f5193d7869831f3bf48af6a270b417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85a6079a7aa6444c9c6da440474ebea0ba891c53234341580516d27bb76e5eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a425ef1d21cb8a911bdf2846cf2e99666567392ccf829d2ff29f3e7c7d6adf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ad819aabfa591faf74404985a060065e1c2b77c6f9102301e13f07f37e0bbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114d2051bf1f5461e2a0954f45f322f632262003f42d2dba10d5fbaf081a3afe"
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
