class Moribito < Formula
  desc "TUI for LDAP Viewing/Queries"
  homepage "https://ericschmar.github.io/moribito/"
  url "https://github.com/ericschmar/moribito/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "7b07448c6f8f16121232c73f45d8c8c7b59e066f20a00850dde093e724cd98db"
  license "MIT"
  head "https://github.com/ericschmar/moribito.git", branch: "main"

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
