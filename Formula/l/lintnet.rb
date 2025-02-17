# framework: urfave/cli
class Lintnet < Formula
  desc "General purpose linter for structured configuration data powered by Jsonnet"
  homepage "https://lintnet.github.io/"
  url "https://github.com/lintnet/lintnet/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "c0022f31f7c789e2a7fe07a0ea174669bce2b87d6bd398d5448e00b8d15699a9"
  license "MIT"
  head "https://github.com/lintnet/lintnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c724aa9197106b0d3d9ffb875da2741471c197986741d4e6a5e1c641ab2a87a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc648a3c1e6577c41dd19f42ff18aba6b05ce5ec9ba29083552b10fc77856f2"
    sha256 cellar: :any_skip_relocation, ventura:       "96692e4d4e7da60d63a1f7fec39965d18556c9e3d82e8f6c8720cb0bbdb2603f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6a77d7270dab7a91bec84322574d54246060db4fce61ce8316cd8fba679f55a"
  end

  depends_on "go" => :build

  # fix version typo
  patch do
    url "https://github.com/lintnet/lintnet/commit/ed1fea6ae5ed0e2a92d4ab085772cd9a667359b5.patch?full_index=1"
    sha256 "234457c4b374471221c75270a32cdcea892d0ea11f7247aadc81102ed5dc4e8f"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lintnet"

    generate_completions_from_executable(bin/"lintnet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lintnet version")
    assert_match version.to_s, JSON.parse(shell_output("#{bin}/lintnet info"))["version"]

    system bin/"lintnet", "init"
    assert_match "A configuration file of lintnet", (testpath/"lintnet.jsonnet").read
  end
end
