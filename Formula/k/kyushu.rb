class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.3.0.tar.gz"
  sha256 "6ddc3492bb9fc5c34b2f6a6de11b16d187e5a82efa45d4df22443583d7aa06e4"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1dc3cd2b9a52481302426002d3e596b086fa682ea8c150b5112116449fde07c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a18df19208c17817a5ff6854c9b32ab04973c8d8d17ee6e137f5aaf371dfcc2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10da21ffaca5ac756979ed9596536ebf4ae4c4c924d2caae3b9d9f13ab6cf0fb"
    sha256 cellar: :any,                 arm64_linux:   "67d206672b8ac0485a0f3ae35fd34d68e80a5e2c333fe5b872f3db41b3da55bd"
    sha256 cellar: :any,                 x86_64_linux:  "8fc1f282d44a482468f44108c52bb7f6b93b37ece7cb1e4cb107c5fe58f6ae99"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    output = shell_output("#{bin}/kyu --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
