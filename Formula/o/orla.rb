class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.14.tar.gz"
  sha256 "6da8cc1dbd6fb43877c159506fd2c8db7bb5277ec9ab0bfcc99ef29a6c3bb815"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd0f659dc2c3e1dcb2ac007ffbc59e3c4033714ef69dc51a4a6eddba0e080ff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b69cd02e1b5596d506c3080bc56f2251e043799261a9b74bdd7ff69c9cf22a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fb0d1a013cb09d30ddb72c6f0bc29b67f0772f50d0e70efc81c7e202faeb367"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06b337173f766b19386b18dc3e63188e38454c8831bd867b795b75beb0e00463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9eea94cb7153caab76e02f47b8994a51fe5dbbe42505c309255d407216195fd"
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
