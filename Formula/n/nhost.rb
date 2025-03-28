class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.29.5.tar.gz"
  sha256 "e2d36f7663dcaa6f3e2ed7d26106b582238d53fc52ac950a7d4d63fcdccaf4c5"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66fa1c76dbb7a9cdd1bb297e2dbb873346038f5b2731031ee0f98d4f379d964a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df681a62cfdba868c9668674d4398b493d7b232d18f6df8b70e8430d953c3151"
    sha256 cellar: :any_skip_relocation, ventura:       "6bfa55fc6c418692566b083ea604ada31db1222f1e08578c13bcb6e2ad0ce1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d3f83092944d3f6eb1428600a63816c63f138ad691c54724d3ec64f527ba6d0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
