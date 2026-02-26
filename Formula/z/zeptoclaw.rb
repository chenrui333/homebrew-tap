class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d88a4e289904463ff087d322b549343773098354b80faf71445a329dc5c0c2e6"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0f130c3ddca45949ab0defbbd17f7473b62ce6745a66a8663dcfa6f74dd1732"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0848daa2af23a7e26f7daebadba14628261616c485805354ea55201d30322056"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44c707bd0d7afddafe405143506a6a62414d14b42bdde647f7623535617c758c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a650533a2b894e8ad3a820387115832c905ceaa46e31cb49300ec177a00f3db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b72ccff9469acf1e0515512edc2f974bdc1295b3bb37f04528c85cdcc6e8ca"
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
