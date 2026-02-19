class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "2ad0028eb7afef751e3a8c2eb8eee3a6be38bda3ff88029140ff4d740452592c"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9177865c264f6b57a323248d3fc95ce1af5a591ce116b18a5b6affba9c971687"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49eb5a754ebffda225bdd9d317a1171c043d5a7bbe913a391e5e511fbd7b323f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "151c3dd5cdb554d73895f1be6d9635b5b4ac105b32f1e1809b4738e41d36fde3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc5f786d63a11828865bcdf010b34adfe23083f156a93e225948bbb60f51629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b621641d9705a1582dc13d48db64b903a593289883dd2d272f3aa2289ae0501b"
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
    ENV["HOME"] = testpath

    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
