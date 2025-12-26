class Filessh < Formula
  desc "Fast and convenient TUI file browser for remote servers"
  homepage "https://github.com/JayanAXHF/filessh"
  url "https://github.com/JayanAXHF/filessh/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "44cb0b960cc3b65bf9db3934c66543f01e70bda142a34385eaa76b46628fcdf9"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/JayanAXHF/filessh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7088de0774ae6c7e3b5958749eeaed2dd00917d1e76658b8c594dc6cfe4e00e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af78dfcb527f2e069b56991ee90b5d09ca7e2007c233d5e1beb8bd715fa4b6f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83cdaadc095a406fa7f0360154aa25ab4c8db60a96c50552fa644464624b1303"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db27d535d107b2fd3b5baee966e34f12b5864a204353fe07335148d1216f24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518d336a08b74bf69633e1ee5fbfab50929d4373e72d10d265cc0745251d2992"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_BRANCH"] = "main"
    ENV["VERGEN_GIT_COMMIT_TIMESTAMP"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filessh --version")
    assert_match "You must provide a host", shell_output("#{bin}/filessh connect 2>&1", 1)
  end
end
