class Kat < Formula
  desc "TUI and rule-based rendering engine for Kubernetes manifests"
  homepage "https://github.com/MacroPower/kat"
  url "https://github.com/MacroPower/kat/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "e6d10e721378c4df1b578daa76f8da137d2b65d41f7d3a0254eecc26c77ccd70"
  license "Apache-2.0"
  head "https://github.com/MacroPower/kat.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/macropower/kat/pkg/version.Version=#{version}
      -X github.com/macropower/kat/pkg/version.Branch=main
      -X github.com/macropower/kat/pkg/version.BuildUser=#{tap.user}
      -X github.com/macropower/kat/pkg/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kat"

    generate_completions_from_executable(bin/"kat", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kat --version")
    assert_match "profiles", shell_output("#{bin}/kat --show-config")
  end
end
