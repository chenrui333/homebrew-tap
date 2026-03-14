class Gsh < Formula
  desc "Battery-included, POSIX-compatible, generative shell"
  homepage "https://github.com/atinylittleshell/gsh"
  url "https://github.com/atinylittleshell/gsh/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "10a34f5c665b458f4365bf5c082a556dc5cc9dad4b7cd6a1131d40a5d4ff2aca"
  license "GPL-3.0-only"
  head "https://github.com/atinylittleshell/gsh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4191a18826082aac8626c04dd260d00f6e37ec8607779e55b3a2ada42e3a2abe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4191a18826082aac8626c04dd260d00f6e37ec8607779e55b3a2ada42e3a2abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4191a18826082aac8626c04dd260d00f6e37ec8607779e55b3a2ada42e3a2abe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c71fc7307a48e83370bd9079ff60408a8d8ae8f01c8e6aea370317ba01dfdd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee152e2d847647faf0edbeb33e46ddddb3216eb62d3180d4da7c03d48109a2b5"
  end

  depends_on "go" => :build

  def install
    tool_path = buildpath/"build_bin"
    ENV["GOBIN"] = tool_path
    ENV.prepend_path "PATH", tool_path
    system "go", "install", "golang.org/x/tools/cmd/stringer@latest"
    system "go", "generate", "./..."

    ldflags = "-s -w -X main.BUILD_VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gsh"), "./cmd/gsh/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsh --version")
    assert_match "Telemetry:", shell_output("#{bin}/gsh telemetry status")
  end
end
