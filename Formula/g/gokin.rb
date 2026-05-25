class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.85.0.tar.gz"
  sha256 "5a6a23cd21bb6b9fc48746bfd180a5a0cad84a72c7aa25859a5f3a363fdc65b6"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6acc30665aca765022709e2033d5a494b9aa88445c20e2b1640649119e890f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6acc30665aca765022709e2033d5a494b9aa88445c20e2b1640649119e890f74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6acc30665aca765022709e2033d5a494b9aa88445c20e2b1640649119e890f74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7e7ceebc98673c0cc44e9d04e7b733d62238b4d0ee9ce3d2e483a6fbf6a6ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3437efcb2f4e7aa0c238b1057029a77e8e3d33733ab5be6bb7c5437929f099a2"
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
