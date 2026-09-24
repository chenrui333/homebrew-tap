class Ku < Formula
  desc "Keyboard-driven Kubernetes terminal interface"
  homepage "https://github.com/bjarneo/ku"
  url "https://github.com/bjarneo/ku/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "7423b2511469fd249a06f23e334fc9d85255ef8385f5aa72d619fd912ac2d0f2"
  license "MIT"
  head "https://github.com/bjarneo/ku.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec6e060b135016e2a6a6fada6dedfbf098407d7b89152ba0ac7de9fcf1b55a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cec6e060b135016e2a6a6fada6dedfbf098407d7b89152ba0ac7de9fcf1b55a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99e607431a98032c7c8f4e8a85fa65f89fe202bde4a60c784fb4b7167e6c8505"
    sha256 cellar: :any,                 x86_64_linux:  "6ff826836cd11b086087469bb154c515e3633b2a9037f9ee99b0e106220f5da1"
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
