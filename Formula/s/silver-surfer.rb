class SilverSurfer < Formula
  desc "Kubernetes objects api-version compatibility checker"
  homepage "https://devtron.ai/"
  url "https://github.com/devtron-labs/silver-surfer/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "3ce8a7fe5754078a9d34f7018a0f99cccca37f423a0b9719d3f33570e58130b7"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "824f9641d763487393d27de9ee7ba457bd96a8ad1fbff87aeb3644e24763baad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824f9641d763487393d27de9ee7ba457bd96a8ad1fbff87aeb3644e24763baad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824f9641d763487393d27de9ee7ba457bd96a8ad1fbff87aeb3644e24763baad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7680840f933a78d9c4b62edbec0ad92c72eabe31332cd69835bd7be89132cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ff73b7e663fefefff804fb015637db0a2499547677f1d3c796922e2ed717550"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/silver-surfer --version")
  end
end
