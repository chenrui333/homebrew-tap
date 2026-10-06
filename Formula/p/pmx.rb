class Pmx < Formula
  desc "Manage and switch between AI agent profiles across different platforms"
  homepage "https://github.com/NishantJoshi00/pmx"
  url "https://github.com/NishantJoshi00/pmx/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "14bc6207dc78cf96831feee9ee3ddc712084c92350213500c4320383544a5286"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7053e0c7b797a94204106c30e52eb5bfc207993b08819ab3b54ec7c902b3ebeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e619c1625b759132e4aeab5d01e9686cab18ce3b8df282ee9021589f82f4f26e"
    sha256 cellar: :any,                 arm64_linux:   "c6329d7d8907d63d7ad5a0a6827aa23cc922fbf88ef2f8ef62238e3f8efa6160"
    sha256 cellar: :any,                 x86_64_linux:  "b6c934ecfc9633550f6f67af238fc406142f4b9936d8ffb8620c544e905c5e3b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    completion_file = zsh_completion/"_pmx"
    rm completion_file if completion_file.exist?
    generate_completions_from_executable(bin/"pmx", "completion", shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pmx --version")
    output = shell_output("#{bin}/pmx profile list")
    assert_match "No profiles found", output
  end
end
