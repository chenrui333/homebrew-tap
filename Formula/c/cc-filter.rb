class CcFilter < Formula
  desc "Claude Code Sensitive Information Filter"
  homepage "https://github.com/wissem/cc-filter"
  url "https://github.com/wissem/cc-filter/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "7b8a196dd7ba360fa5c1bebb45e7145ee26f6f3993caaa015a68ac739fe3039a"
  license "MIT"
  head "https://github.com/wissem/cc-filter.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-filter --version")

    output = pipe_output("#{bin}/cc-filter", "API_KEY=secret123", 0)
    assert_match "API_KEY=secret123", output
    assert_path_exists testpath/".cc-filter/filter.log"
  end
end
