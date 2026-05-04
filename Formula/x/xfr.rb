class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "9cf401397975a883f5e1c1c4e48bd7704acaafe099907f3c6ffbb1f25f2ee09a"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfd6aec3fe26177a600472cb31a2728db6ffd48d8b681a9bd5584bb276478d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c4e95ac736a289962d532f1e1ce45f8eee02a07e93bdf774d7887124f705711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "465e2938a6a8f836bc19db47bc457e2fa032541ab4e114dd04c58a21913999c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4712c0ad8ef1345def085d03d9998e0cbface2e54349421df2e67c79a2152a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c0f2ecb9938285bb44b86f70fc4ef63fe3844e7cbf3fbb18081e9fc568d8675"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")
  end
end
