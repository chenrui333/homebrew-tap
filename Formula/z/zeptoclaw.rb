class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "2ad0028eb7afef751e3a8c2eb8eee3a6be38bda3ff88029140ff4d740452592c"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ec1e99cc7cdaf0d6e589834c2a73940c151a584783d4e358cf40e78285fae2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdbb6a505a6cfdfb105a0607116ca4ffbdd9459855cfbde297e7b2f3aece0f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b5a91acbd195efd152f2d8f0adf403ddc70fc231b70af1fa803a7343c79fb67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd76f7d0b3d5c36d2dd41ca21b08a12e8470b12c247b582eb2f5e0a52eb587e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a43bd0f101626131338518cecc65a8e4021924dabdd2fe1430dce4f307792f"
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
