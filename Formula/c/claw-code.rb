class ClawCode < Formula
  desc "Claude-compatible coding agent built from the Claw Rust workspace"
  homepage "https://github.com/ultraworkers/claw-code"
  url "https://github.com/ultraworkers/claw-code/archive/f4fff38de1d47a6aeafe5b6b279d3f15d7cdc712.tar.gz"
  version "0.1.9-20261028"
  sha256 "4150a201e2be0cb96abf51d0ea6850c85c8853ffcb4fd634cd618057695f9218"
  license "MIT"
  head "https://github.com/ultraworkers/claw-code.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec46b10a37a77ad42c4a8cf3f6a68be513eecd630f1aa09b13195e0df445ffea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77339251a46d3412999d7a7fd133a8e4c48df49d67a12f0031d040da3b857c18"
    sha256 cellar: :any,                 arm64_linux:   "c5d86a5232bc435006fe4a794ef71e2b4a30cb77a1ad0023db16ca28f49b9157"
    sha256 cellar: :any,                 x86_64_linux:  "2a9266c43c5d6a7af239232b7654097eab42cbb78e85ea57cd3b4dcc8c46f4c4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    cd "rust" do
      system "cargo", "install", *std_cargo_args(path: "crates/rusty-claude-cli")
    end
  end

  test do
    # The immutable snapshot reports its Cargo workspace version, not the snapshot date.
    assert_match "0.1.9", shell_output("#{bin}/claw --version")
    (testpath/"project").mkpath
    cd "project" do
      Pathname("session.jsonl").write <<~JSONL
        {"type":"session_meta","version":1,"session_id":"homebrew-session","created_at_ms":1775230717464,"updated_at_ms":1775230717464}
        {"type":"message","message":{"role":"user","blocks":[{"type":"text","text":"homebrew-offline-session-fixture"}]}}
      JSONL
      system bin/"claw", "--resume", "session.jsonl", "/export", "transcript.txt"
      assert_match "homebrew-offline-session-fixture", Pathname("transcript.txt").read
    end
  end
end
