class Pmx < Formula
  desc "Manage and switch between AI agent profiles across different platforms"
  homepage "https://github.com/NishantJoshi00/pmx"
  url "https://github.com/NishantJoshi00/pmx/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "14bc6207dc78cf96831feee9ee3ddc712084c92350213500c4320383544a5286"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5aaa885f54333960315cef37d5442a0bd9b27a6030525f86770c47115125e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9c223d9e19656088dcd09bb11fb6011f7b1abb1c02a9cbcf4631c2f591c8b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "915b603d6153219f3ad0263cae3658be864f184eb9aa34c2c6256ebb019901a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf0503974e7d4f21e59d2d66b2c70bfc4af588fc3b0644334a3fb553256a68d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77aa8af6e220095501b231113882510fbbe1dd56bac6ab2fb6ffc4f4a0bd06b3"
  end

  depends_on "rust" => :build

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
