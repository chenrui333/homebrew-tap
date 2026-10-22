class Ku < Formula
  desc "Keyboard-driven Kubernetes terminal interface"
  homepage "https://github.com/bjarneo/ku"
  url "https://github.com/bjarneo/ku/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "7d9a11025860a0d1a5dba60121378736baddba1952ab554f3adc5d3264647863"
  license "MIT"
  head "https://github.com/bjarneo/ku.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d5829bef093ed11d5e1750dfe201d3b9edd1b7ed30f64ee92175eb6bdda42f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d5829bef093ed11d5e1750dfe201d3b9edd1b7ed30f64ee92175eb6bdda42f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d717cdc39c5bed6678dc8a05d671f71ae3c50d766ff09512da3a4426c10a4a65"
    sha256 cellar: :any,                 x86_64_linux:  "8c274d3e057d2ee01231c41002a771b26e5588e48c5dbeb200c41a082cbfe0d5"
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
