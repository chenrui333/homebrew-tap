class Kat < Formula
  desc "TUI and rule-based rendering engine for Kubernetes manifests"
  homepage "https://github.com/MacroPower/kat"
  url "https://github.com/MacroPower/kat/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "770b6849498ae0d174bf01226a745e84ecb62291be2cb79642b512e97b9c271e"
  license "Apache-2.0"
  head "https://github.com/MacroPower/kat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebcbf679d9e1c4b858d36c1db6580fdd645968e8e50d11babc94a8af60c4518e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcbf679d9e1c4b858d36c1db6580fdd645968e8e50d11babc94a8af60c4518e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebcbf679d9e1c4b858d36c1db6580fdd645968e8e50d11babc94a8af60c4518e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "527b050cab0ea0cfb53b51ca988433f8a4fc11b78eccd55fa53f30a1a4b4dca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2afe2f5ea51b129311f117c96146130a59274ac35a1dd356750ab22df2205838"
  end

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
