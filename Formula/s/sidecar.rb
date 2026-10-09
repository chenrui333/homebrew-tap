class Sidecar < Formula
  desc "Terminal UI for diffs, file trees, conversation history, and tasks"
  homepage "https://github.com/marcus/sidecar"
  url "https://github.com/marcus/sidecar/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "fc121253ce61699138a0b3d1654fa07884a9999ae1d2a4a6876d9b1cb037bdd3"
  license "MIT"
  head "https://github.com/marcus/sidecar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5268366b67de80b2b70c6b216ebcdbfea6f82a8b144889f026c661488d7a9245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a7fa700912ef1ef5ed9db32884fdbeff8ec5c3a1fe5b82eda7e8121be9ac29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad2ec00dc676edca922b43123c5e08cc6d75b7fdc27ddf92f727a6b1dc809066"
    sha256 cellar: :any,                 x86_64_linux:  "e58c5665a9674ff0b30e0cf4cde4ebe2da4674691c7f6ba6b9555526c48e2fd1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"sidecar"), "./cmd/sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sidecar --version")
    assert_match "Sidecar requires an interactive terminal",
                 shell_output("#{bin}/sidecar --project #{testpath} 2>&1", 1)
  end
end
