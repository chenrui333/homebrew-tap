class Discordo < Formula
  desc "Lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  url "https://github.com/ayn2op/discordo/archive/77f21369b4d258eaec590d8f1353b6812683829e.tar.gz"
  version "unstable-2026-04-13"
  sha256 "69751db8d3bec788ad76c8da01675315fad8201d3601fbb39349c1c3b4f266b3"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe7bb010bf96b8bbfd4032671e47e5075e81682222f46bb3536afc9156b22d80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817741731299521939b535d2adab94f31198268737969235d8722393a07fab43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c15baddff3ce0c0fb6769c755b83825975d6255fc460bba8025f65f24d41bfba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1366d5a29699ef1cdc424af268da4b95b0435111064387be2390de128e97a96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f482eea7ac7e5779a502b56e1671525a302b370313647579ff5ed14fa8433565"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # discordo is a TUI app, so just verify the binary runs
    assert_match "config-path", shell_output("#{bin}/discordo --help 2>&1")
  end
end
