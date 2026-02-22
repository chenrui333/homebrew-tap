class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c893ff1811e4bf25d48644586170e96311862d440d4676a255239cdb61392a30"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c12c1e93d9ec79a6b2a493b78a28a2cae0e8586f5bedbab94fa67c3e8d72c515"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b08ad8e6691d0b8f42a9cd951d864f3ea9ad399393a285f32a75b8b77640f3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67fe8859fd44dd59bf92845697762f19702ffaebb601be5da66c56e2d58be34d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e6f222006747e31ecd2e4aaccd75aad82d30951bf4445a12c3fd814aa4e7469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b24b76039aad5dd4fe547d24177ac5c9bee930a3db66575aef0f83945a14a67"
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
