class AzTui < Formula
  desc "TUI for Azure resources"
  homepage "https://github.com/IAL32/az-tui"
  url "https://github.com/IAL32/az-tui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "da6015c53c265fd618cf461a9c84b53ec3f7c5e5db38df15df5191888483e681"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fe948c67797bb8cb34d9ce4d16f1e3093c15ba942e8702c5843746e2f8728c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fe948c67797bb8cb34d9ce4d16f1e3093c15ba942e8702c5843746e2f8728c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fe948c67797bb8cb34d9ce4d16f1e3093c15ba942e8702c5843746e2f8728c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f03659219929606f0c039b70e43a9d52a9f930552817c6dc77dacbb45c742a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7036aa10e63dadb6c41a90b85d2ef51bf799c639d300ddc0828935704bc6a546"
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
