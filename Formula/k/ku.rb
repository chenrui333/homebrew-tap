class Ku < Formula
  desc "Keyboard-driven Kubernetes terminal interface"
  homepage "https://github.com/bjarneo/ku"
  url "https://github.com/bjarneo/ku/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8ee6560203f5a2aebea6cd22b1349ac22745899cd37dbe76ddc611c4ecb1c075"
  license "MIT"
  head "https://github.com/bjarneo/ku.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e042dcacc15df988ad48ccff378ee2ca2453a17ee879c509c2c7bdf2a6f05649"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ac7aeb8056ce588a62f4deabc9cc996a3bf9330bbf3edf5796ec590cffb3163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac7aeb8056ce588a62f4deabc9cc996a3bf9330bbf3edf5796ec590cffb3163"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f476dddf839e20141ca950b36e4c08609921dffcd1e66efd104eecdf1c74914e"
    sha256 cellar: :any,                 x86_64_linux:  "7a469d89a2c277b9bacc28ba25192e6879f076d20f2383a4595d993f6a566481"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ku --version")
    (testpath/"kubeconfig").write("")
    output = shell_output("#{bin}/ku --check --kubeconfig #{testpath}/kubeconfig 2>&1", 1)
    assert_match "kubeconfig is empty or missing", output
  end
end
