class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "b9ac29f1a2947bdd525c45bb4331a6637de35b9c3ad3007b1176ce8257768ee4"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b1998f8c1ee66c340d68d0f2cbc53e5332d722fc5b79209aa1d1e651038c019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10f0ca8bae262eced1e0c2fc70f77bf0208550b437efe2c84fe8f2bbbede2854"
    sha256 cellar: :any_skip_relocation, ventura:       "a8c6ee0a5e951e397201b728041b8b262f5356d93008b0d6516a177802193165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e2929bc5f9a4e5f8489ad929c9f7b3a064107e14b544735ab8a71ed2cf1d8e2"
  end

  depends_on "go" => :build

  def install
    # Prevent init() from overwriting ldflags version
    inreplace "pkg/version/version.go",
              "if len(bi.Main.Version) > 0",
              "if len(bi.Main.Version) > 0 && Version == \"(dev)\""

    ldflags = "-s -w -X github.com/sjzar/chatlog/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chatlog version")
    assert_match "failed to get key", shell_output("#{bin}/chatlog key 2>&1")
  end
end
