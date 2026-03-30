class Amux < Formula
  desc "TUI for easily running parallel coding agents"
  homepage "https://github.com/andyrewlee/amux"
  url "https://github.com/andyrewlee/amux/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "5c45784694c849dbdd1bbb47c403c8df89eb9a53ac3a0122ffb6e14560568522"
  license "MIT"

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=Homebrew
      -X main.date=unknown
      -X github.com/andyrewlee/amux/internal/update.homebrewBuild=true
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"amux"), "./cmd/amux"
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"amux"} --version")

    output = shell_output("#{bin/"amux"} status")
    assert_match "tmux:", output
    assert_match "workspaces:", output
  end
end
