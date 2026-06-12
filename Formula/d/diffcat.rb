class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "5433b01bacf2345fa059803dc8c06d1afbbfbf05514a92a4c15dccc5076f4a7a"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.ldflagsVersion=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffcat --version")
    assert_match "diffcat", shell_output("#{bin}/diffcat --help")
  end
end
