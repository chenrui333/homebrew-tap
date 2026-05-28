class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "f6279c1121830ae7c22c2b134e632b0edd53ab3c70c205a9614d810a410f9ed6"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bb66f85e51dcfda142ad96fb61ca8595096ad0077e457a624bc84893fdd485c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c17d8b8ea6862416fb518d79ddffcfb765e96accda071ff8a06fcf28cdd66cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4389c3e3c4ce8726d6da0a3cbb5999dc04cd17709f7a799cb88b6c6aaadd53f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5444960ad38dd734fead306f903bc1bc920ab3aa98a90ab3c6d3f915addea871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ebec29bed456732b403a587b2e9734094fd780cdb3e31edc933dba085fc9e4f"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
