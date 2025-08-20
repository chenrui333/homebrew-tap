class AzTui < Formula
  desc "TUI for Azure resources"
  homepage "https://github.com/IAL32/az-tui"
  url "https://github.com/IAL32/az-tui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "da6015c53c265fd618cf461a9c84b53ec3f7c5e5db38df15df5191888483e681"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f923583575367d4045a13c4528cf0eda607dfeff7f7c744c1c83cb4fab587e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8994e22003c8290851ea4a847f611bc19b6b5d7a9bc8c5fa820d3f477cb220c"
    sha256 cellar: :any_skip_relocation, ventura:       "a40a7f493abfe5244ee9c899624ba224c3f32857652542922b9e6751a24ba170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2be66e942abf2f6ee82cddf0e81c8bf6d243825c2f78aaee1c885e4c6562d4b8"
  end

  depends_on "go" => :build
  depends_on "azure-cli"

  def install
    ldflags = %W[
      -s -w
      -X github.com/IAL32/az-tui/internal/build.Version=#{version}
      -X github.com/IAL32/az-tui/internal/build.Commit=#{tap.user}
      -X github.com/IAL32/az-tui/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/az-tui"
  end

  test do
    # az-tui is a TUI application
    assert_match version.to_s, shell_output("#{bin}/az-tui -version")
  end
end
