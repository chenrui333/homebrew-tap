class Tfui < Formula
  desc "Interactive TUI for Terraform plan and apply workflows"
  homepage "https://github.com/SayYoungMan/tfui"
  url "https://github.com/SayYoungMan/tfui/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "a22df58883a0b6d3f80835acf4469f46bee86d2d8cacf66e2efef1f2d2109987"
  license "MIT"
  head "https://github.com/SayYoungMan/tfui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcff87c15601e72fe6ff43ce24877bef411da37ac618d21a144012f04befb3dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcff87c15601e72fe6ff43ce24877bef411da37ac618d21a144012f04befb3dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57b1e950b888c3ee08f478ced029c028ad50f6c032df300559fba02fc99d8609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78151a4213ebb8ea92787f4d8cbbf01d0c737533595a419f90e92528b6d9085c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(output: bin/"tfui"), "./cmd/tfui"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_path_exists bin/"tfui"
    output = shell_output("#{bin}/tfui --binary definitely-not-a-real-terraform-binary 2>&1", 1)
    assert_match '"definitely-not-a-real-terraform-binary" not found in PATH', output
  end
end
