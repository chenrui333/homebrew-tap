class Moribito < Formula
  desc "TUI for LDAP Viewing/Queries"
  homepage "https://ericschmar.github.io/moribito/"
  url "https://github.com/ericschmar/moribito/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "7b07448c6f8f16121232c73f45d8c8c7b59e066f20a00850dde093e724cd98db"
  license "MIT"
  head "https://github.com/ericschmar/moribito.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92672e7f64942159f2e4b2ea806797206521f41b0280d312c1c8f8d1a13427cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e97823c0b1831dc0e27f0f2a8ae90cdab975b989fb7318de69427a550a3268d"
    sha256 cellar: :any_skip_relocation, ventura:       "1c8916d05c07c97436d1c7e15a045fefe1c436e2fb1dcf6a619550df2f40c87e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2469a90e6d3090b0dd805166e2b5c8fdd9c4a63966531a7485346c2b993c5f0c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ericschmar/moribito/internal/version.Version=#{version}
      -X github.com/ericschmar/moribito/internal/version.Commit=#{tap.user}
      -X github.com/ericschmar/moribito/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/moribito"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moribito --version")

    assert_match "Configuration file created", shell_output("#{bin}/moribito --create-config")
  end
end
