class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "23e71af3635815860228ef8b2e65f9088578fff360e22ef8f1afd50a19443e0e"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "312b637a53d8ee99755437cb15c04ae6c398b395d10bfa84f30d1f5105c1cbb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057945fb53d48133dabfebd53fedb38c141ca1df1878ead9b7b6a2ee9d3e85e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72e14a72d00180b4f2e94ccc9224e0300fc7a5b29a16b0a1fdb7233b25ede8c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a71bf49df6a3a9389c1d062f4be42f2d4725aeb334eadee9fb03102916878ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d33a386d74e49a436a29e957c4d816177272783a58ed112b3bb55434090df41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
