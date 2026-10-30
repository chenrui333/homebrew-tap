class MardiGras < Formula
  desc "Terminal UI for Beads issue tracking"
  homepage "https://github.com/quietpublish/mardi-gras"
  url "https://github.com/quietpublish/mardi-gras/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "59fa41cff3749a759f4931baf59d15de4286f7a5d718dd5fa8265d879356b89d"
  license "MIT"
  head "https://github.com/quietpublish/mardi-gras.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78b2e3bf2f9537a897a73aebfb77b132b58b8561d8606a256e56da62424f2d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78b2e3bf2f9537a897a73aebfb77b132b58b8561d8606a256e56da62424f2d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8430fc213b2a27acab2470a4f0b06f5524d0b148c562a5b913d1f56dac050ddc"
    sha256 cellar: :any,                 x86_64_linux:  "c51d5c3e206fca80afceadca9412b5f3c8a00958b9092caf55e1dd1bce929a79"
  end

  depends_on "go" => :build

  conflicts_with "mg", because: "both install `mg` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}", output: bin/"mg"), "./cmd/mg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mg --version")

    (testpath/"issues.jsonl").write <<~JSON
      {"id":"brew-1","title":"Build from source","status":"in_progress","issue_type":"task","priority":2}
      {"id":"brew-2","title":"Verify package","status":"open","issue_type":"task","priority":2}
    JSON
    output = shell_output("#{bin}/mg --path #{testpath}/issues.jsonl --status")
    assert_match "1●", output
    assert_match "1♪", output
  end
end
