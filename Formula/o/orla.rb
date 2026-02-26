class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "d8ee2c1e6d32ec2f0a5738d7fd4eeac6c6dd42dc88876f44950cb03330c1d5a4"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c6f32615ffc3768f29c72566b382fe31a74f245d62232d0608d4d54d8a28e51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c6f32615ffc3768f29c72566b382fe31a74f245d62232d0608d4d54d8a28e51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c6f32615ffc3768f29c72566b382fe31a74f245d62232d0608d4d54d8a28e51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42952a9f6a677215274847b4cc4f286d0762fe9d84b22b17398b19661fde9dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f314ceb5ee535cef5b637f9422f7242569c7ac415bef4876b2f62787ec73fd3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/orla"

    generate_completions_from_executable(bin/"orla", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orla --version")
    assert_match "Start orla's agent engine as a service", shell_output("#{bin}/orla serve --help")
  end
end
