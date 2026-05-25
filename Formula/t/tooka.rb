class Tooka < Formula
  desc "CLI for the Tooka engine"
  homepage "https://github.com/tooka-org/tooka"
  url "https://github.com/tooka-org/tooka/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9692aba73a8ab768a4c4755a68cc371056f4ede1d893b93b03ab3c58b0e3a801"
  license "GPL-3.0-only"
  head "https://github.com/tooka-org/tooka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c25ac3aa29d18a5792ec4a6092428e97c21ac257e8deea8f8e94b98d7a76136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da3025c26aeda815c231bb7fca53a93dd7aabea878d24d34e44d4cb059696e9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b3549685081b36850406b5bb51c5a18194d005259c701898be88cff68c1bb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65b90445c5fe0b2d51c007aa6bb4698dc14928e1f84eda5dbb688c705357c5cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49fb03d95c21e78a34d7b8fe5456734c445f4d98ccc5806271e2b4919c4f6ff2"
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
