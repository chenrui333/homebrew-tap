class AzTui < Formula
  desc "TUI for Azure resources"
  homepage "https://github.com/IAL32/az-tui"
  url "https://github.com/IAL32/az-tui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "da6015c53c265fd618cf461a9c84b53ec3f7c5e5db38df15df5191888483e681"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64ceb78a2e465dbdb6f5d6f4baf4f89f23cf1ed86c0917dd8999ab79afe8c42d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64ceb78a2e465dbdb6f5d6f4baf4f89f23cf1ed86c0917dd8999ab79afe8c42d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64ceb78a2e465dbdb6f5d6f4baf4f89f23cf1ed86c0917dd8999ab79afe8c42d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57cdf0b5b7d14dfddf32990275816d805a3b258fd30794708e4ad0f9871b6aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdfe01944c55b4eea0ef53d13addc3564f099688888628eacee2048c94f40e46"
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
