class CcFilter < Formula
  desc "Claude Code Sensitive Information Filter"
  homepage "https://github.com/wissem/cc-filter"
  url "https://github.com/wissem/cc-filter/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "ac3844606726dac61c083799b8579b3b97b52059822fe7913401ac08f7db1b4d"
  license "MIT"
  head "https://github.com/wissem/cc-filter.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9411141673b6e6b4d313f9e9ce8d8113a676b6784179cac342d91313c358df20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9411141673b6e6b4d313f9e9ce8d8113a676b6784179cac342d91313c358df20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9411141673b6e6b4d313f9e9ce8d8113a676b6784179cac342d91313c358df20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b4cf307f470e8496acd36499d4118031be62b6152f9360eafb4f6e1152ee36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a5907ca52ef932837ba8f65971343fa6d1f83a50361678a37cc40ab111b344"
  end

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
