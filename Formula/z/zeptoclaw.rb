class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "db273080064dc41640fe70213c5cdf931cb58d761c104f66e5fd62b48117d304"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10474e09560d4346f4dfa8827d3e3842e576096e304fde3e6d45ebaf0e99ff10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f325d69814e19717975830404033e69a7f1c058a81010d709259126bd24031f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cd2ded7a4e1819a49eac75b2f3ccada2db1791a32991565df2504c64de03ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2397c708c277f8d51f1c06352b7c71152fc95d9b72601d3cfce977b3087df209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "643472f5aa5d5c935472ef33bfbf70352c97bda7cf06c74337ae0635e0f17b43"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
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
