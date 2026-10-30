class MardiGras < Formula
  desc "Terminal UI for Beads issue tracking"
  homepage "https://github.com/quietpublish/mardi-gras"
  url "https://github.com/quietpublish/mardi-gras/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "59fa41cff3749a759f4931baf59d15de4286f7a5d718dd5fa8265d879356b89d"
  license "MIT"
  head "https://github.com/quietpublish/mardi-gras.git", branch: "main"

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
