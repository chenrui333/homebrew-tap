class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.14.tar.gz"
  sha256 "6da8cc1dbd6fb43877c159506fd2c8db7bb5277ec9ab0bfcc99ef29a6c3bb815"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d978a1d52a86994c15173d5e1602320823e2e5b1b7d772d83f3d1153ed7f6e3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ae5edf4f65481ec912e7645524472e9cb22f0f5f5589308d81254c1aa90beb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75e0811aee2e6b5a5b010db80b9dc0088d2b1c6d57e3b639e7fb0bc9c8f6af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1bce0d4587a7b2e35ad94f1fbf758029a11235639bbbcc9473c61968a8623f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6cea8f23f6ff6211f7fb2c3ab45b89e17345594d493a552e2a4f634ae99285"
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
