class Ku < Formula
  desc "Keyboard-driven Kubernetes terminal interface"
  homepage "https://github.com/bjarneo/ku"
  url "https://github.com/bjarneo/ku/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "7423b2511469fd249a06f23e334fc9d85255ef8385f5aa72d619fd912ac2d0f2"
  license "MIT"
  head "https://github.com/bjarneo/ku.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84eb00b586ff85595ac7736e9b37a6acd3ae5c00533833985cf24fa4d477e69b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84eb00b586ff85595ac7736e9b37a6acd3ae5c00533833985cf24fa4d477e69b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "026181dd9a9dc76b6b298ff5d03c3e1b52b4a9ccbe7297d3d1e188e57cd7f3f6"
    sha256 cellar: :any,                 x86_64_linux:  "b6de511e9ce32bf22d99de40bf8221a91a81d7000ea0872c3353d6b30f445021"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
