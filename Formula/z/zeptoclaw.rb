class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "db273080064dc41640fe70213c5cdf931cb58d761c104f66e5fd62b48117d304"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ad8726a171036d69f2d26806804ff9c88731c2c297966c886034a8acf887468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "165927e6b7e0bafa164d1cf2ed780657d4ab9bfdabd46018817bfccb7b7644c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9359ccf5ddc91f47be3d975492998a6ff1e932fc5e18277850e73a9b13f5627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "821406867d70f13720770a94f3efccf7d0f467a450229c56c8a2a411049d91a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0493ccd7f44b33e3a7965d9bfad1d2602466724270b6ee5b229b8b8ceb6e11"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
