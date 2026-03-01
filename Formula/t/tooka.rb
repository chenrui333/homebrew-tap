class Tooka < Formula
  desc "CLI for the Tooka engine"
  homepage "https://github.com/tooka-org/tooka"
  url "https://github.com/tooka-org/tooka/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "9f532b64d7cd6bb23a53fab0221540e5df3b39770c1a081cf3a953eead7f3614"
  license "GPL-3.0-only"
  head "https://github.com/tooka-org/tooka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a696e4f71aaa89bb989039e50775d62307346039c12dad13b6c0deb89d3e970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fdd181b0a8b479f899ef53bb728a5173abeee6ac5ab607241b1bc69fec46c6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc4a9612fa8fd048fd382ea938188cc1876041a32024b144545b3ed4dbe88fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4d5589454b28fd95dd4d500b6c7b551d4b4e3323ddc1b9cf1f02528680e5ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bda1060c566378101e3720906c6367a46e766777114ff07c3fc25e7cd85c4bb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"tooka", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tooka --version")
    assert_match "No rules found", shell_output("#{bin}/tooka list")
  end
end
