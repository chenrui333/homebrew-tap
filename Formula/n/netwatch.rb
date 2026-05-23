class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ea484803b68563fc0236e95ade1bd4e2adc07d75fe9eeda0dd172d4fbb577358"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52417fa548508c7fe1507441ec6b274170bfc6d3c88137c3911b758f7dba4086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "258043c42a249573ee83a263b44a7a79f20a5e802afd7fb76f260b72ab9669f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c8ad1d9ed74ef132341a813bef5758b2fe798f539deecb6537ac3aa33af0196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c5fa6d3c08458951e9c3efe9ada1923201feedd536cc4423cd4efeef89f0593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f425a53ab69c42638fe3258c78d9d3bb93c4ab8b7ae6ed8b3b94a7eebabf43a"
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
