class Ku < Formula
  desc "Keyboard-driven Kubernetes terminal interface"
  homepage "https://github.com/bjarneo/ku"
  url "https://github.com/bjarneo/ku/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "7423b2511469fd249a06f23e334fc9d85255ef8385f5aa72d619fd912ac2d0f2"
  license "MIT"
  head "https://github.com/bjarneo/ku.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ba4a671da648e49bf6c9ab58bbdc262b12d93d2d4b455fb3c5efd21c3cb0635"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba4a671da648e49bf6c9ab58bbdc262b12d93d2d4b455fb3c5efd21c3cb0635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ba4a671da648e49bf6c9ab58bbdc262b12d93d2d4b455fb3c5efd21c3cb0635"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc96e6c5edf365c9df9e89cdc1a180cb598ccbdc28d3a8a60f9daa54f7d155a7"
    sha256 cellar: :any,                 x86_64_linux:  "e5e7e0e1434bb0b0a32888849684ff040587ce308f2cbe82c7f04cc1527bb1b7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ku --version")
    (testpath/"kubeconfig").write("")
    output = shell_output("#{bin}/ku --check --kubeconfig #{testpath}/kubeconfig 2>&1", 1)
    assert_match "kubeconfig is empty or missing", output
  end
end
