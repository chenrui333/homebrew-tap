class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v0.89.0.tar.gz"
  sha256 "0163a47535de22f0a8060eb6febec03dfaa7bc759a15363dd3e30a0b3ea9982d"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa343d6b2a1d371bf9cce5f56d123d391fd2063d6b4b7d37b1fe74796795b97c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf8643bb8c30d565305d41cf372742774f3b81646d2aab2efd1b99420c2a6379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf0ca8ee4428690235cd86b6b239276bb4eb227c721f0b4e90ed309d9318d7ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c983cc44c01a96c3cc356f8e7651d493949a251fa58caca6e2ad54216ee2a524"
    sha256 cellar: :any,                 x86_64_linux:  "d294edfd8b71f3768de9cbe2363db5fc733ad72845cb8f428b5421785e71dc6a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
