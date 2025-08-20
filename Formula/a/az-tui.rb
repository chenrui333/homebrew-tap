class AzTui < Formula
  desc "TUI for Azure resources"
  homepage "https://github.com/IAL32/az-tui"
  url "https://github.com/IAL32/az-tui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "da6015c53c265fd618cf461a9c84b53ec3f7c5e5db38df15df5191888483e681"
  license "MIT"

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
