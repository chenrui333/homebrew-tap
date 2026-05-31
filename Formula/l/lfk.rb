class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "3d42dea4bd03958dd9b5be59a8557819ada6c5f6fa0027fce8216924c10b913f"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "644254c62ca5beed1543da80bdbeac1fb831b4a31ede3a6387c61f3558151ee5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "644254c62ca5beed1543da80bdbeac1fb831b4a31ede3a6387c61f3558151ee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "644254c62ca5beed1543da80bdbeac1fb831b4a31ede3a6387c61f3558151ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48274e0074dbdb653ac386e6f4c860c04d76d55a18e3e741e5fed121d6232b99"
    sha256 cellar: :any,                 x86_64_linux:  "a52b1915bdd82aeeae2c1bcee3a78d863214c8fe22ca352d0b0c36725671f2a7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
