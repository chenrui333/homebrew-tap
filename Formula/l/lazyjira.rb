class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "afef1d999b21008366d0ac2618ae6c4f73f1bc111737cb9e74d649805ed575b3"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "904a2a729881274cb9d22b5f65390abeac9dab11883dde29deb27c85d28174d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904a2a729881274cb9d22b5f65390abeac9dab11883dde29deb27c85d28174d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "904a2a729881274cb9d22b5f65390abeac9dab11883dde29deb27c85d28174d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e40aa202bf21ea64aa5054171d3d89ae682a45d9a0019ecbd4760c144c838c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b34c34c9557d5625790006932ef9f5c341346d9b5f0661559d7e04132cb29ed"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end
