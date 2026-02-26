class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "eac146b1b18e539fdbfada5a40a0210cc9ce22b6c5a15ce09e427e81c0050077"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7f194cb2363c59284a5ec34f1046c5ee31d50c8c51186e8e4d10bfcb5ce5273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7f194cb2363c59284a5ec34f1046c5ee31d50c8c51186e8e4d10bfcb5ce5273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f194cb2363c59284a5ec34f1046c5ee31d50c8c51186e8e4d10bfcb5ce5273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "447841c2dbe9079c87fdad24d381cb7cd69c2d99326627171ce371bbe41dc41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "783f076e916921ba5e3d2310b19059f0374f3516965c6e101bc4e2fb07304a13"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
