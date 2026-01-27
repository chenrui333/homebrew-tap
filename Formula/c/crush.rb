class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "1ed72759b8326bc01bcd3ea57f67b7fd7cbfa0b598476f222e3dd5e2187935e8"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5f3990321fba9ccdde3bf05cd093f50c978a4deb9179124b868e82971639cf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e0308bb23e320f30661a372233d1053f6ea149e84310224809b877a41a45297"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09dcfb523ad8f6a835c916a3de9d3093b46cbb98744e047f5a9a6b9f188d3829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "238f7155370d2bba862648ee060be3a4da637ecd8ec20c4ef0e1f4e049e8b8c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfbecb8ab166e0490c08285ab27182a158e9a4151fa6d3e907d6cd38260b2e5c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "No providers configured", output
  end
end
